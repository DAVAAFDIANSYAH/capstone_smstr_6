import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

// Firebase & Google Sign-In imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final box = GetStorage();

  final String baseUrl = 'https://auth-rho-ochre.vercel.app';

  @override
  void onInit() {
    super.onInit();
    // Initialize Firebase if not already initialized
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateInput() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    return email.isNotEmpty && password.isNotEmpty && email.contains('@');
  }

  Future<void> loginUser() async {
    if (!validateInput()) {
      Get.snackbar("Error", "Email atau password tidak valid");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']; // 🔥 Ini bagian penting
        final token = data['token'] ?? data['access_token'] ?? '';

        // Print token
        print('Token: $token');

        // Simpan ke GetStorage
        box.write('userName', userData['username'] ?? 'Guest User');
        box.write('userEmail', userData['email'] ?? emailController.text.trim());
        box.write('userPassword', passwordController.text.trim());
        box.write('jwt_token', token); // Simpan token juga

        Get.snackbar("Sukses", "Login berhasil");
        Get.offAllNamed('/bottomnav'); // Route utama aplikasi
      } else if (response.statusCode == 403) {
        Get.snackbar("Error", "Email belum diverifikasi. Silakan verifikasi OTP terlebih dahulu.");
        Get.toNamed('/verify-otp', arguments: {'email': emailController.text.trim()});
      } else if (response.statusCode == 401) {
        Get.snackbar("Login Gagal", "Email atau password salah.");
      } else {
        try {
          final body = jsonDecode(response.body);
          Get.snackbar("Login Gagal", body['message'] ?? 'Terjadi kesalahan');
        } catch (e) {
          print("Login error response: ${response.body}");
          Get.snackbar("Login Gagal", "Terjadi kesalahan pada server");
        }
      }
    } catch (e) {
      print("Login error: $e");
      Get.snackbar("Error", "Gagal terhubung ke server");
    }
  }

   

  Future<void> signInWithGoogle() async {
      final String baseUrl = 'https://auth-rho-ochre.vercel.app';
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

      await googleSignIn.signOut(); // Optional: Logout sebelumnya
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("Login Google dibatalkan pengguna");
        Get.snackbar("Login Dibatalkan", "Pengguna membatalkan login Google.");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Simpan token Google ke GetStorage
      final box = GetStorage();
      if (googleAuth.idToken != null) box.write('google_id_token', googleAuth.idToken);
      if (googleAuth.accessToken != null) box.write('google_access_token', googleAuth.accessToken);

      box.write('userName', googleUser.displayName ?? 'User');
      box.write('userEmail', googleUser.email);
      box.write('authType', 'google');

      print("Login sukses: ${googleUser.displayName} (${googleUser.email})");

      // Kirim id_token ke backend
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': googleAuth.idToken,
          'email': googleUser.email,
          'name': googleUser.displayName ?? 'User',
          'photo_url': googleUser.photoUrl,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jwt = data['access_token'];

        if (jwt != null) {
          box.write('jwt_token', jwt);
          box.write('userId', data['data']['id']);
          print("✅ JWT token berhasil disimpan");
        }

        Get.snackbar("Sukses", "Login Google berhasil");
        Get.offAllNamed('/bottomnav');
      } else {
        // Jika backend gagal, tetap login Google sukses (mode offline)
        Get.snackbar("Warning", "Login berhasil, tapi backend gagal");
        Get.offAllNamed('/bottomnav');
      }
    } catch (e) {
      print("❌ Error saat login Google: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat login: $e");
    }
  }
}
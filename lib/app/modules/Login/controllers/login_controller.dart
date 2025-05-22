import 'package:capstone_project_6/app/modules/Dashboard/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  final String baseUrl = 'http://192.168.18.26:5000'; // Ganti sesuai IP backend-mu jika pakai device fisik

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

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
  Get.snackbar("Sukses", "Login berhasil");
  Get.offAllNamed('/bottomnav'); // atau sesuai nama route Bottomnav di AppPages
} else {
  try {
    final body = jsonDecode(response.body);
    Get.snackbar("Login Gagal", body['message'] ?? 'Terjadi kesalahan');
  } catch (e) {
    print("Login error response: ${response.body}");
    Get.snackbar("Login Gagal", "Terjadi kesalahan pada server");
  }
}
  }
}
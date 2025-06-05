import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../otp/views/otp_view.dart'; // Ganti sesuai path kamu

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final box = GetStorage();

  // Base URL backend (tanpa /register di akhir)
  final String baseUrl = 'https://auth-rho-ochre.vercel.app';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void register() async {
    final username = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 201) {
        // Simpan data user ke local storage
        box.write('userName', username);
        box.write('userEmail', email);
        box.write('userPassword', password);

        try {
          final data = jsonDecode(response.body);
          final message = data['message'] ?? 'Registration Successful';
          Get.snackbar('Success', message);
        } catch (_) {
          Get.snackbar('Success', 'Registration Successful');
        }

        Get.off(() => VerifyOtpView());
      } else {
        String errorMessage = 'Registration failed';
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) {
            errorMessage = body['message'];
          }
        } catch (e) {
          print('Error decoding response: $e');
        }

        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server');
      print('Register error: $e');
    }
  }
}

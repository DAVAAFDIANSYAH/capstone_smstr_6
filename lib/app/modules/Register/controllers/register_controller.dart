import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Login/views/login_view.dart'; // Ganti sesuai path kamu

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;

  final String baseUrl = 'http://192.168.18.26:5000'; // Ganti jika kamu pakai device fisik

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
      Get.snackbar('Success', 'Registration Successful');
      Get.off(() => Login());
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
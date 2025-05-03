import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controller untuk input email dan password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Reactive variable untuk password visibility
  var isPasswordVisible = false.obs;

  // Method untuk toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validasi login sederhana
  bool validateLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    // Gantilah dengan validasi sesuai kebutuhan (misalnya memeriksa email dan password di database)
    return email.isNotEmpty && password.isNotEmpty && email.contains('@');
  }
}

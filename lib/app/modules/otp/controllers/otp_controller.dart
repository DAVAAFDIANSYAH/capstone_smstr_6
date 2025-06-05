import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class VerifyOtpController extends GetxController {
  final otpController = TextEditingController();
  final isLoading = false.obs;

  final String baseUrl = 'https://auth-rho-ochre.vercel.app';

  // ✅ Countdown Timer State
  final RxInt remainingSeconds = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startCountdown(); // Start countdown on init
  }

  void startCountdown() {
    remainingSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar("Error", "Kode OTP harus diisi");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? "OTP berhasil diverifikasi.";
        Get.snackbar("Sukses", message);
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/login');
      } else {
        String errorMsg = 'Kode OTP salah atau kadaluarsa';
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) errorMsg = body['message'];
        } catch (e) {
          print("Gagal parsing error message: $e");
        }
        Get.snackbar("Gagal", errorMsg);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server:\n$e");
      print("Verify OTP Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;

    final email = GetStorage().read('userEmail');
    if (email == null) {
      Get.snackbar("Error", "Email tidak ditemukan. Silakan daftar ulang.");
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print("Resend OTP Status: ${response.statusCode}");
      print("Resend OTP Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Berhasil", "Kode OTP telah dikirim ulang ke email Anda.");
        startCountdown(); // ⬅ Restart timer setelah resend
      } else {
        String errorMsg = 'Gagal mengirim ulang OTP';
        try {
          final body = jsonDecode(response.body);
          if (body['message'] != null) errorMsg = body['message'];
        } catch (_) {}
        Get.snackbar("Gagal", errorMsg);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim ulang OTP:\n$e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel(); // ⬅ Bersihkan timer saat controller ditutup
    super.onClose();
  }
}

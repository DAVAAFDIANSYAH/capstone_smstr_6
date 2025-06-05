import 'package:capstone_project_6/app/modules/otp/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyOtpView extends GetView {
  final VerifyOtpController controller = Get.put(VerifyOtpController());

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String getOtp() {
    return otpControllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.green.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 32),
              Center(
                child: Image.asset(
                  'assets/otp.png', // ← ganti dengan path ilustrasi kamu
                  height: 180,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "OTP Verification",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Enter OTP sent to your email.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.otpController.text = getOtp();
                              controller.verifyOtp();
                            },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Verify OTP", style: TextStyle(fontSize: 16)),
                    ),
                  )),
              SizedBox(height: 16),

              // ⏱ Resend OTP with Countdown Timer
              Obx(() => TextButton(
                    onPressed: controller.remainingSeconds.value == 0 &&
                            !controller.isLoading.value
                        ? () {
                            controller.resendOtp();
                          }
                        : null,
                    child: Text(
                      controller.remainingSeconds.value == 0
                          ? "Resend OTP"
                          : "Resend in ${controller.remainingSeconds.value}s",
                      style: TextStyle(
                        color: controller.remainingSeconds.value == 0
                            ? Colors.blue
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        );
      }
    }

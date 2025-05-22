import 'package:capstone_project_6/app/modules/Login/views/login_view.dart';
import 'package:capstone_project_6/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding extends GetView<OnboardingController> {
  const Onboarding({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/onboard.jpg', // ganti sesuai nama file kamu
            fit: BoxFit.cover,
          ),

          // Overlay content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          const SizedBox(height: 100), // atau coba 80, 60 sesuai kebutuhan

              // Title
             RichText(
                text: TextSpan(
                  style: GoogleFonts.fugazOne(
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  children: [
                    const TextSpan(text: "SWING"),
                    const TextSpan(text: "PRO"),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        // child: Icon(Icons.circle, color: Colors.red, size: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 500),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(Login());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Get Started"),
                  ),
                ),
              ),

              const Spacer(),

              // // Sign up Text
              // GestureDetector(
              //   onTap: () {
              //     controller.goToSignup(); // navigasi signup
              //   },
              //   child: const Text(
              //     "Tidak punya akun? Sign up",
              //     style: TextStyle(color: Colors.white70),
              //   ),
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

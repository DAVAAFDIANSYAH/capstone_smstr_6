import 'package:get/get.dart';

class OnboardingController extends GetxController {
  void login() {
    // Logika login / navigasi
    print("Login tapped");
    // Get.toNamed('/home'); // misalnya
  }

  void goToSignup() {
    // Navigasi ke signup page
    print("Go to Sign up");
    // Get.toNamed('/signup');
  }
}

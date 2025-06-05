import 'package:capstone_project_6/app/modules/Login/views/login_view.dart';
import 'package:capstone_project_6/app/modules/WaveClipper/views/wave_clipper_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class Register extends GetView<RegisterController> {
  Register({Key? key}) : super(key: key) {
    Get.put(RegisterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Header dengan Wave dan Gambar
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  height: 398,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/register.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 80, left: 25, right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Optional header text can go here
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Form Registrasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(height: 400),
                    _buildInputField(
                      controller: controller.nameController,
                      label: 'Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(controller),
                    const SizedBox(height: 30),

                    // Tombol Register
                    ElevatedButton(
                      onPressed: () {
                        controller.register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.blue),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => Login());
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text field umum (Name, Email)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  // Password field dengan toggle visibility
  Widget _buildPasswordField(RegisterController controller) {
    return Obx(() => TextField(
      controller: controller.passwordController,
      obscureText: !controller.isPasswordVisible.value,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.green,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
        hintText: 'Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ));
  }
}

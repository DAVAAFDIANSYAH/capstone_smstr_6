import 'dart:io';
import 'dart:convert';
import 'package:capstone_project_6/app/modules/Dashboard/controllers/dashboard_controller.dart';
import 'package:capstone_project_6/app/modules/Profile/views/editprofile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project_6/app/modules/onboarding/views/onboarding_view.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final box = GetStorage();

  var userName = 'Guest User'.obs;
  var userEmail = 'guest@example.com'.obs;
  var userPassword = '********'.obs;
  var userProfileImage = 'assets/profile.png'.obs; // default asset path
  var isLoading = false.obs;

  final String apiUrl = 'https://auth-rho-ochre.vercel.app/update-profile'; // ganti ini

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    isLoading.value = true;

    userName.value = box.read<String>('userName') ?? 'Guest User';
    userEmail.value = box.read<String>('userEmail') ?? 'guest@example.com';
    userPassword.value = box.read<String>('userPassword') ?? '********';

    // Gunakan email sebagai key karena email lebih stabil
    String? savedImagePath = box.read('userProfileImagePath_${userEmail.value}');
    if (savedImagePath != null && File(savedImagePath).existsSync()) {
      userProfileImage.value = savedImagePath;
    } else {
      userProfileImage.value = 'assets/profile.png';
    }

    isLoading.value = false;
  }

  Future<void> updateProfilePhoto() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    userProfileImage.value = pickedImage.path;
    box.write('userProfileImagePath_${userEmail.value}', pickedImage.path);

    // HANYA DI SINI kita update dashboard
    if (Get.isRegistered<DashboardController>()) {
      final dashboardController = Get.find<DashboardController>();
      dashboardController.updateUserProfileImage(pickedImage.path);
    }

    Get.snackbar('Update Photo', 'Profile photo updated successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}


  // **Update fungsi EditProfile agar kirim ke backend dan update local state/storage**
 Future<void> EditProfile(String name, String email, String password) async {
  isLoading.value = true;

  try {
    final token = box.read('jwt_token') ?? '';
    if (token.isEmpty) {
      Get.snackbar('Error', 'Token tidak ditemukan. Silakan login ulang.',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
      return;
    }

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Kalau email berubah, pindah data gambar
      String oldEmail = userEmail.value;
      String newEmail = email;

      if (oldEmail != newEmail) {
        String? oldImagePath = box.read('userProfileImagePath_$oldEmail');
        if (oldImagePath != null) {
          box.write('userProfileImagePath_$newEmail', oldImagePath);
          box.remove('userProfileImagePath_$oldEmail');
        }
      }

      // Update local state saja (jangan ubah dashboard image!)
      userName.value = name;
      userEmail.value = email;
      userPassword.value = password;

      box.write('userName', name);
      box.write('userEmail', email);
      box.write('userPassword', password);

      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      final resBody = jsonDecode(response.body);
      Get.snackbar('Error', resBody['message'] ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar('Error', 'Connection error: $e',
        snackPosition: SnackPosition.BOTTOM);
  } finally {
    isLoading.value = false;
  }
}

  void changePassword() {
    Get.snackbar(
      'Change Password',
      'Change password functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // JANGAN hapus gambar profile saat logout
              // Hanya hapus data login saja
              box.remove('userName');
              box.remove('userEmail');
              box.remove('userPassword');
              box.remove('jwt_token');
              box.remove('google_access_token');
              box.remove('authType');
              
              // Gambar profile tetap tersimpan dengan key email

              Get.offAll(() => Onboarding());
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
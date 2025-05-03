import 'package:capstone_project_6/app/modules/Login/views/login_view.dart';
import 'package:capstone_project_6/app/modules/onboarding/views/onboarding_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Observable user data
  var userName = 'DAVA AFDIANSYAH'.obs;
  var userEmail = 'dapa@gmail.com'.obs;
  var userPassword = '**********'.obs;
  var userProfileImage = 'assets/profile.png'.obs;
  
  // Loading state
  var isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load user data when controller initializes
    loadUserData();
  }
  
  // Method to load user data (from API, local storage, etc.)
  void loadUserData() {
    isLoading.value = true;
    
    try {
      // Simulate network delay
      Future.delayed(Duration(milliseconds: 500), () {
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load profile data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }
  
  // Method to handle editing profile
  void editProfile() {
    Get.snackbar(
      'Edit Profile',
      'Edit profile functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Method to handle password change
  void changePassword() {
    Get.snackbar(
      'Change Password',
      'Change password functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Method to handle logging out
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
              // Clear user session/data
              _clearUserSession();
              // Navigate to login screen
              Get.offAll(() => Onboarding());
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  // Method to clear user session data
  void _clearUserSession() {
    print('User session cleared');
  }
  
  // Method to update profile photo
  void updateProfilePhoto() {
    Get.snackbar(
      'Update Photo',
      'Profile photo update functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

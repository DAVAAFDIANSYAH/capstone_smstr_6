import 'dart:io';
import 'package:capstone_project_6/app/modules/HistoryLogin/views/history_login_view.dart';
import 'package:capstone_project_6/app/modules/Profile/views/editprofile.dart';
import 'package:capstone_project_6/app/modules/WaveClipper/views/wave_clipper_view.dart';
import 'package:capstone_project_6/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project_6/app/modules/Profile/controllers/profile_controller.dart';

class Profile extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      ),
      body: Obx(() => Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: 170, // boleh disesuaikan tinggi gelombangnya
                    color: Colors.green.shade400,
                  ),
                ),
              ),
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: statusBarHeight + 70),
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.updateProfilePhoto(),
                                  child: Obx(() => Stack(
                                        children: [
                                          Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                              image: DecorationImage(
                                                image: controller
                                                        .userProfileImage.value
                                                        .startsWith('assets/')
                                                    ? AssetImage(controller
                                                        .userProfileImage.value)
                                                    : FileImage(
                                                        File(controller
                                                            .userProfileImage
                                                            .value),
                                                      ) as ImageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                              ),
                                              child: const Icon(
                                                Icons.camera_alt,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Your Profile',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildMenuItem(
                                    Icons.supervised_user_circle_rounded,
                                    controller.userName.value),
                                SizedBox(height: 20),
                                _buildMenuItem(Icons.email_outlined,
                                    controller.userEmail.value),
                                SizedBox(height: 20),
                                _buildMenuItem(Icons.lock_outline,
                                    controller.userPassword.value,
                                    onTap: () => controller.changePassword()),
                                SizedBox(height: 20),

                                // Tampilkan edit profile dan spacing hanya jika login bukan google
                                if (controller.loginMethod.value !=
                                    'google') ...[
                                  _buildMenuItem(Icons.edit, 'Edit Profile',
                                      onTap: () =>
                                          Get.to(() => const EditProfile())),
                                  SizedBox(height: 20),
                                ],

                                _buildMenuItem(Icons.history, 'Riwayat',
                                    onTap: () =>
                                        Get.toNamed(Routes.HISTORY_LOGIN)),
                                SizedBox(height: 20),
                                _buildMenuItem(Icons.logout, 'Log out',
                                    isLogout: true,
                                    onTap: () => controller.logout()),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
            ],
          )),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {bool isLogout = false, VoidCallback? onTap}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isLogout ? Colors.red : Colors.white, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        trailing: isLogout
            ? null
            : Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white70),
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}

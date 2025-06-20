import 'dart:io';
import 'package:capstone_project_6/app/modules/Profile/views/editprofile.dart';
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
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: statusBarHeight + 40),
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.updateProfilePhoto(),
                                  child: Obx(() => Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white, width: 3),
                                          image: DecorationImage(
                                            image: controller.userProfileImage.value
                                                    .startsWith('assets/')
                                                ? AssetImage(
                                                    controller.userProfileImage.value)
                                                : FileImage(
                                                    File(controller.userProfileImage.value))
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                ),
                                SizedBox(height: 40),
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
                                _buildMenuItem(
                                  Icons.edit,
                                  'Edit Profile',
                                  onTap: () => Get.to(() => EditProfile()),
                                ),
                                SizedBox(height: 20),
                                _buildMenuItem(Icons.logout, 'Log out',
                                    isLogout: true, onTap: () => controller.logout()),
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
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.white, size: 20),
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

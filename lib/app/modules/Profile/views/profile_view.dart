import 'package:capstone_project_6/app/modules/Profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends GetView<ProfileController> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
        ),
      ),
      body: Obx(() => Stack(
            children: [
              // Header Hijau Cerah
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50), // Hijau cerah
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),

              // Main Content
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: statusBarHeight + 40),

                          // Foto Profil dari Asset
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => controller.updateProfilePhoto(),
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      image: DecorationImage(
                                        image: AssetImage('assets/orang.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Text(
                                  controller.userName.value,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 3),
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

                          // Menu
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildMenuItem(
                                  Icons.person_outline,
                                  controller.userEmail.value,
                                  onTap: () {},
                                ),
                                SizedBox(height: 20),
                                _buildMenuItem(
                                  Icons.lock_outline,
                                  controller.userPassword.value,
                                  onTap: () => controller.changePassword(),
                                ),
                                SizedBox(height: 20),
                                _buildMenuItem(
                                  Icons.edit,
                                  'Edit Profile',
                                  onTap: () => controller.editProfile(),
                                ),
                                SizedBox(height: 20),
                                _buildMenuItem(
                                  Icons.logout,
                                  'Log out',
                                  isLogout: true,
                                  onTap: () => controller.logout(),
                                ),
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
        color: Color(0xFF2E7D32), // Hijau gelap
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.white,
          size: 20,
        ),
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

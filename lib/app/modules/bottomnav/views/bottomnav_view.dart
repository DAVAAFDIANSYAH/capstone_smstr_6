import 'package:capstone_project_6/app/modules/ArtScan/views/art_scan_view.dart';
import 'package:capstone_project_6/app/modules/Dashboard/views/dashboard_view.dart';
import 'package:capstone_project_6/app/modules/Profile/controllers/profile_controller.dart';
import 'package:capstone_project_6/app/modules/Profile/views/profile_view.dart';
import 'package:capstone_project_6/app/modules/bottomnav/controllers/bottomnav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Bottomnav extends GetView<PageIndexController> {
  @override
  final PageIndexController controller = Get.put(PageIndexController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return Dashboard();
            case 1:
              return ARTScan();
            case 2:
              if (!Get.isRegistered<ProfileController>()) {
                Get.put(ProfileController());
              }
              return Profile();
            default:
              return Dashboard();
          }
        }),
        bottomNavigationBar: Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 5.0), // Untuk mengangkat nav bar sedikit
            child: CurvedNavigationBar(
              index: controller.currentIndex.value,
              height: 60.0,
              backgroundColor: Colors.transparent,
              color: Colors.green.shade400,
              buttonBackgroundColor: Colors.lightGreen,
              animationDuration: const Duration(milliseconds: 300),
              onTap: (index) => controller.changeTab(index),
              items: <Widget>[
                Image.asset('assets/home.png', width: 26, height: 26),
                Image.asset('assets/camera.png', width: 26, height: 26),
                Image.asset('assets/profile.png', width: 26, height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

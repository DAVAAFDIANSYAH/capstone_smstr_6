import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capstone_project_6/app/modules/ArtScan/views/art_scan_view.dart';
import 'package:capstone_project_6/app/modules/tutorial/views/tutorial_view.dart';
import 'package:capstone_project_6/app/modules/Dashboard/controllers/dashboard_controller.dart';
import 'package:capstone_project_6/app/modules/Profile/views/profile_view.dart';

class Dashboard extends GetView<DashboardController> {
  final DashboardController controller = Get.put(DashboardController());

  final List<Map<String, dynamic>> products = List.generate(6, (index) {
    return {
      'image': 'assets/beranda.jpeg',
      'title': 'Stik Golf Full Set Lengkap Carbon',
      'rating': 4.3,
      'price': 'Rp 13.275.000,00',
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return _buildDashboardPage();
          case 1:
            return ARTScan();
          case 2:
            return Tutorial();
          case 3:
            return Profile();
          default:
            return _buildDashboardPage();
        }
      }),
      bottomNavigationBar: Obx(() => CurvedNavigationBar(
            index: controller.currentIndex.value,
            height: 60.0,
            backgroundColor: Colors.transparent,
            color: Colors.green,
            buttonBackgroundColor: Colors.lightGreen,
            onTap: (index) => controller.changeTab(index),
            items: <Widget>[
              Image.asset('assets/home.png', width: 26, height: 26),
              Image.asset('assets/camera.png', width: 26, height: 26),
              Image.asset('assets/video.png', width: 26, height: 26),
              Image.asset('assets/profile.png', width: 26, height: 26),
            ],
          )),
    );
  }

  Widget _buildDashboardPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Good morning Dapzz",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return _buildProductCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              item['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${item['rating']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['price'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:capstone_project_6/app/modules/Dashboard/controllers/dashboard_controller.dart';
import 'package:capstone_project_6/app/modules/barang/controllers/barang_controller.dart';
import 'package:capstone_project_6/app/modules/barang/views/barang_view.dart';
import 'package:capstone_project_6/app/modules/detail/views/detail_view.dart';
import 'package:capstone_project_6/app/modules/history/views/history_view.dart';
import 'package:capstone_project_6/app/modules/statistik/views/statistik_view.dart';
import 'package:capstone_project_6/app/modules/tutorial/views/tutorial_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController controller = Get.put(DashboardController());
  final BarangController barangController = Get.put(BarangController());
  final box = GetStorage();
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userName = box.read('userName') ?? 'Guest User';

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $userName',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1,
                              shadows: const [
                                Shadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 3.0,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Welcome to SwingPRO',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ],
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      Obx(() => CircleAvatar(
                            radius: 35,
                            backgroundImage: controller.userProfileImagePath.value
                                    .startsWith('assets/')
                                ? AssetImage(controller.userProfileImagePath.value)
                                    as ImageProvider
                                : FileImage(File(controller.userProfileImagePath.value)),
                          )),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Promo & Feature Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 190,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildlapangan('assets/g1.jpg'),
                        _buildlapangan('assets/g2.jpg'),
                        _buildlapangan('assets/g3.jpg'),
                        _buildlapangan('assets/g4.jpg'),
                        _buildlapangan('assets/g5.jpg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "FEATURE",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategory(
                          'assets/yt.png',
                          "Tutorial",
                          Colors.blue.shade100,
                          () => Get.to(() => Tutorial()),
                        ),
                        _buildCategory(
                          'assets/data.png',
                          "Visualisasi",
                          Colors.green.shade100,
                          () => Get.toNamed('/statistik'),
                        ),
                        _buildCategory(
                          'assets/history.png',
                          "History",
                          Colors.amber.shade100,
                          () => Get.toNamed('/history'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recomend alat golf",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => Barang()),
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (barangController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (barangController.products.isEmpty) {
                      return const Center(child: Text("Tidak ada produk"));
                    }

                    final productsToShow = barangController.products.length > 2
                        ? barangController.products.sublist(0, 2)
                        : barangController.products;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productsToShow.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final product = productsToShow[index];
                        return _buildProduct(product);
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
      String imagePath, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 30, height: 30, fit: BoxFit.contain),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildlapangan(String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          height: 200,
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProduct(Product product) {
    return InkWell(
      onTap: () => Get.to(() => DetailView(product: product)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: product.gambar.isNotEmpty
                  ? Image.network(
                      product.gambar,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.harga,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

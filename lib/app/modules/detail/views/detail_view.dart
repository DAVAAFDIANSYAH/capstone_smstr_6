import 'package:capstone_project_6/app/modules/barang/controllers/barang_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailView extends GetView {
  final Product product;

  DetailView({Key? key, required this.product}) : super(key: key);

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Tidak bisa membuka link $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.nama,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.gambar,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Nama & Harga
              Text(
                product.nama,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${product.harga}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),

              // Kategori
              Text(
                'Kategori: ${product.kategori}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Deskripsi dummy
              const Text(
                'Deskripsi Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Produk ini merupakan perlengkapan golf berkualitas tinggi, cocok digunakan oleh pemain pemula hingga profesional.',
              ),
              const SizedBox(height: 20),

              // Tombol Link
              Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50, // tinggi button
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(product.link),
                      icon: const Icon(Icons.shopping_cart, size: 24), // ukuran icon
                      label: const Text('Beli Sekarang', style: TextStyle(fontSize: 16)), // ukuran text
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // padding bisa dikurangi kalau mau lebih pas
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

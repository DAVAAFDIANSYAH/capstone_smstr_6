import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class BarangController extends GetxController {
  var products = <Product>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://auth-rho-ochre.vercel.app/barang')); // Gunakan `10.0.2.2` di emulator Android
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        products.value = data.map((item) => Product.fromJson(item)).toList();
      } else {
        Get.snackbar('Error', 'Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class Product {
  final String id;
  final String nama;
  final String kategori;
  final String harga;
  final String link;
  final String gambar;

  Product({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.link,
    required this.gambar,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      nama: json['nama'],
      kategori: json['kategori'],
      harga: json['harga'],
      link: json['link'],
      gambar: json['gambar'],
    );
  }
}



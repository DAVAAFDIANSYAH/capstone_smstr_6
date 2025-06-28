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
      final response = await http.get(Uri.parse('https://auth-rho-ochre.vercel.app/barang'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];

        // Debugging optional: log tipe data harga
        // for (var item in data) {
        //   print('Harga: ${item['harga']} | Tipe: ${item['harga'].runtimeType}');
        // }

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
  final int harga;
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
      harga: int.tryParse(json['harga'].toString()) ?? 0, // aman untuk string/int/null
      link: json['link'],
      gambar: json['gambar'],
    );
  }
}

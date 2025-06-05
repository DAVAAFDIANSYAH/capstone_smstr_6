import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatistikController extends GetxController {
  final String baseUrl = 'https://auth-rho-ochre.vercel.app'; // ganti sesuai IP/backend kamu

  var articles = <Map<String, dynamic>>[].obs;
  var lokasi = <Map<String, dynamic>>[].obs;
  var tutorial = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var errorMsg = ''.obs;

  Future<void> fetchArticles() async {
    try {
      isLoading(true);
      errorMsg('');
      final res = await http.get(Uri.parse('$baseUrl/article'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        articles.assignAll(List<Map<String, dynamic>>.from(data['data']));
      } else {
        errorMsg('Gagal mengambil data artikel');
      }
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchLokasi() async {
    try {
      isLoading(true);
      errorMsg('');
      final res = await http.get(Uri.parse('$baseUrl/lokasi'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        lokasi.assignAll(List<Map<String, dynamic>>.from(data['data']));
      } else {
        errorMsg('Gagal mengambil data lokasi');
      }
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTutorial() async {
    try {
      isLoading(true);
      errorMsg('');
      final res = await http.get(Uri.parse('$baseUrl/tutorial'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        tutorial.assignAll(List<Map<String, dynamic>>.from(data['data']));
      } else {
        errorMsg('Gagal mengambil data tutorial');
      }
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      isLoading(false);
    }
  }
  
}

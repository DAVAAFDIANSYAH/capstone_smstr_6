import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class HistoryLoginController extends GetxController {
  final box = GetStorage();
  var loginHistory = [].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://auth-rho-ochre.vercel.app';

  @override
  void onInit() {
    super.onInit();
    fetchLoginHistory();
  }

  @override
  void onReady() {
    super.onReady();
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    isLoading.value = true;
    final token = box.read('jwt_token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/login-history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> rawHistory = data['history'];

        // Map untuk tracking provider per email
        Map<String, String> providerMap = {};

        // Proses dan normalisasi data
        List<Map<String, dynamic>> processedHistory = rawHistory.map((item) {
          Map<String, dynamic> processed = {
            'email': item['email'] ?? 'Unknown',
            'status': item['status'] ?? 'login',
            'device_info': item['device_info'] ?? 'Unknown Device',
            'auth_provider': item['auth_provider'] ?? 'local',
            'parsed_timestamp': _parseDate(item),
          };
          return processed;
        }).toList();

        // Urutkan berdasarkan waktu (lama ke baru) untuk tracking provider
        processedHistory.sort((a, b) => 
          a['parsed_timestamp'].compareTo(b['parsed_timestamp']));

        // Fix provider inconsistency
        for (var item in processedHistory) {
          String email = item['email'];
          String status = item['status'].toLowerCase();
          String provider = item['auth_provider'].toLowerCase();

          if (status == 'login') {
            providerMap[email] = provider;
          } else if (status == 'logout' && providerMap[email] != null) {
            item['auth_provider'] = providerMap[email];
          }
        }

        // Urutkan kembali (terbaru ke lama)
        processedHistory.sort((a, b) => 
          b['parsed_timestamp'].compareTo(a['parsed_timestamp']));

        loginHistory.value = processedHistory;
      } else {
        Get.snackbar('Gagal', 'Error ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi bermasalah');
    } finally {
      isLoading.value = false;
    }
  }

  DateTime _parseDate(dynamic item) {
    dynamic rawDate = item['timestamp'] ?? item['login_at'] ?? item['created_at'];
    
    if (rawDate == null) return DateTime.now();
    
    try {
      if (rawDate is String) {
        return DateTime.parse(rawDate).toLocal();
      } else if (rawDate is Map && rawDate.containsKey('\$date')) {
        return DateTime.parse(rawDate['\$date']).toLocal();
      }
    } catch (e) {
      // Silent fail, return current time
    }
    return DateTime.now();
  }

  Future<void> refreshData() async {
    await fetchLoginHistory();
  }
}
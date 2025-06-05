import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class HistoryController extends GetxController {
  static const String _baseUrl = 'https://auth-rho-ochre.vercel.app';
  static const String _endpoint = '/deteksi';
  static const String apiUrl = '$_baseUrl$_endpoint';

  var isLoading = false.obs;
  var historyList = <PoseHistory>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPoseHistory();
  }

  Future<void> fetchPoseHistory() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final box = GetStorage();
      final token = box.read('jwt_token');
      final email = box.read('user_email');

      
      if (token == null) {
        errorMessage.value = 'Token otentikasi tidak ditemukan, silakan login ulang';
        Get.snackbar(
          'Error', 
          'Token tidak ditemukan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      debugPrint('🚀 Mengambil history pose...');
      debugPrint('🚀 API URL: $apiUrl');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Server tidak merespons');
        },
      );

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> dataList = responseData['data'] ?? [];
        
        historyList.value = dataList.map((item) => PoseHistory.fromJson(item)).toList();
        
        debugPrint('✅ Berhasil mengambil ${historyList.length} history');
        
        if (historyList.isEmpty) {
          errorMessage.value = 'Belum ada history pose yang tersimpan';
        }
      } else {
        String errorMsg = 'Gagal mengambil history';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
        } catch (e) {
          errorMsg = 'Server error: ${response.statusCode}';
        }
        
        errorMessage.value = errorMsg;
        Get.snackbar(
          'Error', 
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('❌ Error fetching history: $e');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      Get.snackbar(
        'Error', 
        'Gagal mengambil data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHistory() async {
    await fetchPoseHistory();
  }

  void clearHistory() {
    historyList.clear();
    errorMessage.value = '';
  }
}

class PoseHistory {
  final String id;
  final String label;
  final String timestamp;
  final String image;

  PoseHistory({
    required this.id,
    required this.label,
    required this.timestamp,
    required this.image,
  });

  factory PoseHistory.fromJson(Map<String, dynamic> json) {
    return PoseHistory(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      timestamp: json['timestamp'] ?? '',
      image: json['image'] ?? '',
    );
  }

  String get formattedDate {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}
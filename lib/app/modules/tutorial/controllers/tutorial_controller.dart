// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class TutorialController extends GetxController {
//   final RxList<Map<String, dynamic>> tutorialVideos = <Map<String, dynamic>>[].obs;
//   final RxBool isLoading = true.obs;
//   final RxString query = 'golf tutorial'.obs;

//   final String apiKey = 'AIzaSyA7WupuxKd5FenRlBJN1vGze5CC3BQioL8';

//   @override
//   void onInit() {
//     super.onInit();
//     fetchTutorials(); // Load default "golf tutorial"
//   }

//   Future<void> fetchTutorials() async {
//     isLoading.value = true;

//     final url = Uri.parse(
//       'https://www.googleapis.com/youtube/v3/search'
//       '?part=snippet'
//       '&type=video'
//       '&q=${Uri.encodeQueryComponent(query.value)}'
//       '&videoDuration=medium'
//       '&safeSearch=strict'
//       '&order=relevance'
//       '&maxResults=10'
//       '&key=$apiKey',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final videos = data['items'] as List;

//         tutorialVideos.assignAll(
//           videos.map((item) {
//             final snippet = item['snippet'];
//             return {
//               'videoId': item['id']['videoId'],
//               'title': snippet['title'],
//               'description': snippet['description'],
//               'thumbnailUrl': snippet['thumbnails']['high']['url'],
//             };
//           }).where((video) => video['videoId'] != null).toList(),
//         );
//       } else {
//         Get.snackbar('Error', 'Failed to fetch videos: ${response.body}');
//       }
//     } catch (e) {
//       Get.snackbar('Exception', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Digunakan saat pengguna mengetik kata kunci teknik (misal: "swing")
//   void searchByTechnique(String technique) {
//     if (technique.trim().isEmpty) return;
//     query.value = 'golf $technique tutorial';
//     fetchTutorials();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TutorialController extends GetxController {
  final RxList<Map<String, dynamic>> tutorialVideos = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString query = 'golf tutorial'.obs;

  final String apiKey = 'AIzaSyA7WupuxKd5FenRlBJN1vGze5CC3BQioL8';

  // Daftar kata kunci teknik golf yang diperbolehkan
  final List<String> allowedKeywords = [
    'swing',
    'putting',
    'chipping',
    'bunker',
    'iron',
    'driver',
    'short game',
    'long game',
    'pitch',
    'golf',
    'tee',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTutorials(); // Load default "golf tutorial"
  }

  Future<void> fetchTutorials() async {
    isLoading.value = true;

    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
      '?part=snippet'
      '&type=video'
      '&q=${Uri.encodeQueryComponent(query.value)}'
      '&videoDuration=medium'
      '&safeSearch=strict'
      '&order=relevance'
      '&maxResults=10'
      '&key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = data['items'] as List;

        tutorialVideos.assignAll(
          videos.map((item) {
            final snippet = item['snippet'];
            return {
              'videoId': item['id']['videoId'],
              'title': snippet['title'],
              'description': snippet['description'],
              'thumbnailUrl': snippet['thumbnails']['high']['url'],
            };
          }).where((video) => video['videoId'] != null).toList(),
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch videos: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Validasi teknik hanya boleh kata kunci golf, lalu fetch
  void searchByTechnique(String technique) {
    final lowerInput = technique.trim().toLowerCase();

    final isValid = allowedKeywords.any((keyword) => lowerInput.contains(keyword));

    if (!isValid) {
      Get.snackbar(
        'Invalid Search',
        'Please search for golf-related techniques only.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText:  Colors.black,
      );
      return;
    }

    query.value = 'golf $lowerInput tutorial';
    fetchTutorials();
  }
}

import 'package:get/get.dart';

class TutorialController extends GetxController {
  final RxList<TutorialVideo> tutorialVideos = <TutorialVideo>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadGolfTutorials();
  }

  // Memuat tutorial yang berhubungan dengan golf
  void loadGolfTutorials() {
    // Simulasi data tutorial golf
    // Dalam aplikasi produksi, ini bisa berasal dari API atau Firebase
    Future.delayed(const Duration(seconds: 1), () {
      tutorialVideos.addAll([
        TutorialVideo(
          id: 'me5gjIUe1Ks',
          title: 'Golf Club: Tips Driving untuk Pemula',
          description: 'Belajar tips driving untuk pemula di golf.',
          thumbnailUrl: 'https://img.youtube.com/vi/me5gjIUe1Ks/0.jpg',
        ),
        TutorialVideo(
          id: 'r5u52YuNVG8',
          title: 'TOP 5 DRIVER GOLF TIPS',
          description: 'Pelajari teknik dasar swing dalam golf untuk pemula.',
          thumbnailUrl: 'https://img.youtube.com/vi/r5u52YuNVG8/0.jpg',
        ),
        TutorialVideo(
          id: 'hhB1k2PSjWA',
          title: 'Quick Tips: Basic Tips to Hit a Driver',
          description: 'Tips dasar untuk memukul driver dengan benar.',
          thumbnailUrl: 'https://img.youtube.com/vi/hhB1k2PSjWA/0.jpg',
        ),
      ]);
      isLoading.value = false;
    });
  }
}

class TutorialVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;

  TutorialVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });
}

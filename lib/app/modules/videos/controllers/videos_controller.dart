import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerController extends GetxController {
  // Observable untuk controller YouTube
  Rx<YoutubePlayerController?> youtubeController = Rx<YoutubePlayerController?>(null);
  
  // Observable untuk status pemutaran
  final isPlaying = false.obs;
  final currentPosition = 0.obs;
  final videoDuration = 0.obs;
  final videoTitle = ''.obs;
  final isFullScreen = false.obs;
  
  // Metode untuk menginisialisasi controller YouTube
  void initializeYoutubeController(String videoId) {
    // Dispose controller lama jika ada
    youtubeController.value?.dispose();
    
    // Buat controller baru
    youtubeController.value = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    
    // Tambahkan listener untuk memantau perubahan status
    youtubeController.value!.addListener(_videoListener);
  }
  
  // Listener untuk memantau status video
  void _videoListener() {
    if (youtubeController.value != null) {
      // Update status pemutaran
      isPlaying.value = youtubeController.value!.value.isPlaying;
      
      // Update posisi pemutaran (dalam detik)
      currentPosition.value = youtubeController.value!.value.position.inSeconds;
      
      // Update durasi video jika tersedia
      if (youtubeController.value!.metadata.duration.inSeconds > 0) {
        videoDuration.value = youtubeController.value!.metadata.duration.inSeconds;
      }
      
      // Update judul video
      if (youtubeController.value!.metadata.title.isNotEmpty) {
        videoTitle.value = youtubeController.value!.metadata.title;
      }
    }
  }
  
  // Metode kontrol video
  void playVideo() {
    youtubeController.value?.play();
  }
  
  void pauseVideo() {
    youtubeController.value?.pause();
  }
  
  void seekTo(Duration position) {
    youtubeController.value?.seekTo(position);
  }
  
  void toggleFullScreen() {
    isFullScreen.toggle();
    youtubeController.value?.toggleFullScreenMode();
  }
  
  // Reload video dengan ID baru
  void loadVideo(String videoId) {
    youtubeController.value?.load(videoId);
  }
  
  // Fungsi helper untuk format durasi
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void onClose() {
    // Hapus listener untuk mencegah memory leak
    youtubeController.value?.removeListener(_videoListener);
    
    // Dispose controller YouTube
    youtubeController.value?.dispose();
    super.onClose();
  }
}
import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Observable list history
  var history = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Contoh data dummy
    history.addAll([
      {
        'title': 'Golf Club Analysis',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'thumbnailUrl': 'assets/orang.jpg',
        'confidence': 0.92,
        'result': 'Driver Club',
        'notes': 'Good condition, slight wear on grip',
      },
      {
        'title': 'Iron Swing Detection',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'thumbnailUrl': 'assets/orang.jpg',
        'confidence': 0.88,
        'result': '7-Iron Club',
        'notes': 'Potential alignment issue detected',
      },
      {
        'title': 'Putter Analysis',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'thumbnailUrl': 'assets/orang.jpg',
        'confidence': 0.95,
        'result': 'Blade Putter',
        'notes': 'Excellent condition',
      },
    ]);
  }

  void deleteHistory(int index) {
    history.removeAt(index);
  }
}

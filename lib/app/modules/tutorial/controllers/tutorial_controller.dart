import 'package:get/get.dart';

class TutorialController extends GetxController {
  // Observable list of tutorials
  final tutorials = [
    {
      'title': 'Golf Club: Tips Driving untuk Pemula',
      'videoId': 'me5gjIUe1Ks',
    },
    {
      'title': 'Belajar Swing Dasar dalam Golf',
      'videoId': 'dQw4w9WgXcQ',
    },
    {
      'title': 'Teknik Putting Profesional',
      'videoId': '3JZ_D3ELwOQ',
    },
  ].obs;

  // Method to add a new tutorial
  void addTutorial(Map<String, String> newTutorial) {
    tutorials.add(newTutorial);
  }
}

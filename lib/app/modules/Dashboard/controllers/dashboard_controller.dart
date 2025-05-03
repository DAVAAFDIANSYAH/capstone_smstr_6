import 'package:get/get.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var currentIndex = 0.obs; // FIX: jadi reaktif

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  void changeTab(int index) {
    currentIndex.value = index; // FIX: pakai .value
  }
}

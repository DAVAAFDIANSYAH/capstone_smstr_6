import 'package:get/get.dart';
import 'package:capstone_project_6/app/modules/bottomnav/controllers/bottomnav_controller.dart';
import 'package:capstone_project_6/app/modules/Profile/controllers/profile_controller.dart';

class BottomnavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PageIndexController());
    Get.put(ProfileController());
    // Tambahkan controller lain yang dibutuhkan di Bottomnav
  }
}

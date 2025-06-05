import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  final box = GetStorage();

  var userName = 'Guest User'.obs;

  // Observable untuk path foto profil
  var userProfileImagePath = 'assets/orang.jpg'.obs;

  // Observable data cuaca (contoh)
  var temperature = 0.0.obs;
  var weatherDescription = ''.obs;
  var isLoadingWeather = true.obs;
  var weatherError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    loadUserProfileImage();
  }

  void loadUserName() {
    final storedName = box.read('userName');
    if (storedName != null && storedName.toString().trim().isNotEmpty) {
      userName.value = storedName.toString().trim();
    } else {
      userName.value = 'Guest User';
    }
  }

  void loadUserProfileImage() {
  final email = box.read('userEmail');
  if (email != null && email.toString().trim().isNotEmpty) {
    String? storedImagePath = box.read('userProfileImagePath_$email');
    if (storedImagePath != null && storedImagePath.isNotEmpty && File(storedImagePath).existsSync()) {
      userProfileImagePath.value = storedImagePath;
    } else {
      userProfileImagePath.value = 'assets/orang.jpg'; // default image
    }
  } else {
    userProfileImagePath.value = 'assets/orang.jpg';
  }
}

void updateUserProfileImage(String newImagePath) {
  userProfileImagePath.value = newImagePath;
  final email = box.read('userEmail');
  if (email != null && email.toString().trim().isNotEmpty) {
    box.write('userProfileImagePath_$email', newImagePath);
  }
}



  // Jika ingin refresh data user (misal setelah update foto)
  void refreshUserData() {
    loadUserName();
    loadUserProfileImage();
  }
}

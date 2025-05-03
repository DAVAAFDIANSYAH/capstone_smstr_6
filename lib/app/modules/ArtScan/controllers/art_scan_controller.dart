import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ARTScanController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var image = Rx<File?>(null);
  var imageUrl = Rx<String?>(null);
  var detectionResult = Rx<String?>(null);
  var recyclingInstruction = Rx<String?>(null);
  var isCameraActive = false.obs;

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        imageUrl.value = pickedFile.path;
      } else {
        image.value = File(pickedFile.path);
      }
      detectionResult.value = null;
      recyclingInstruction.value = null;
    }
  }

  Future<void> openCamera() async {
    isCameraActive.value = true;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );

    isCameraActive.value = false;

    if (pickedFile != null) {
      if (kIsWeb) {
        imageUrl.value = pickedFile.path;
      } else {
        image.value = File(pickedFile.path);
      }
      detectionResult.value = null;
      recyclingInstruction.value = null;
    }
  }

  void detectWaste() {
    detectionResult.value = "Botol Plastik PET";
    recyclingInstruction.value =
        "1. Bersihkan botol dari sisa cairan\n2. Lepaskan label jika memungkinkan\n3. Tekan untuk menghemat ruang\n4. Masukkan ke tempat sampah daur ulang plastik";
  }

  bool get hasImage => image.value != null || imageUrl.value != null;
}

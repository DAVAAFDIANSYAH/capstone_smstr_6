import 'package:get/get.dart';

import '../controllers/wave_clipper_controller.dart';

class WaveClipperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaveClipperController>(
      () => WaveClipperController(),
    );
  }
}

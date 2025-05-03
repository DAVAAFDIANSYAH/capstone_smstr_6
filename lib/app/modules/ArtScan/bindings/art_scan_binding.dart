import 'package:get/get.dart';

import '../controllers/art_scan_controller.dart';

class ArtScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ARTScanController>(
      () => ARTScanController(),
    );
  }
}

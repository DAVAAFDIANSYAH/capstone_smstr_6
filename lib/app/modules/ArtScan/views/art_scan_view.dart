import 'package:capstone_project_6/app/modules/ArtScan/controllers/art_scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ARTScan extends GetView<ARTScanController> {
  final ARTScanController controller = Get.put(ARTScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/scan.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay to darken image slightly (optional, for readability)
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Obx(() {
                            return controller.isCameraActive.value
                                ? _loadingPreview()
                                : _imagePreview();
                          }),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => controller.detectionResult.value != null
                            ? _detectionCard()
                            : const SizedBox()),
                        const SizedBox(height: 30),
                        _actionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingPreview() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _imagePreview() {
    return Obx(() {
      return Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: kIsWeb
              ? (controller.imageUrl.value == null
                  ? _emptyPreview()
                  : Image.network(controller.imageUrl.value!, fit: BoxFit.cover))
              : (controller.image.value == null
                  ? _emptyPreview()
                  : Image.file(controller.image.value!, fit: BoxFit.cover)),
        ),
      );
    });
  }

  Widget _emptyPreview() => const Center(
        child: Text("Pilih atau ambil gambar", style: TextStyle(color: Colors.white)),
      );

  Widget _detectionCard() {
    return Obx(() => Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hasil Deteksi:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(controller.detectionResult.value ?? "",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 15),
                const Text("Cara Daur Ulang:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(controller.recyclingInstruction.value ?? "",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ));
  }

  Widget _actionButtons() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _iconAction(Icons.photo_library, "Galeri", controller.pickImage),
            _iconAction(Icons.camera_alt, "Kamera", controller.openCamera),
            _iconAction(
              Icons.search,
              "Deteksi",
              controller.hasImage ? controller.detectWaste : null,
              isDisabled: !controller.hasImage,
            ),
          ],
        ));
  }

  Widget _iconAction(IconData icon, String label, VoidCallback? onPressed,
      {bool isDisabled = false}) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon,
              color: isDisabled ? Colors.white38 : Colors.white, size: 40),
          tooltip: label,
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))
      ],
    );
  }
}

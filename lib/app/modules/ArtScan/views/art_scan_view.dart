import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/art_scan_controller.dart';

class ARTScan extends GetView<ARTScanController> {
  final ARTScanController controller = Get.put(ARTScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pose Detection'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (!controller.isCameraInitialized.value) {
            return Center(
              child: ElevatedButton(
                onPressed: controller.startCamera,
                child: const Text('Start Camera'),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Tampilkan preview kamera
                    CameraPreview(controller.cameraController!),
                    
                    // ✅ Loading overlay saat sedang menyimpan
                    if (controller.isSaving.value)
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Menyimpan pose...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Overlay informasi dan tombol simpan
                    Positioned(
                      bottom: 24,
                      left: 16,
                      right: 16,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              controller.predictedLabel.value != 'unknown'
                                  ? 'Detected: ${controller.predictedLabel.value}'
                                  : 'Detecting pose...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // ✅ Tombol simpan dengan loading state
                          if (controller.predictedLabel.value != 'unknown')
                            ElevatedButton.icon(
                              onPressed: controller.isSaving.value 
                                  ? null 
                                  : controller.saveDetectedPose,
                              icon: controller.isSaving.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.save),
                              label: Text(
                                controller.isSaving.value ? 'Menyimpan...' : 'Simpan'
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isSaving.value 
                                    ? Colors.grey 
                                    : Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // ✅ Kontrol kamera: Stop & Switch - disable saat saving
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.isSaving.value 
                          ? null 
                          : controller.stopCamera,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isSaving.value 
                            ? Colors.grey 
                            : Colors.red,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: controller.isSaving.value 
                          ? null 
                          : controller.switchCamera,
                      icon: const Icon(Icons.flip_camera_android),
                      label: const Text('Switch'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isSaving.value 
                            ? Colors.grey 
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ARTScanController extends GetxController {
  final String apiUrl = 'https://auth-rho-ochre.vercel.app/deteksi';

  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  var isCameraInitialized = false.obs;
  var isSaving = false.obs;
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  var predictedLabel = 'unknown'.obs;
  bool isDetecting = false;

  // Buffer untuk counting sudut
  final List<double> shoulderAngles = [];
  final List<double> elbowAngles = [];
  final List<double> hipAngles = [];
  final int angleBufferSize = 10;

  String lastDetectedLabel = 'unknown';

  @override
  void onInit() {
    super.onInit();
    startCamera();
  }

  @override
  void onClose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    poseDetector.close();
    super.onClose();
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> stopCamera() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
  }

  Future<void> switchCamera() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await stopCamera();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> initializeCamera(int cameraIndex) async {
    try {
      final selectedCamera = cameras[cameraIndex];

      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await cameraController!.initialize();
      await cameraController!.startImageStream(processCameraImage);
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('❌ Camera init error: $e');
    }
  }

  void processCameraImage(CameraImage image) async {
    if (isDetecting || isSaving.value) return;
    isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final rotation = InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        isDetecting = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        final landmarks = poses.first.landmarks;

        final shoulder = landmarks[PoseLandmarkType.rightShoulder];
        final elbow = landmarks[PoseLandmarkType.rightElbow];
        final wrist = landmarks[PoseLandmarkType.rightWrist];
        final hip = landmarks[PoseLandmarkType.rightHip];
        final knee = landmarks[PoseLandmarkType.rightKnee];

        if ([shoulder, elbow, wrist, hip, knee].every((e) => e != null)) {
          final angleShoulder = calculateAngle(
            Offset(elbow!.x, elbow.y),
            Offset(shoulder!.x, shoulder.y),
            Offset(hip!.x, hip.y),
          );

          final angleElbow = calculateAngle(
            Offset(shoulder.x, shoulder.y),
            Offset(elbow.x, elbow.y),
            Offset(wrist!.x, wrist.y),
          );

          final angleHip = calculateAngle(
            Offset(shoulder.x, shoulder.y),
            Offset(hip.x, hip.y),
            Offset(knee!.x, knee.y),
          );

          // Tambahkan ke buffer
          shoulderAngles.add(angleShoulder);
          elbowAngles.add(angleElbow);
          hipAngles.add(angleHip);

          if (shoulderAngles.length > angleBufferSize) shoulderAngles.removeAt(0);
          if (elbowAngles.length > angleBufferSize) elbowAngles.removeAt(0);
          if (hipAngles.length > angleBufferSize) hipAngles.removeAt(0);

          // Lakukan klasifikasi hanya jika buffer penuh
          if (shoulderAngles.length == angleBufferSize) {
            final maxShoulder = shoulderAngles.reduce(max);
            final minElbow = elbowAngles.reduce(min);
            final avgHip = hipAngles.reduce((a, b) => a + b) / hipAngles.length;

            final swingLabel = classifySwing(maxShoulder, minElbow, avgHip);

            if (swingLabel != lastDetectedLabel && swingLabel != 'Unknown') {
              predictedLabel.value = swingLabel;
              lastDetectedLabel = swingLabel;

              // Kosongkan buffer agar tidak double counting
              shoulderAngles.clear();
              elbowAngles.clear();
              hipAngles.clear();

              debugPrint('✅ Predicted: $swingLabel');
            }
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Pose detection error: $e");
    } finally {
      isDetecting = false;
    }
  }

  double calculateAngle(Offset a, Offset b, Offset c) {
    final radians = atan2(c.dy - b.dy, c.dx - b.dx) - atan2(a.dy - b.dy, a.dx - b.dx);
    var angle = radians * 180 / pi;
    angle = angle.abs();
    if (angle > 180) {
      angle = 360 - angle;
    }
    return angle;
  }

  String classifySwing(double angleShoulder, double angleElbow, double angleHip) {
    if (angleShoulder < 80 && angleElbow > 100 && angleHip > 160) {
      return 'Putting';
    } else if (angleShoulder > 150 && angleElbow < 70) {
      return 'Full Swing';
    } else if (90 <= angleShoulder && angleShoulder <= 140 && 100 <= angleHip && angleHip <= 150) {
      return 'Half Swing';
    } else {
      return 'Unknown';
    }
  }

 Future<void> saveDetectedPose() async {
  if (predictedLabel.value == 'unknown') {
    Get.snackbar(
      'Info',
      'Tidak ada pose terdeteksi untuk disimpan',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
    return;
  }

  if (cameraController == null || !cameraController!.value.isInitialized) {
    Get.snackbar(
      'Error',
      'Kamera belum siap',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  isSaving.value = true;

  try {
    bool wasStreaming = cameraController!.value.isStreamingImages;
    if (wasStreaming) {
      await cameraController!.stopImageStream();
    }

    // 🔒 Matikan flash sebelum mengambil foto
    await cameraController!.setFlashMode(FlashMode.off);

    final XFile picture = await cameraController!.takePicture();
    final bytes = await picture.readAsBytes();
    final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

    final box = GetStorage();
    final token = box.read('jwt_token');
    if (token == null) {
      Get.snackbar(
        'Error',
        'Token otentikasi tidak ditemukan, silakan login ulang',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'label': predictedLabel.value,
        'image': base64Image,
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Request timeout - Server tidak merespons');
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar(
        'Berhasil',
        'Pose "${predictedLabel.value}" berhasil disimpan ke database',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      predictedLabel.value = 'unknown';
    } else {
      String errorMessage = 'Gagal menyimpan pose';
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        errorMessage = 'Server error: ${response.statusCode}';
      }

      Get.snackbar(
        'Gagal',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    if (wasStreaming && cameraController != null && !cameraController!.value.isStreamingImages) {
      await cameraController!.startImageStream(processCameraImage);
    }
  } catch (e) {
    debugPrint('❌ Save error: $e');
    Get.snackbar(
      'Error',
      'Terjadi kesalahan: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    try {
      if (cameraController != null && !cameraController!.value.isStreamingImages) {
        await cameraController!.startImageStream(processCameraImage);
      }
    } catch (restartError) {
      debugPrint('❌ Error restarting stream: $restartError');
    }
  } finally {
    isSaving.value = false;
    }
  }
}
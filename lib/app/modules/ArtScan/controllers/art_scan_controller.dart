import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:http/http.dart' as http;

class ARTScanController extends GetxController {
  final String apiUrl = 'https://auth-rho-ochre.vercel.app/deteksi';

  late Interpreter interpreter;
  List<String> labels = [];
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  var isCameraInitialized = false.obs;
  var isSaving = false.obs; // ✅ Tambahkan loading state untuk save
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  var predictedLabel = 'unknown'.obs;
  bool isDetecting = false;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  @override
  void onClose() {
    cameraController?.stopImageStream();
    cameraController?.dispose();
    interpreter.close();
    poseDetector.close();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/pose_detection_model.tflite');
      final labelData = await rootBundle.loadString('assets/labels/label.txt');
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      debugPrint('✅ Model loaded');
      debugPrint('Labels: ${labels.length}');
    } catch (e) {
      debugPrint("❌ Error loading model: $e");
    }
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
    if (isDetecting || isSaving.value) return; // ✅ Jangan proses jika sedang save
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
        debugPrint("❌ Format tidak didukung: ${image.format.raw}");
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
        final List<double> keypoints = [];
        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
        }

        if (keypoints.length == 99) {
          final input = [keypoints];
          final outputTensor = interpreter.getOutputTensor(0);
          final output = List.generate(
              1, (_) => List.filled(outputTensor.shape[1], 0.0));
          interpreter.run(input, output);

          final predictions = output[0];
          final maxIndex =
              predictions.indexWhere((e) => e == predictions.reduce(max));
          if (maxIndex >= 0 && maxIndex < labels.length) {
            predictedLabel.value = labels[maxIndex];
            debugPrint("✅ Predicted: ${predictedLabel.value}");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Pose detection error: $e");
    } finally {
      isDetecting = false;
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

    // ✅ Set loading state
    isSaving.value = true;

    try {
      // ✅ Stop stream untuk ambil gambar
      bool wasStreaming = cameraController!.value.isStreamingImages;
      if (wasStreaming) {
        await cameraController!.stopImageStream();
      }

      // ✅ Ambil gambar
      final XFile picture = await cameraController!.takePicture();
      final bytes = await picture.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      // ✅ Ambil token
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

      debugPrint('🚀 Mengirim data ke server...');
      debugPrint('Label: ${predictedLabel.value}');
      debugPrint('API URL: $apiUrl');

      // ✅ Kirim ke server dengan timeout
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

      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📡 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil', 
          'Pose "${predictedLabel.value}" berhasil disimpan ke database',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // ✅ Reset predicted label setelah berhasil save
        predictedLabel.value = 'unknown';
        
      } else {
        // ✅ Handle error response
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
          duration: const Duration(seconds: 4),
        );
      }

      // ✅ Restart image stream jika sebelumnya aktif
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
        duration: const Duration(seconds: 4),
      );
      
      // ✅ Restart image stream jika error
      try {
        if (cameraController != null && !cameraController!.value.isStreamingImages) {
          await cameraController!.startImageStream(processCameraImage);
        }
      } catch (restartError) {
        debugPrint('❌ Error restarting stream: $restartError');
      }
    } finally {
      // ✅ Reset loading state
      isSaving.value = false;
    }
  }
}
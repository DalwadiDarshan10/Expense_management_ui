// import 'dart:io';
import 'package:camera/camera.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceIdController extends GetxController {
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isFlashOn = false.obs;
  final RxBool hasPermission = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _checkPermissionAndInitCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  /// Check permissions and initialize camera
  Future<void> _checkPermissionAndInitCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      hasPermission.value = true;
      _initCamera();
    } else {
      hasPermission.value = false;
      // Optionally show dialog or settings
    }
  }

  /// Initialize the first available camera
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Use the front camera if available, otherwise first
        final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );

        cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await cameraController!.initialize();
        if (cameraController!.value.isInitialized) {
          isCameraInitialized.value = true;
          // Reset flash state based on camera capabilities if needed,
          // but usually flash is off by default.
        }
      }
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  /// Toggle Flashlight
  Future<void> toggleFlash() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      if (isFlashOn.value) {
        await cameraController!.setFlashMode(FlashMode.off);
        isFlashOn.value = false;
      } else {
        await cameraController!.setFlashMode(FlashMode.torch);
        isFlashOn.value = true;
      }
    }
  }

  /// Pick Image from Gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Handle selected image
        Get.snackbar("Image Selected", "Path: ${image.path}");
        // Here you would typically process the face image
      }
    } catch (e) {
      Get.snackbar(AppStrings.errorTitle, "Failed to pick image");
    }
  }
}

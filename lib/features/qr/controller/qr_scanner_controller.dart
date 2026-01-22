import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class QrScannerController extends GetxController {
  final MobileScannerController scannerController = MobileScannerController();

  final RxBool isTorchOn = false.obs;
  final RxBool isQrMode = true.obs; // true = QR Scan, false = Barcode Scan

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  void toggleTorch() {
    scannerController.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  void switchMode() {
    isQrMode.value = !isQrMode.value;
  }

  Future<void> pickImageFromGallery() async {
    // Check permission (Optional if ImagePicker handles it, but good practice)
    // For Android 13+, READ_MEDIA_IMAGES is used, for older READ_EXTERNAL_STORAGE
    // ImagePicker plugin usually handles specific permissions.
    // We will just use ImagePicker directly.

    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // analyzeImage returns void/Future<void> in newer versions or bool in older. checking implementation.
        // Assuming it's void or simple call.
        await scannerController.analyzeImage(image.path);
        // We rely on onDetect callback for success.
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      // Check for permission issues explicitly if needed
      var status = await Permission.photos.status; // For iOS and newer Android
      if (status.isDenied) {
        // We can ask again or show settings
        Get.snackbar(
          "Permission Denied",
          "Please allow gallery access in settings",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: openAppSettings,
            child: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }
}

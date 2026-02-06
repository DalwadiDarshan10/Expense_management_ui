import 'package:expense/routes/app_named.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void handleScanResult(String rawCode) {
    final code = rawCode.trim();
    if (code.isEmpty) return;

    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (code == currentUserUid) {
      Get.snackbar(
        "Invalid Action",
        "You cannot scan your own QR code.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Redirect to Transfer By Wallet Screen
    Get.toNamed(
      AppNamed.transferByWalletPage,
      arguments: {'receiverUid': code},
    );
  }

  Future<void> pickImageFromGallery() async {
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

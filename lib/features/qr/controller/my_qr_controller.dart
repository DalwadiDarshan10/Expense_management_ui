import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';

class MyQrController extends GetxController {
  final GlobalKey ticketKey = GlobalKey();
  final _isDownloading = false.obs;
  final couponController = TextEditingController();

  bool get isDownloading => _isDownloading.value;

  String get currentUserUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> downloadQrAndBarcode() async {
    if (_isDownloading.value) return;

    try {
      // capture first to avoid showing loader in the image
      final ticketBytes = await _capturePng(ticketKey);
      if (ticketBytes == null) throw Exception("Failed to capture Ticket");

      _isDownloading.value = true;

      // Request permissions first (Gal handles this, but good to be explicit or handle denial)
      bool hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        // Gal will request access automatically on putImageBytes,
        // but we can request early if needed.
        // For now, let Gal handle it.
      }

      // Save Ticket
      await Gal.putImageBytes(
        ticketBytes,
        name: "user_ticket_card",
        album: null, // Save to default album (Camera Roll / Pictures)
      );

      Get.snackbar(
        "Success",
        "QR Ticket saved to Gallery successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on GalException catch (e) {
      Get.snackbar(
        "Permission Denied",
        e.type.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save image: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _isDownloading.value = false;
    }
  }

  Future<Uint8List?> _capturePng(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Increase pixel ratio for high quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing image: $e");
      return null;
    }
  }

  void applyCoupon() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    if (couponController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter coupon code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } else {
      Get.snackbar(
        "Success",
        "Coupon applied successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      couponController.clear();
    }
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}

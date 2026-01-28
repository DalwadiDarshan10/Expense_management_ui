import 'package:expense/features/home/pages/home_content_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyQrController extends GetxController {
  final couponController = TextEditingController();

  void applyCoupon() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    if (couponController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter coupon code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
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

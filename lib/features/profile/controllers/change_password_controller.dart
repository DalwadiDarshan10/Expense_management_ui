import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  final signOutAllDevices = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void validateOldPassword(String value) {
    if (value.isEmpty) {
      oldPasswordError.value = 'Old password is required';
    } else {
      oldPasswordError.value = '';
    }
  }

  void validateNewPassword(String value) {
    if (value.isEmpty) {
      newPasswordError.value = 'New password is required';
    } else if (value.length < 8) {
      newPasswordError.value = 'At least 8 characters';
    } else {
      newPasswordError.value = '';
    }
    // Re-validate confirm password as it depends on new password
    if (confirmPasswordController.text.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.text);
    }
  }

  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
    } else if (value.length < 8) {
      confirmPasswordError.value = 'At least 8 characters';
    } else if (value != newPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }

  void toggleSignOutAllDevices() {
    signOutAllDevices.value = !signOutAllDevices.value;
  }

  Future<void> saveChange() async {
    validateOldPassword(oldPasswordController.text);
    validateNewPassword(newPasswordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (oldPasswordError.isNotEmpty ||
        newPasswordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.back();
    Get.snackbar(
      'Success',
      'Password changed successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

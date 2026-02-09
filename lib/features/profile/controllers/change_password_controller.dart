import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final confirmPasswordError = ''.obs;

  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final signOutAllDevices = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleOldPasswordVisibility() =>
      isOldPasswordVisible.value = !isOldPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

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
    } else if (value == oldPasswordController.text && value.isNotEmpty) {
      newPasswordError.value = 'New password cannot be same as old password';
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

    if (oldPasswordError.value.isNotEmpty ||
        newPasswordError.value.isNotEmpty ||
        confirmPasswordError.value.isNotEmpty) {
      return;
    }

    isLoading.value = true;
    try {
      await _authService.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      // Also update Firestore to track password change
      await FirestoreService.userDoc().set({
        'passwordChangedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (signOutAllDevices.value) {
        await _authService.signOut();
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

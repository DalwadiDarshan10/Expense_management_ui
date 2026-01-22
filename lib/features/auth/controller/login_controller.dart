import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Phone field
  final phoneController = ''.obs;
  final isPhoneValid = false.obs;
  final phoneErrorText = ''.obs;

  // Password field
  final passwordController = ''.obs;
  final isPasswordVisible = false.obs;
  final passwordErrorText = ''.obs;

  // Save password checkbox
  final savePassword = false.obs;

  // Loading state
  final isLoading = false.obs;

  /// Validates phone number (10+ digits)
  void validatePhone(String value) {
    phoneController.value = value;
    if (value.isEmpty) {
      isPhoneValid.value = false;
      phoneErrorText.value = 'Phone number is required';
    } else if (value.length < 10) {
      isPhoneValid.value = false;
      phoneErrorText.value = 'Phone number must be at least 10 digits';
    } else {
      isPhoneValid.value = true;
      phoneErrorText.value = '';
    }
  }

  /// Validates password
  void validatePassword(String value) {
    passwordController.value = value;
    if (value.isEmpty) {
      passwordErrorText.value = 'Password is required';
    } else if (value.length < 8) {
      passwordErrorText.value = 'Password must be at least 8 characters';
    } else {
      passwordErrorText.value = '';
    }
  }

  /// Validates password (minimum 8 characters)
  bool get isPasswordValid => passwordController.value.length >= 8;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle save password checkbox
  void toggleSavePassword() {
    savePassword.value = !savePassword.value;
  }

  /// Check if form is valid
  bool get isFormValid => isPhoneValid.value && isPasswordValid;

  /// Validates all fields - call this on button tap
  void validateAllFields() {
    validatePhone(phoneController.value);
    validatePassword(passwordController.value);
  }

  /// Handle login
  Future<void> login() async {
    // Validate all fields first to show all errors
    validateAllFields();

    if (!isFormValid) return;

    isLoading.value = true;

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(AppNamed.menuPage);
    } catch (e) {
      Get.snackbar('Error', 'Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to forgot password
  void goToForgotPassword() {
    Get.toNamed(AppNamed.verifyPhone);
  }

  /// Navigate to sign up
  void goToSignUp() {
    Get.toNamed(AppNamed.register);
  }
}

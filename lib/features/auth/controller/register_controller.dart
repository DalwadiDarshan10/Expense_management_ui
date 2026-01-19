import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Username field
  final usernameController = ''.obs;
  final isUsernameValid = false.obs;
  final usernameErrorText = ''.obs;

  // Phone field
  final phoneController = ''.obs;
  final isPhoneValid = false.obs;
  final phoneErrorText = ''.obs;

  // Password field
  final passwordController = ''.obs;
  final isPasswordVisible = false.obs;
  final passwordErrorText = ''.obs;

  // Confirm password field
  final confirmPasswordController = ''.obs;
  final isConfirmPasswordVisible = false.obs;
  final confirmPasswordErrorText = ''.obs;

  // Terms and conditions checkbox
  final agreeToTerms = false.obs;

  // Loading state
  final isLoading = false.obs;

  /// Validates username (minimum 3 characters)
  void validateUsername(String value) {
    usernameController.value = value;
    if (value.isEmpty) {
      isUsernameValid.value = false;
      usernameErrorText.value = 'Username is required';
    } else {
      isUsernameValid.value = true;
      usernameErrorText.value = '';
    }
  }

  /// Validates phone number
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
    // Re-validate confirm password when password changes
    if (confirmPasswordController.value.isNotEmpty) {
      validateConfirmPassword(confirmPasswordController.value);
    }
  }

  /// Validates confirm password
  void validateConfirmPassword(String value) {
    confirmPasswordController.value = value;
    if (value.isEmpty) {
      confirmPasswordErrorText.value = 'Confirm password is required';
    } else if (value != passwordController.value) {
      confirmPasswordErrorText.value = 'Passwords do not match';
    } else {
      confirmPasswordErrorText.value = '';
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Toggle terms and conditions checkbox
  void toggleAgreeToTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  /// Check if password is valid (minimum 8 characters)
  bool get isPasswordValid => passwordController.value.length >= 8;

  /// Check if passwords match
  bool get doPasswordsMatch =>
      passwordController.value == confirmPasswordController.value &&
      confirmPasswordController.value.isNotEmpty;

  /// Check if form is valid
  bool get isFormValid =>
      isUsernameValid.value &&
      isPhoneValid.value &&
      isPasswordValid &&
      doPasswordsMatch &&
      agreeToTerms.value;

  /// Validates all fields - call this on button tap
  void validateAllFields() {
    validateUsername(usernameController.value);
    validatePhone(phoneController.value);
    validatePassword(passwordController.value);
    validateConfirmPassword(confirmPasswordController.value);
  }

  /// Handle register
  Future<void> register() async {
    // Validate all fields first to show all errors
    validateAllFields();

    if (!isFormValid) return;

    isLoading.value = true;

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(seconds: 2));

      Get.offNamed('/signup-success');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}

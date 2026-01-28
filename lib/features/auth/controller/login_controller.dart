import 'package:expense/features/auth/services/auth_service.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  // Email field
  final emailController = ''.obs;
  final isEmailValid = false.obs;
  final emailErrorText = ''.obs;

  // Password field
  final passwordController = ''.obs;
  final isPasswordVisible = false.obs;
  final passwordErrorText = ''.obs;

  // Save password checkbox
  final savePassword = false.obs;

  // Loading state
  final isLoading = false.obs;

  /// Validates email
  void validateEmail(String value) {
    emailController.value = value;
    if (value.isEmpty) {
      isEmailValid.value = false;
      emailErrorText.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      isEmailValid.value = false;
      emailErrorText.value = 'Please enter a valid email';
    } else {
      isEmailValid.value = true;
      emailErrorText.value = '';
    }
  }

  /// Validates password
  void validatePassword(String value) {
    passwordController.value = value;
    if (value.isEmpty) {
      passwordErrorText.value = 'Password is required';
    } else if (value.length < 6) {
      passwordErrorText.value = 'Password must be at least 6 characters';
    } else {
      passwordErrorText.value = '';
    }
  }

  /// Validates password (minimum 6 characters for Firebase)
  bool get isPasswordValid => passwordController.value.length >= 6;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle save password checkbox
  void toggleSavePassword() {
    savePassword.value = !savePassword.value;
  }

  /// Check if form is valid
  bool get isFormValid => isEmailValid.value && isPasswordValid;

  /// Validates all fields - call this on button tap
  void validateAllFields() {
    validateEmail(emailController.value);
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

      await _authService.signInWithEmail(
        email: emailController.value.trim(),
        password: passwordController.value,
      );

      // Save login state using GetStorage
      _storage.write('isLoggedIn', true);
      _storage.write('userEmail', emailController.value.trim());

      Get.snackbar('Success', 'Logged in successfully');
      Get.offAllNamed(AppNamed.menuPage);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to forgot password
  void goToForgotPassword() {
    Get.toNamed(AppNamed.forgotPassword);
  }

  /// Navigate to sign up
  void goToSignUp() {
    Get.toNamed(AppNamed.register);
  }
}

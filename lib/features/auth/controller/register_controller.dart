import 'package:expense/features/auth/services/auth_service.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  // Username field
  final usernameController = ''.obs;
  final isUsernameValid = false.obs;
  final usernameErrorText = ''.obs;

  // Email field
  final emailController = ''.obs;
  final isEmailValid = false.obs;
  final emailErrorText = ''.obs;

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
      passwordErrorText.value = 'Password must be 8 characters';
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

  /// Check if password is valid
  bool get isPasswordValid => passwordController.value.length >= 6;

  /// Check if passwords match
  bool get doPasswordsMatch =>
      passwordController.value == confirmPasswordController.value &&
      confirmPasswordController.value.isNotEmpty;

  /// Check if form is valid
  bool get isFormValid =>
      isUsernameValid.value &&
      isEmailValid.value &&
      isPasswordValid &&
      doPasswordsMatch &&
      agreeToTerms.value;

  /// Validates all fields - call this on button tap
  void validateAllFields() {
    validateUsername(usernameController.value);
    validateEmail(emailController.value);
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

      final credential = await _authService.signUpWithEmail(
        email: emailController.value.trim(),
        password: passwordController.value,
      );

      // Update display name
      await credential.user?.updateDisplayName(usernameController.value);

      // Save login state
      _storage.write('isLoggedIn', true);
      _storage.write('userEmail', emailController.value.trim());
      _storage.write('username', usernameController.value.trim());

      Get.offNamed(AppNamed.signupSuccess);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}

import 'package:email_otp/email_otp.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  // Use EmailOTP package
  final EmailOTP _emailAuth = EmailOTP();

  final emailController = ''.obs;
  final emailErrorText = ''.obs;

  // OTP Logic
  final otpController = ''.obs;
  final otpErrorText = ''.obs;
  final otpDigits = List.generate(4, (_) => ''.obs);
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // New Password
  final newPasswordController = ''.obs;
  final confirmPasswordController = ''.obs;
  final passwordErrorText = ''.obs;
  final confirmPasswordErrorText = ''.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Configure Email OTP
    // Note: API might vary by version. Using robust config.
    _emailAuth.setConfig(
      appEmail: "support@expenseapp.com",
      appName: "Expense App",
      userEmail: emailController.value,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );
  }

  void validateEmail(String value) {
    emailController.value = value;
    if (value.isEmpty) {
      emailErrorText.value = 'Email is required';
    } else if (!GetUtils.isEmail(value)) {
      emailErrorText.value = 'Please enter a valid email';
    } else {
      emailErrorText.value = '';
    }
  }

  /// Send OTP to Email
  Future<void> sendOtp() async {
    validateEmail(emailController.value);
    if (emailErrorText.value.isNotEmpty) return;

    isLoading.value = true;
    try {
      _emailAuth.setConfig(
        appEmail: "support@expenseapp.com",
        appName: "Expense App",
        userEmail: emailController.value,
        otpLength: 4,
        otpType: OTPType.digitsOnly,
      );

      bool result = await _emailAuth.sendOTP();

      if (result) {
        Get.snackbar('Success', 'OTP sent to ${emailController.value}');
        // Navigate to Verify Email OTP Page
        Get.toNamed(AppNamed.verifyEmailOtp);
      } else {
        Get.snackbar('Error', 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- OTP Verification Logic ---

  /// Update OTP digit
  void updateOtp(int index, String value) {
    otpDigits[index].value = value;
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get completeOtp => otpDigits.map((e) => e.value).join();

  Future<void> verifyOtp() async {
    if (completeOtp.length != 4) {
      otpErrorText.value = "Please enter 4 digits";
      return;
    }

    isLoading.value = true;
    try {
      bool isValid = await _emailAuth.verifyOTP(otp: completeOtp);
      if (isValid) {
        Get.toNamed(AppNamed.resetPassword);
      } else {
        otpErrorText.value = "Invalid OTP";
        Get.snackbar('Error', 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Reset Password Logic ---

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> resetPassword() async {
    if (newPasswordController.value.length < 6) {
      Get.snackbar('Error', 'Password must be 6+ chars');
      return;
    }
    if (newPasswordController.value != confirmPasswordController.value) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar('Success', 'Password reset successfully (Simulation)');
      Get.offAllNamed(AppNamed.login);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (var node in focusNodes) node.dispose();
    super.onClose();
  }
}

import 'package:email_otp/email_otp.dart';

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
}

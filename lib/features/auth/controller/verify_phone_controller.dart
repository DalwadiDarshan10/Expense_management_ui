import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VerifyPhoneController extends GetxController {
  // OTP digits as a list
  final otpDigits = List.generate(4, (_) => ''.obs);

  // OTP error text
  final otpErrorText = ''.obs;

  // Focus nodes for OTP fields
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  // Phone number to display
  final phoneNumber = '505-287-8051'.obs;

  // Loading state
  final isLoading = false.obs;

  // Resend timer
  final canResend = true.obs;
  final resendSeconds = 0.obs;

  /// Get complete OTP
  String get completeOtp => otpDigits.map((d) => d.value).join();

  /// Check if OTP is complete
  bool get isOtpComplete => completeOtp.length == 4;

  /// Get focus node by index
  FocusNode getFocusNode(int index) => focusNodes[index];

  /// Get OTP value by index
  String getOtpValue(int index) => otpDigits[index].value;

  /// Update OTP digit and handle focus navigation
  void updateOtp(int index, String value) {
    otpDigits[index].value = value;

    // Clear error when user types
    if (otpErrorText.value.isNotEmpty) {
      otpErrorText.value = '';
    }

    // Auto focus next field when digit is entered
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    // Auto focus previous field on delete
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  /// Clear all OTP digits
  void clearOtp() {
    for (var digit in otpDigits) {
      digit.value = '';
    }
  }

  /// Validate OTP
  void validateOtp() {
    if (completeOtp.isEmpty) {
      otpErrorText.value = 'Please enter the 4-digit code';
    } else if (completeOtp.length < 4) {
      otpErrorText.value = 'Please enter all 4 digits';
    } else {
      otpErrorText.value = '';
    }
  }

  /// Resend OTP code
  Future<void> resendCode() async {
    if (!canResend.value) return;

    canResend.value = false;
    resendSeconds.value = 30;
    _startResendTimer();

    Get.snackbar(
      'OTP Sent',
      'A new code has been sent to ${phoneNumber.value}',
    );
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
        _startResendTimer();
      } else {
        canResend.value = true;
      }
    });
  }

  /// Confirm OTP
  Future<void> confirmOtp() async {
    validateOtp();
    if (!isOtpComplete) return;

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar('Success', 'Phone verified successfully!');
      Get.toNamed(AppNamed.menuPage);
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (final node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}

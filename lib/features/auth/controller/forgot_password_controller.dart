import 'package:expense/features/auth/services/auth_service.dart';
import 'package:expense/routes/app_named.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = ''.obs;
  final emailErrorText = ''.obs;

  final isLoading = false.obs;

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

  Future<void> sendPasswordResetEmail() async {
    validateEmail(emailController.value);
    if (emailErrorText.value.isNotEmpty) return;

    try {
      isLoading.value = true;
      await _authService.sendPasswordResetEmail(emailController.value);

      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        snackPosition: SnackPosition.TOP,
      );

      // Navigate back to login or stay here?
      // Usually good to go back or let user know check email
      Get.offAllNamed(AppNamed.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        "Please Enter Valid Email",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

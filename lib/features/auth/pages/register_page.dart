import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/auth/controller/register_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and Title
                16.verticalSpace,
                _buildHeader(context),

                32.verticalSpace,

                // Username field
                _buildUsernameField(controller),

                20.verticalSpace,

                // Email field
                _buildEmailField(controller),

                20.verticalSpace,

                // Password field
                _buildPasswordField(controller),

                20.verticalSpace,

                // Confirm Password field
                _buildConfirmPasswordField(controller),

                16.verticalSpace,

                // Terms and conditions checkbox
                _buildTermsCheckbox(controller),

                32.verticalSpace,

                // Register button
                _buildRegisterButton(controller),

                20.verticalSpace,

                // Login link
                _buildLoginLink(controller),

                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with back button and title
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.sp,
              color: AppColors.onSurface,
            ),
          ),
        ),

        // Title centered
        Expanded(
          child: Center(
            child: Text(
              'Register',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // Spacer for symmetry
        SizedBox(width: 36.w),
      ],
    );
  }

  /// Build username input field
  Widget _buildUsernameField(RegisterController controller) {
    return Obx(
      () => AppTextField(
        label: 'Username',
        hint: 'Melvin Guerrero',
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        showValidationIcon: true,
        isValid: controller.isUsernameValid.value,
        onChanged: controller.validateUsername,
        errorText: controller.usernameErrorText.value.isNotEmpty
            ? controller.usernameErrorText.value
            : null,
        suffixIcon: controller.isUsernameValid.value
            ? AppImageViewer(
                imagePath: AppImages.greentick,
                height: 22.sp,
                width: 22.sp,
              )
            : null,
      ),
    );
  }

  /// Build email input field
  Widget _buildEmailField(RegisterController controller) {
    return Obx(
      () => AppTextField(
        label: 'Email',
        hint: 'example@email.com',
        keyboardType: TextInputType.emailAddress,
        showValidationIcon: true,
        isValid: controller.isEmailValid.value,
        onChanged: controller.validateEmail,
        errorText: controller.emailErrorText.value.isNotEmpty
            ? controller.emailErrorText.value
            : null,
        suffixIcon: controller.isEmailValid.value
            ? AppImageViewer(
                imagePath: AppImages.greentick,
                height: 22.sp,
                width: 22.sp,
              )
            : null,
      ),
    );
  }

  /// Build password input field
  Widget _buildPasswordField(RegisterController controller) {
    return Obx(
      () => AppTextField(
        label: 'Password',
        hint: 'At least 6 characters',
        isPassword: true,
        onChanged: controller.validatePassword,
        errorText: controller.passwordErrorText.value.isNotEmpty
            ? controller.passwordErrorText.value
            : null,
      ),
    );
  }

  /// Build confirm password input field
  Widget _buildConfirmPasswordField(RegisterController controller) {
    return Obx(
      () => AppTextField(
        label: 'Confirm password',
        hint: 'At least 6 characters',
        isPassword: true,
        onChanged: controller.validateConfirmPassword,
        errorText: controller.confirmPasswordErrorText.value.isNotEmpty
            ? controller.confirmPasswordErrorText.value
            : null,
      ),
    );
  }

  /// Build terms and conditions checkbox
  Widget _buildTermsCheckbox(RegisterController controller) {
    return Obx(
      () => GestureDetector(
        onTap: controller.toggleAgreeToTerms,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: controller.agreeToTerms.value
                      ? AppColors.primary
                      : AppColors.borderNor,
                  width: 1.5.w,
                ),
                color: controller.agreeToTerms.value
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              child: controller.agreeToTerms.value
                  ? Icon(Icons.check, size: 14.sp, color: AppColors.white)
                  : null,
            ),
            12.horizontalSpace,
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'By creating your account you have to agree\nwith our ',
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.interactive,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build register button
  Widget _buildRegisterButton(RegisterController controller) {
    return Obx(
      () => AppButton(
        text: 'Register',
        isLoading: controller.isLoading.value,
        onPressed: controller.register,
      ),
    );
  }

  /// Build login link
  Widget _buildLoginLink(RegisterController controller) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have account? ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary,
            ),
          ),
          GestureDetector(
            onTap: controller.goToLogin,
            child: Text(
              'Login',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.interactive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

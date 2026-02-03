import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/auth/controller/login_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: context.isDarkMode ? AppColors.black : AppColors.white,
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

                40.verticalSpace,

                // Phone field
                _buildPhoneField(controller),

                24.verticalSpace,

                // Password field
                _buildPasswordField(controller),

                16.verticalSpace,

                // Save password & Forgot password row
                _buildOptionsRow(controller, context),

                40.verticalSpace,

                // Login button
                _buildLoginButton(controller),

                16.verticalSpace,

                // Sign up link
                _buildSignUpLink(controller, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
              color: context.theme.iconTheme.color,
            ),
          ),
        ),

        // Title centered
        Expanded(
          child: Center(
            child: Text(
              AppStrings.login,
              style: AppTextStyles.titleLarge.copyWith(
                color: context.theme.textTheme.titleLarge?.color,
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

  Widget _buildPhoneField(LoginController controller) {
    return Obx(
      () => AppTextField(
        label: AppStrings.emailLabel,
        hint: AppStrings.emailHint,
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

  Widget _buildPasswordField(LoginController controller) {
    return Obx(
      () => AppTextField(
        label: AppStrings.passwordLabel,
        hint: AppStrings.passwordHint,
        isPassword: true,
        maxLength: 8,
        onChanged: controller.validatePassword,
        errorText: controller.passwordErrorText.value.isNotEmpty
            ? controller.passwordErrorText.value
            : null,
      ),
    );
  }

  Widget _buildOptionsRow(LoginController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Save password checkbox
        Obx(
          () => GestureDetector(
            onTap: controller.toggleSavePassword,
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: controller.savePassword.value
                          ? AppColors.primary
                          : AppColors.borderNor,
                      width: 1.5.w,
                    ),
                    color: controller.savePassword.value
                        ? AppColors.primary
                        : AppColors.transparent,
                  ),
                  child: controller.savePassword.value
                      ? Icon(Icons.check, size: 14.sp, color: AppColors.white)
                      : null,
                ),
                8.horizontalSpace,
                Text(
                  AppStrings.savePassword,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Forgot password link
        GestureDetector(
          onTap: controller.goToForgotPassword,
          child: Text(
            AppStrings.forgotPassword,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.interactive,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(
      () => AppButton(
        text: AppStrings.loginBtn,
        isLoading: controller.isLoading.value,
        onPressed: controller.login,
      ),
    );
  }

  Widget _buildSignUpLink(LoginController controller, BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.dontHaveAccount,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.theme.textTheme.bodyMedium?.color,
            ),
          ),
          GestureDetector(
            onTap: controller.goToSignUp,
            child: Text(
              AppStrings.signUp,
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

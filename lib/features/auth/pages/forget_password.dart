import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/auth/controller/forgot_password_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the controller if not already present
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.forgotPasswordTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
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
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                24.verticalSpace,
                _buildIllustration(),
                32.verticalSpace,
                Text(
                  AppStrings.forgotPasswordMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                40.verticalSpace,
                Obx(
                  () => AppTextField(
                    label: AppStrings.emailLabel,
                    hint: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: controller.validateEmail,
                    errorText: controller.emailErrorText.value.isNotEmpty
                        ? controller.emailErrorText.value
                        : null,
                  ),
                ),
                40.verticalSpace,
                Obx(
                  () => AppButton(
                    text: "Send Reset Link",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.sendPasswordResetEmail,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: AppImageViewer(
        imagePath: AppImages.otpPageImage,
        height: 200.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

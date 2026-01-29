import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/auth/controller/forgot_password_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.resetPasswordTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                30.verticalSpace,
                Text(
                  AppStrings.createNewPassword,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                Text(
                  AppStrings.createNewPasswordMessage,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                30.verticalSpace,
                Obx(
                  () => AppTextField(
                    label: AppStrings.newPasswordLabel,
                    hint: AppStrings.passwordHintShort,
                    isPassword: true,
                    onChanged: (val) =>
                        controller.newPasswordController.value = val,
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => AppTextField(
                    label: AppStrings.confirmPasswordLabelMatches,
                    hint: AppStrings.confirmPasswordHintMatches,
                    isPassword: true,
                    onChanged: (val) =>
                        controller.confirmPasswordController.value = val,
                  ),
                ),
                40.verticalSpace,
                Obx(
                  () => AppButton(
                    text: AppStrings.resetPasswordBtn,
                    // isLoading: controller.isLoading.value,
                    // onPressed: controller.resetPassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

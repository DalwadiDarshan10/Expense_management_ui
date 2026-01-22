import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controllers/change_password_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Change Password',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Old Password
              Obx(
                () => AppTextField(
                  label: 'Old password',
                  hint: 'Walletavipay123',
                  controller: controller.oldPasswordController,
                  isPassword: true,
                  maxLength: 8,
                  onChanged: controller.validateOldPassword,
                  errorText: controller.oldPasswordError.value.isNotEmpty
                      ? controller.oldPasswordError.value
                      : null,
                ),
              ),
              SizedBox(height: 24.h),

              // New Password
              Obx(
                () => AppTextField(
                  label: 'New password',
                  hint: 'At least 8 characters',
                  controller: controller.newPasswordController,
                  isPassword: true,
                  maxLength: 8,
                  onChanged: controller.validateNewPassword,
                  errorText: controller.newPasswordError.value.isNotEmpty
                      ? controller.newPasswordError.value
                      : null,
                ),
              ),
              SizedBox(height: 24.h),

              // Confirm Password
              Obx(
                () => AppTextField(
                  label: 'Confirm password',
                  hint: 'At least 8 characters',
                  controller: controller.confirmPasswordController,
                  isPassword: true,
                  maxLength: 8,
                  onChanged: controller.validateConfirmPassword,
                  errorText: controller.confirmPasswordError.value.isNotEmpty
                      ? controller.confirmPasswordError.value
                      : null,
                ),
              ),
              SizedBox(height: 24.h),

              // Sign Out Checkbox
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleSignOutAllDevices,
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: controller.signOutAllDevices.value
                                ? AppColors.primary
                                : AppColors.borderNor,
                            width: 1.5.w,
                          ),
                          color: controller.signOutAllDevices.value
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: controller.signOutAllDevices.value
                            ? Icon(
                                Icons.check,
                                size: 14.sp,
                                color: AppColors.white,
                              )
                            : null,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Sign Out Of All Devices',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Save Button
              Obx(
                () => AppButton(
                  text: 'Save Change',
                  onPressed: controller.saveChange,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

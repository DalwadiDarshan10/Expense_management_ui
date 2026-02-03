import 'package:expense/core/constants/app_strings.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          AppStrings.changePassword,
          style: AppTextStyles.titleLarge.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Old Password
                  Obx(
                    () => AppTextField(
                      label: AppStrings.oldPasswordLabel,
                      hint: AppStrings.oldPasswordHint,
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
                      label: AppStrings.newPasswordLabel8Chars,
                      hint: AppStrings.passwordHint8Chars,
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
                      label: AppStrings.confirmPasswordLabel,
                      hint: AppStrings.passwordHint8Chars,
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      maxLength: 8,
                      onChanged: controller.validateConfirmPassword,
                      errorText:
                          controller.confirmPasswordError.value.isNotEmpty
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
                                color: AppColors.primary,
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
                            AppStrings.signOutOfAllDevices,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Save Button
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AppButton(
                  text: AppStrings.saveChangeBtn,
                  onPressed: controller.saveChange,
                  isLoading: controller.isLoading.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

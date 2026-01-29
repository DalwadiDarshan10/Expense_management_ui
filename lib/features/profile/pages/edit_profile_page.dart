import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controller/edit_profile_controller.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
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
          AppStrings.editProfileTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar
            Container(
              color: AppColors.white,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      // Placeholder for now, can be updated to show actual image
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Form Fields
            LabeledInputTile(
              title: AppStrings.fullNameLabel,
              controller: controller.nameController,
            ),
            SizedBox(height: 8.h),
            LabeledInputTile(
              title: AppStrings.phoneNumberLabel,
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8.h),
            LabeledInputTile(
              title: AppStrings.emailLabel,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 40.h),

            // Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.saveChangeBtn,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

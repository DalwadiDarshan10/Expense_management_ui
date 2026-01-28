import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/friends/controller/add_friend_controller.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddFriendPage extends GetView<AddFriendController> {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          'Add New Friend',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            SizedBox(height: 8.h),
            SizedBox(height: 8.h),
            // Form Fields using LabeledInputTile
            Obx(
              () => LabeledInputTile(
                title: "Full name",
                hintText: "Enter full name",
                controller: controller.nameController,
                errorText: controller.nameError.value,
                onChanged: controller.validateName,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => LabeledInputTile(
                title: "Phone number",
                hintText: "Enter phone number",
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                errorText: controller.phoneError.value,
                onChanged: controller.validatePhoneLive,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => LabeledInputTile(
                title: "Email",
                hintText: "Enter email address",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: controller.emailError.value,
                onChanged: controller.validateEmail,
              ),
            ),

            SizedBox(height: 48.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.addFriend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add New Contact',
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

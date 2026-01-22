import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense/features/profile/pages/change_password_page.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

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
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          'Setting',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  _buildSettingItem(title: 'Change Face ID', onTap: () {}),
                  SizedBox(height: 8.h),
                  _buildSettingItem(
                    title: 'Change Language',
                    onTap: () {},
                    trailing: Row(
                      children: [
                        Text('🇬🇧', style: TextStyle(fontSize: 20.sp)),
                        SizedBox(width: 8.w),
                        Text(
                          'English',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    showChevron: true,
                    isDropdown: true,
                  ),
                  Divider(color: AppColors.dividerColor, height: 24.h),
                  _buildSettingItem(
                    title: 'Change Password',
                    onTap: () {
                      Get.to(() => const ChangePasswordPage());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      'Other',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    title: 'Application infomation',

                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    bool showChevron = true,
    bool isDropdown = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        color: Colors.transparent, // For hit test
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                if (trailing != null) trailing,
                if (showChevron) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    isDropdown
                        ? Icons.keyboard_arrow_down
                        : Icons.chevron_right,
                    color: AppColors.secondaryText,
                    size: 24.r,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

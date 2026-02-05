import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';

import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controller/profile_controller.dart';
import 'package:expense/features/profile/widgets/profile_header_widget.dart';
import 'package:expense/features/profile/widgets/profile_menu_item_widget.dart';
import 'package:expense/features/profile/widgets/profile_stats_widget.dart';
import 'package:expense/widgets/app_image_viewer.dart';

import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: context.theme.primaryColor,
            size: 20.r,
          ),
          onPressed: () {
            Get.toNamed(AppNamed.menuPage);
          },
        ),
        centerTitle: true,
        title: Text(
          AppStrings.profileTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: context.theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Information
            Obx(
              () => ProfileHeaderWidget(
                userName: controller.userName.value,
                userPhone: controller.userPhone.value,
                avatarUrl: controller.userAvatar.value,
                onTap: () {
                  Get.toNamed(AppNamed.editProfile);
                },
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => ProfileStatsWidget(
                points: controller.points.value,
                balance: controller.walletBalance.value,
              ),
            ),
            SizedBox(height: 8.h),

            Container(
              color: context.theme.cardColor,
              child: Padding(
                padding: EdgeInsets.only(left: 32.w, right: 32.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // Menu Items
                    ProfileMenuItemWidget(
                      title: AppStrings.cardsBankAccounts,
                      icon: AppImageViewer(
                        imagePath: AppImages.walletinactive,
                        height: 22,
                        color: context.theme.iconTheme.color,
                      ),
                      onTap: () {
                        Get.toNamed(AppNamed.walletsDashboard);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(color: context.theme.dividerColor),
                    ),

                    ProfileMenuItemWidget(
                      title: AppStrings.manageGroupFriends,
                      icon: Icon(
                        Icons.group_outlined,
                        size: 24.r,
                        color: context.theme.iconTheme.color,
                      ),
                      onTap: () {
                        Get.toNamed(AppNamed.friends);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(color: context.theme.dividerColor),
                    ),

                    ProfileMenuItemWidget(
                      title: AppStrings.paymentSecurity,
                      icon: Icon(
                        Icons.lock_outline,
                        size: 24.r,
                        color: context.theme.iconTheme.color,
                      ),
                      onTap: () {
                        Get.toNamed(AppNamed.paymentSecurity);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(color: context.theme.dividerColor),
                    ),

                    ProfileMenuItemWidget(
                      title: AppStrings.settingTitle,
                      icon: Icon(
                        Icons.settings_outlined,
                        size: 24.r,
                        color: context.theme.iconTheme.color,
                      ),
                      onTap: () {
                        Get.toNamed(AppNamed.setting);
                      },
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),

            // Log out button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40),
              child: ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.logoutBtn,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h), // Bottom padding
          ],
        ),
      ),
    );
  }
}

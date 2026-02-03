import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense/features/profile/pages/change_password_page.dart';
import 'package:expense/features/profile/pages/face_id_page.dart';
import 'package:expense/features/profile/pages/application_info_page.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingController());

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
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          AppStrings.settingTitle,
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
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildSettingItem(
                context,
                title: AppStrings.changeFaceId,
                onTap: () {
                  Get.to(() => const FaceIdPage());
                },
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Obx(
                    () => _buildSettingItem(
                      context,
                      title: AppStrings.changeLanguage,
                      onTap: () {
                        _showLanguageBottomSheet(context, controller);
                      },
                      trailing: Row(
                        children: [
                          Text(
                            controller.selectedFlag.value,
                            style: TextStyle(fontSize: 20.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.selectedLanguage.value,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                      showChevron: true,
                      isDropdown: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildSettingItem(
                context,
                title: AppStrings.changePassword,
                onTap: () {
                  Get.to(() => const ChangePasswordPage());
                },
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      AppStrings.otherLabel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildSettingItem(
                    context,
                    title: AppStrings.applicationInformation,
                    onTap: () {
                      Get.to(() => const ApplicationInfoPage());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    SettingController controller,
  ) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 24.w), // Spacer for centering
                  Text(
                    AppStrings.changeLanguage,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.languages.length,
                separatorBuilder: (context, index) => Divider(
                  color: Theme.of(context).dividerColor,
                  height: 1,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  final language = controller.languages[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedLanguage.value == language['name'];
                    return Container(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.transparent,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                        leading: Text(
                          language['flag']!,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        title: Text(
                          language['name']!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.primary)
                            : SizedBox.shrink(),
                        onTap: () {
                          controller.changeLanguage(
                            language['name']!,
                            language['flag']!,
                          );
                        },
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    bool showChevron = true,
    bool isDropdown = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        color: Colors.transparent, // For hit test
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                    color: Theme.of(context).iconTheme.color,
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

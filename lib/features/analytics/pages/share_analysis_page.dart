import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/share_analysis_controller.dart';
import 'package:expense/features/analytics/widgets/shared_contact_item_widget.dart';

import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShareAnalysisPage extends GetView<ShareAnalysisController> {
  const ShareAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.shareAnalysisTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.sharedWithTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),

              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hint: AppStrings.phoneNumberHint,
                      controller: phoneController,
                      onChanged: controller.updateSearchQuery,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: 30,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 83.w,
                    height: 50.h,
                    child: AppButton(
                      text: AppStrings.sendBtn,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      textStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      borderRadius: 25.r,
                      onPressed: () {
                        // Close any existing snackbar first
                        if (Get.isSnackbarOpen) {
                          Get.closeCurrentSnackbar();
                        }
                        if (phoneController.text.isNotEmpty) {
                          Get.snackbar(
                            AppStrings.sentSuccessTitle,
                            AppStrings.sentSuccessMessage,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          controller.addContact(phoneController.text);
                          phoneController.clear();
                          controller.updateSearchQuery('');
                        } else {
                          Get.snackbar(
                            AppStrings.errorTitle,
                            AppStrings.enterPhoneError,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.h),
              Divider(color: Theme.of(context).dividerColor),

              // Contact List
              Obx(() {
                if (controller.filteredFriends.isEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Center(
                          child: Text(
                            AppStrings.noContactsFound,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: _buildFooter(context),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredFriends.length + 1,
                  separatorBuilder: (_, _) =>
                      Divider(color: Theme.of(context).dividerColor),
                  itemBuilder: (context, index) {
                    if (index == controller.filteredFriends.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: _buildFooter(context),
                      );
                    }

                    final friend = controller.filteredFriends[index];

                    return SharedContactItemWidget(
                      name: friend.name,
                      phoneNumber: friend.phone,
                      onDelete: () => controller.deleteContact(friend),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer like Figma
  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: AppColors.secondaryText, size: 24.r),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            AppStrings.learnSharing,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),

        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Close any existing snackbar first
            if (Get.isSnackbarOpen) {
              Get.closeCurrentSnackbar();
            }
            Clipboard.setData(
              const ClipboardData(text: 'https://example.com/share-link'),
            );
            Get.snackbar(AppStrings.copiedTitle, AppStrings.copiedMessage);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Text(
              AppStrings.copyLinkBtn,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

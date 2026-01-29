import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/bill/controller/share_bill_controller.dart';
import 'package:expense/features/analytics/widgets/shared_contact_item_widget.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShareBillPage extends GetView<ShareBillController> {
  const ShareBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ShareBillController>()) {
      Get.put(ShareBillController());
    }

    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.shareBillTitle,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: AppColors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.sharedWithTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
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
                      fillColor: AppColors.inputBackground,
                      borderRadius: 30,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 83.w,
                    height: 50.h,
                    child: AppButton(
                      text: AppStrings.sendBtn,
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
              Divider(color: AppColors.dividerColor),

              // Contact List
              Obx(() {
                if (controller.filteredContacts.isEmpty) {
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
                      Divider(color: AppColors.dividerColor),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: _buildFooter(),
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.filteredContacts.length + 1,
                  separatorBuilder: (_, _) =>
                      Divider(color: AppColors.dividerColor),
                  itemBuilder: (context, index) {
                    if (index == controller.filteredContacts.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: _buildFooter(),
                      );
                    }

                    final contact = controller.filteredContacts[index];

                    return SharedContactItemWidget(
                      name: contact.name,
                      phoneNumber: contact.phoneNumber,
                      onDelete: () => controller.deleteContact(contact),
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
  Widget _buildFooter() {
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.dividerColor),
            ),
            child: Text(
              AppStrings.copyLinkBtn,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

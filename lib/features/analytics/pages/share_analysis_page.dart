import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/share_analysis_controller.dart';
import 'package:expense/features/analytics/widgets/shared_contact_item_widget.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShareAnalysisPage extends GetView<ShareAnalysisController> {
  const ShareAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ShareAnalysisController>()) {
      Get.put(ShareAnalysisController());
    }

    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryText,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Share Analys',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text(
              'Shared With',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 16.h),
            // Input Field row
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: TextField(
                        controller: phoneController,
                        onChanged: controller.updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.secondaryText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 80.w,
                  height: 50.h,
                  child: AppButton(
                    text: 'Send',
                    onPressed: () {
                      controller.addContact(phoneController.text);
                      phoneController.clear();
                      controller.updateSearchQuery('');
                    },
                    backgroundColor: AppColors.primary,
                    textStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    borderRadius: 12.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Contact List
            Expanded(
              child: Obx(() {
                if (controller.filteredContacts.isEmpty) {
                  return Center(
                    child: Text(
                      'No contacts found',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = controller.filteredContacts[index];
                    return SharedContactItemWidget(
                      name: contact.name,
                      phoneNumber: contact.phoneNumber,
                      onDelete: () => controller.deleteContact(contact),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 16.h),
            // Footer Section
            _buildFooter(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(Icons.error_outline, color: AppColors.secondaryText, size: 20.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Learn about sharing',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(
              const ClipboardData(text: 'https://example.com/share-link'),
            );
            Get.snackbar(
              'Copied',
              'Link copied to clipboard',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Copy link',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

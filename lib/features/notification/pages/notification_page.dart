import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/notification/controllers/notification_controller.dart';
import 'package:expense/features/notification/widgets/notification_item_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryText,
          ),
        ),
        title: Text(
          'Notification',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "Delete Notifications",
                  titleStyle: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  middleText:
                      "Are you sure you want to delete all notifications?",
                  middleTextStyle: AppTextStyles.bodyMedium,
                  backgroundColor: AppColors.white,
                  radius: 12.r,
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: AppColors.white,
                  cancelTextColor: AppColors.primaryText,
                  buttonColor: AppColors.primary,
                  onConfirm: () {
                    controller.deleteAllNotifications();
                    Get.back(); // Close dialog
                  },
                  onCancel: () {
                    // Get.back() is handled automatically by defaultDialog usually,
                    // but if explicit action is needed, it can be added here.
                  },
                );
              },
              child: Icon(
                Icons.delete_outline,
                color: AppColors.primary,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Obx(() {
          if (controller.todayNotifications.isEmpty &&
              controller.yesterdayNotifications.isEmpty) {
            return Center(
              child: Text("No Notifications", style: AppTextStyles.bodyLarge),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.todayNotifications.isNotEmpty) ...[
                _buildSectionHeader('Today'),
                SizedBox(height: 16.h),
                ...controller.todayNotifications.map(
                  (item) => _buildNotificationItem(item),
                ),
              ],
              if (controller.todayNotifications.isNotEmpty &&
                  controller.yesterdayNotifications.isNotEmpty)
                SizedBox(height: 24.h),
              if (controller.yesterdayNotifications.isNotEmpty) ...[
                _buildSectionHeader('Yesterday'),
                SizedBox(height: 16.h),
                ...controller.yesterdayNotifications.map(
                  (item) => _buildNotificationItem(item),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.secondaryText,
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel item) {
    return NotificationItemWidget(
      icon: item.icon,
      title: item.title,
      status: item.status,
      amount: item.amount,
      date: item.date,
      isExpense: item.isExpense,
    );
  }
}

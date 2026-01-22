import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              Icons.delete_outline,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Today'),
            SizedBox(height: 16.h),
            _buildNotificationItem(
              icon: AppImages.electricBillBadge,
              title: 'Electric bill',
              status: 'Successful',
              amount: 420,
              date: '11:00 AM',
              isExpense: true,
            ),
            _buildNotificationItem(
              icon: AppImages.waterbillBadge,
              title: 'Water bill',
              status: 'Successful',
              amount: 300,
              date: '1:00 PM',
              isExpense: true,
            ),
            _buildNotificationItem(
              icon: '', // Fallback to initial
              title: 'Johnsmith',
              status: 'Processing',
              amount: 1000,
              date: '2:25 PM',
              isExpense: true,
            ),
            _buildNotificationItem(
              icon: '', // Fallback to initial
              title: 'Loui',
              status: 'Successful',
              amount: 30,
              date: '3:00 PM',
              isExpense: false,
            ),
            SizedBox(height: 24.h),
            _buildSectionHeader('Yesterday'),
            SizedBox(height: 16.h),
            _buildNotificationItem(
              icon: AppImages.marketBadge,
              title: 'Market',
              status: 'Successful',
              amount: 200,
              date: '4:20 AM',
              isExpense: true,
            ),
            _buildNotificationItem(
              icon: AppImages
                  .myQrcodeIcon, // Using generic icon as placeholder for QR Payment
              title: 'QR Payment',
              status: 'Successful',
              amount: 400,
              date: '5:00 PM',
              isExpense: true,
            ),
            _buildNotificationItem(
              icon: AppImages.myQrcodeIcon,
              title: 'QR Payment',
              status: 'Successful',
              amount: 200,
              date: '2:25 PM',
              isExpense: false,
            ),
            _buildNotificationItem(
              icon: AppImages.televisionBadge,
              title: 'Television bill',
              status: 'Processing',
              amount: 350,
              date: '3:00 PM',
              isExpense: true,
            ),
          ],
        ),
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

  Widget _buildNotificationItem({
    required String icon,
    required String title,
    required String status,
    required double amount,
    required String date,
    required bool isExpense,
  }) {
    return TradingHistoryItemWidget(
      icon: icon,
      title: title,
      status: status,
      amount: amount,
      date: date,
      isExpense: isExpense,
    );
  }
}

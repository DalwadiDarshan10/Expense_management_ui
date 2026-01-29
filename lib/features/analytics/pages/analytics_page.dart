import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:expense/features/analytics/widgets/analytics_bar_chart_widget.dart';
import 'package:expense/features/analytics/widgets/summary_card_widget.dart';
import 'package:expense/features/analytics/widgets/time_filter_tabs_widget.dart';
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AnalyticsPage extends GetView<AnalyticsController> {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
          AppStrings.analyticsTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(AppNamed.shareAnalysis);
            },
            child: AppImageViewer(imagePath: AppImages.shareIcon),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Income & Outcome Summary Cards
            Container(
              decoration: BoxDecoration(color: AppColors.white),
              child: _buildSummaryCardsSection(),
            ),
            SizedBox(height: 8.h),
            // Time Filter Tabs
            Container(
              decoration: BoxDecoration(color: AppColors.white),
              child: const TimeFilterTabsWidget(),
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.white),
              child: const AnalyticsBarChartWidget(),
            ),
            SizedBox(height: 8.h),
            // Trading History Section
            Container(
              decoration: BoxDecoration(color: AppColors.white),
              child: _buildTradingHistorySection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsSection() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: SummaryCardWidget(
                label: AppStrings.incomeLabel,
                amount: '\$${controller.totalIncome.toStringAsFixed(2)}',
                isIncome: true,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SummaryCardWidget(
                label: AppStrings.outcomeLabel,
                amount: '\$${controller.totalOutcome.toStringAsFixed(2)}',
                isIncome: false,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTradingHistorySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tradingHistory,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return TradingHistoryItemWidget(
                  icon: transaction.icon,
                  title: transaction.title,
                  status: transaction.status,
                  amount: transaction.amount,
                  date: transaction.date,
                  isExpense: transaction.isExpense,
                  onTap: () {
                    Get.toNamed(AppNamed.shareBill);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

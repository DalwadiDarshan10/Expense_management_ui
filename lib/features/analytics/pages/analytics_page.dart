import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:expense/features/analytics/widgets/analytics_bar_chart_widget.dart';
import 'package:expense/features/analytics/widgets/summary_card_widget.dart';
import 'package:expense/features/analytics/widgets/time_filter_tabs_widget.dart';
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AnalyticsPage extends GetView<AnalyticsController> {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Analys',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.ios_share,
              color: AppColors.primaryText,
              size: 22.r,
            ),
            onPressed: () {
              Get.toNamed(AppNamed.shareAnalysis);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Income & Outcome Summary Cards
            _buildSummaryCardsSection(),
            SizedBox(height: 24.h),
            // Time Filter Tabs
            const TimeFilterTabsWidget(),
            SizedBox(height: 16.h),
            // Bar Chart
            const AnalyticsBarChartWidget(),
            SizedBox(height: 24.h),
            // Trading History Section
            _buildTradingHistorySection(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsSection() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: SummaryCardWidget(
              label: 'Income',
              amount: '\$${controller.totalIncome.toStringAsFixed(2)}',
              isIncome: true,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: SummaryCardWidget(
              label: 'Outcome',
              amount: '\$${controller.totalOutcome.toStringAsFixed(2)}',
              isIncome: false,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTradingHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trading History',
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
              );
            },
          ),
        ),
      ],
    );
  }
}

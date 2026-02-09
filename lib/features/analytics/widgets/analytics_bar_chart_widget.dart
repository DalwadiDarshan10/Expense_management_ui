import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AnalyticsBarChartWidget extends GetView<AnalyticsController> {
  const AnalyticsBarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.chartData;
      if (data.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Text(
              'No data available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          height: 220.h,
          padding: EdgeInsets.only(top: 16.h, right: 16.w),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxY(),
              minY: _getMinY(),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => AppColors.onSurface,
                  tooltipPadding: EdgeInsets.all(8.r),
                  tooltipMargin: 8.h,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final chartItem = data[groupIndex];
                    final isIncome = rodIndex == 0;
                    return BarTooltipItem(
                      '${isIncome ? 'Income' : 'Expense'}\n',
                      AppTextStyles.labelSmall.copyWith(color: AppColors.white),
                      children: [
                        TextSpan(
                          text:
                              '\$${isIncome ? chartItem.income.toStringAsFixed(0) : chartItem.expense.toStringAsFixed(0)}',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isIncome
                                ? AppColors.success
                                : AppColors.critical,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < data.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            data[index].date,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.secondaryText,
                              fontSize: 10.sp,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 30.h,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          value.toInt().toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.secondaryText,
                            fontSize: 10.sp,
                          ),
                        ),
                      );
                    },
                    reservedSize: 40.w,
                    interval: _getInterval(),
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getInterval(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.borderNor.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ),
              barGroups: _buildBarGroups(),
            ),
            duration: const Duration(milliseconds: 300),
          ),
        ),
      );
    });
  }

  double _getMaxY() {
    double maxIncome = 0;
    double maxExpense = 0;
    for (final item in controller.chartData) {
      if (item.income > maxIncome) maxIncome = item.income;
      if (item.expense > maxExpense) maxExpense = item.expense;
    }
    return (maxIncome > maxExpense ? maxIncome : maxExpense) * 1.2;
  }

  double _getMinY() {
    // Return negative value to allow bars to go below 0 for expenses
    double maxExpense = 0;
    for (final item in controller.chartData) {
      if (item.expense > maxExpense) maxExpense = item.expense;
    }
    return -maxExpense * 1.2;
  }

  double _getInterval() {
    final maxY = _getMaxY();
    final interval = (maxY / 4).roundToDouble();
    return interval == 0 ? 1.0 : interval;
  }

  List<BarChartGroupData> _buildBarGroups() {
    return controller.chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          // Income bar (positive, green)
          BarChartRodData(
            toY: data.income,
            color: AppColors.success,
            width: 12.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.r),
              topRight: Radius.circular(4.r),
            ),
          ),
          // Expense bar (negative, red - shown going down)
          BarChartRodData(
            toY: -data.expense,
            color: AppColors.critical,
            width: 12.w,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.r),
              bottomRight: Radius.circular(4.r),
            ),
          ),
        ],
        barsSpace: 2.w,
      );
    }).toList();
  }
}

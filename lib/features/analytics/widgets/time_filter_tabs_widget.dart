import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/analytics/controller/analytics_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TimeFilterTabsWidget extends GetView<AnalyticsController> {
  const TimeFilterTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTab(
                  label: 'The last 7 days',
                  filter: TimeFilter.last7Days,
                ),
                SizedBox(width: 8.w),
                _buildTab(label: '30 days', filter: TimeFilter.thirtyDays),
                SizedBox(width: 8.w),
                _buildTab(label: 'Custom', filter: TimeFilter.custom),
              ],
            ),
            if (controller.selectedFilter.value == TimeFilter.custom) ...[
              SizedBox(height: 12.h),
              _buildDateRangeRow(),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildTab({required String label, required TimeFilter filter}) {
    final isSelected = controller.selectedFilter.value == filter;

    return GestureDetector(
      onTap: () => controller.setTimeFilter(filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderNor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.secondaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeRow() {
    return Row(
      children: [
        _buildDateButton(controller.formattedStartDate),
        SizedBox(width: 16.w),
        _buildDateButton(controller.formattedEndDate),
      ],
    );
  }

  Widget _buildDateButton(String date) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                  surface: AppColors.white,
                  onSurface: AppColors.primaryText,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          // Update appropriate date
          if (date == controller.formattedStartDate) {
            controller.setCustomDateRange(
              picked,
              controller.customEndDate.value ?? DateTime.now(),
            );
          } else {
            controller.setCustomDateRange(
              controller.customStartDate.value ??
                  DateTime.now().subtract(const Duration(days: 7)),
              picked,
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderNor),
        ),
        child: Text(
          date,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

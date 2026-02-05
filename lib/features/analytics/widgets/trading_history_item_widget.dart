import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradingHistoryItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String status;
  final double amount;
  final String date;
  final bool isExpense;
  final VoidCallback? onTap;

  const TradingHistoryItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(0)}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: !isExpense
                            ? AppColors.success
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      status,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      date,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    // Try to use the asset, if it fails use a placeholder
    if (icon.isNotEmpty && icon.contains('assets/')) {
      return AppImageViewer(imagePath: icon, height: 56.h, width: 56.w);
    } else {
      // Use a colored circle with first letter as fallback
      return Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Center(
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isExpense
                  ? AppColors.critical.withValues(alpha: 0.2)
                  : AppColors.success.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                title.isNotEmpty ? title[0].toUpperCase() : '?',
                style: AppTextStyles.labelMedium.copyWith(
                  color: isExpense ? AppColors.critical : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

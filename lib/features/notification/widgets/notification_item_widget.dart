import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String status;
  final double amount;
  final String date;
  final bool isExpense;
  final VoidCallback? onTap;

  const NotificationItemWidget({
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // Icon
            Center(child: _buildIcon()),
            SizedBox(width: 12.w),
            // Title and Amount (Left side of text area)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(0)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isExpense ? AppColors.critical : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            // Status and Date (Right side of text area)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  date,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            width: 40.w,
            height: 40.w,
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

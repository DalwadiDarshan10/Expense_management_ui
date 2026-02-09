import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedContactItemWidget extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final VoidCallback onDelete;

  const SharedContactItemWidget({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(100.r),
            color: AppColors.transparent,
          ),

          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Theme.of(context).textTheme.titleMedium?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Name and Phone
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                phoneNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        // Delete Button
        TextButton(
          onPressed: onDelete,
          child: Text(
            'Delete',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.critical,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

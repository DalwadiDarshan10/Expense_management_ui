import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DealCard extends StatelessWidget {
  final String title;
  final String description;
  final String? badgeText;
  final double rating;

  const DealCard({
    super.key,
    required this.title,
    required this.description,
    this.badgeText,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Placeholder
          Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  description,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null)
                Text(
                  badgeText!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                'Burgers • Fastfood', // Hardcoded for demo matching design
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.secondaryText,
                  fontSize: 10.sp,
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 14.sp),
              Text(
                rating.toString(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedUserTile extends StatelessWidget {
  const SelectedUserTile({
    super.key,
    required this.name,
    required this.subtitle,
    this.onTap,
    this.avatar,
    this.isBorder = false,
    this.isArrowRight = false,
    this.isBig = false,
  });

  final String name;
  final String subtitle;
  final VoidCallback? onTap;

  /// Optional avatar (network / asset)
  final Widget? avatar;

  /// If true → blue border on avatar
  final bool isBorder;

  /// If true → arrow right, else arrow down
  final bool isArrowRight;

  /// If true → avatar size 54, else 44
  final bool isBig;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isBig ? 54.w : 44.w;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// AVATAR
            avatar ??
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 1.5.w),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            SizedBox(width: 12.w),

            /// NAME + SUBTITLE
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            /// CONDITIONAL ARROW
            Icon(
              isArrowRight
                  ? Icons.arrow_forward_ios
                  : Icons.keyboard_arrow_down,
              size: isArrowRight ? 16.sp : 26.sp,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

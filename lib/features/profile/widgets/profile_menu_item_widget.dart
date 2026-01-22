import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final String title;
  final Widget icon; // Can be Icon or AppImageViewer
  final VoidCallback onTap;

  const ProfileMenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.white),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: Center(child: icon),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondaryText,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}

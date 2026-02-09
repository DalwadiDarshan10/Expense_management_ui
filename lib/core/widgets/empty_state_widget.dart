import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String message;
  final String? subMessage;
  final double? height;
  final double? width;

  const EmptyStateWidget({
    super.key,
    required this.imagePath,
    required this.message,
    this.subMessage,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imagePath,
            height: height ?? 150.h,
            width: width ?? 150.w,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.titleMedium.copyWith(
              color: context.theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (subMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              subMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.theme.textTheme.bodyMedium?.color?.withOpacity(
                  0.7,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

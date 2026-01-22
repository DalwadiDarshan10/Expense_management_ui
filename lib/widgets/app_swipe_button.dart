import 'package:action_slider/action_slider.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSwipeButton extends StatelessWidget {
  const AppSwipeButton({
    super.key,
    required this.onAction,
    this.text = 'SWIPE TO TOP UP',
  });

  final Future<void> Function() onAction;
  final String text;
  final double mainRadius = 35; // height / 2 → 70 / 2

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mainRadius),
      child: ActionSlider.custom(
        sliderBehavior: SliderBehavior.move,
        width: double.infinity,
        height: 70.h,
        backgroundColor: AppColors.primary,
        toggleWidth: 56.w,
        toggleMargin: EdgeInsets.all(6.r), // balanced
        foregroundBuilder: (context, state, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
              size: 26.sp,
            ),
          );
        },
        backgroundBuilder: (context, state, child) {
          return Center(
            child: Text(
              text,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 16.sp,
              ),
            ),
          );
        },
        action: (sliderController) async {
          sliderController.loading();
          await onAction();
          sliderController.success();
          await Future.delayed(const Duration(milliseconds: 600));
          sliderController.reset();
        },
      ),
    );
  }
}

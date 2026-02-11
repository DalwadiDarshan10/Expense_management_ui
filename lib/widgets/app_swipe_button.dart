import 'package:action_slider/action_slider.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSwipeButton extends StatefulWidget {
  const AppSwipeButton({
    super.key,
    required this.onAction,
    this.text = 'SWIPE TO TOP UP',
  });

  final Future<void> Function() onAction;
  final String text;

  @override
  State<AppSwipeButton> createState() => _AppSwipeButtonState();
}

class _AppSwipeButtonState extends State<AppSwipeButton> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure we have enough width for the slider (toggle width + margins + buffer)
        // Toggle is 56.w, margins 6.r each side. ~68-70 width required minimum.
        if (constraints.maxWidth < 80) {
          return const SizedBox.shrink();
        }
        return ActionSlider.custom(
          sliderBehavior: SliderBehavior.move,
          width: constraints.maxWidth,

          height: 70.h,
          backgroundColor: AppColors.primary,
          toggleWidth: 56.w,
          toggleMargin: EdgeInsets.all(6.r),
          foregroundBuilder: (context, state, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 26.sp,
                        ),
                );
              },
            );
          },
          backgroundBuilder: (context, state, child) {
            return Padding(
              padding: EdgeInsets.only(left: 35.w + 6.r),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            );
          },
          action: (sliderController) async {
            _isLoading.value = true;
            sliderController.loading();
            try {
              await widget.onAction();

              if (!mounted) return;
              sliderController.success();
            } catch (e) {
              if (!mounted) return;
              sliderController.failure();
            } finally {
              if (!mounted) return;

              _isLoading.value = false;

              // Avoid reset if widget is going away
              await Future.delayed(const Duration(milliseconds: 300));

              if (mounted) {
                sliderController.reset();
              }
            }
          },
        );
      },
    );
  }
}

import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double elevation;
  final bool isCenter;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.borderRadius = 15.0,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.textStyle,
    this.elevation = 0,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    if (type == AppButtonType.text) {
      return _buildTextButton();
    }

    final isDisabled = !enabled || isLoading;
    final bgColor = _getBackgroundColor();
    final txtColor = _getTextColor();

    return Container(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: type == AppButtonType.primary && !isDisabled && elevation > 0
            ? [
                BoxShadow(
                  color: AppColors.dropButton,
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ]
            : null,
      ),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: type == AppButtonType.secondary
                  ? Border.all(
                      color: borderColor ?? AppColors.primary,
                      width: 1.5.w,
                    )
                  : null,
            ),
            alignment: isCenter ? Alignment.center : Alignment.centerLeft,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.w,
                        valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                      ),
                    ),
                  )
                : _buildContent(txtColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: (!enabled || isLoading) ? null : onPressed,
      style: TextButton.styleFrom(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        alignment: isCenter ? Alignment.center : Alignment.centerLeft,
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.primary,
                  ),
                ),
              ),
            )
          : Text(
              text,
              style:
                  textStyle ??
                  AppTextStyles.button.copyWith(
                    color: textColor ?? AppColors.primary,
                    fontSize: 16.sp,
                  ),
            ),
    );
  }

  Widget _buildContent(Color contentColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isCenter
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, color: contentColor, size: 24.sp),
          SizedBox(width: 10.w),
        ],
        Flexible(
          child: Text(
            maxLines: 1,
            text,
            style:
                textStyle ??
                AppTextStyles.button.copyWith(
                  color: contentColor,
                  fontSize: 16.sp,
                ),
          ),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: 8.w),
          Icon(suffixIcon, color: contentColor, size: 20.sp),
        ],
      ],
    );
  }

  Color _getBackgroundColor() {
    if (!enabled) return AppColors.surface;
    if (backgroundColor != null) return backgroundColor!;
    return type == AppButtonType.primary
        ? AppColors.primary
        : Colors.transparent;
  }

  Color _getTextColor() {
    if (!enabled) return AppColors.secondaryText;
    if (textColor != null) return textColor!;
    return type == AppButtonType.primary ? AppColors.white : AppColors.primary;
  }
}

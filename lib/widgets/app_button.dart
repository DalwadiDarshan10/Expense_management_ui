import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Button type enum for different button styles
enum AppButtonType {
  /// Primary filled button with purple background
  primary,

  /// Secondary button with outline
  secondary,

  /// Text-only button
  text,
}

/// A custom button widget that matches the app's design system.
///
/// This widget provides a button with rounded corners, proper styling,
/// and support for loading states, icons, and disabled states.
///
/// Example usage:
/// ```dart
/// AppButton(
///   text: 'Log in',
///   onPressed: () => handleLogin(),
/// )
/// ```
class AppButton extends StatelessWidget {
  /// The text displayed on the button
  final String text;

  /// Callback triggered when the button is pressed
  final VoidCallback? onPressed;

  /// The type of button (primary, secondary, text)
  final AppButtonType type;

  /// Whether the button is in a loading state
  final bool isLoading;

  /// Whether the button is enabled
  final bool enabled;

  /// Icon to display before the text
  final IconData? prefixIcon;

  /// Icon to display after the text
  final IconData? suffixIcon;

  /// Custom icon widget to display before the text
  final Widget? prefixIconWidget;

  /// Custom icon widget to display after the text
  final Widget? suffixIconWidget;

  /// Custom width (defaults to full width)
  final double? width;

  /// Custom height
  final double? height;

  /// Custom border radius
  final double borderRadius;

  /// Custom background color (overrides type color)
  final Color? backgroundColor;

  /// Custom text color (overrides type color)
  final Color? textColor;

  /// Custom border color (for secondary type)
  final Color? borderColor;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Elevation of the button
  final double elevation;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconWidget,
    this.suffixIconWidget,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.textStyle,
    this.elevation = 0,
  });

  /// Factory constructor for primary button with full width
  factory AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
    double? height,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.primary,
      isLoading: isLoading,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
      height: height,
    );
  }

  /// Factory constructor for secondary/outline button
  factory AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? width,
    double? height,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.secondary,
      isLoading: isLoading,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
      height: height,
    );
  }

  /// Factory constructor for text button
  factory AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool enabled = true,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Color? textColor,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      type: AppButtonType.text,
      isLoading: isLoading,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      textColor: textColor,
    );
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return AppColors.surface;
    }

    if (backgroundColor != null) {
      return backgroundColor!;
    }

    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return Colors.transparent;
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (!enabled) {
      return AppColors.secondaryText;
    }

    if (textColor != null) {
      return textColor!;
    }

    switch (type) {
      case AppButtonType.primary:
        return AppColors.white;
      case AppButtonType.secondary:
        return AppColors.primary;
      case AppButtonType.text:
        return AppColors.primary;
    }
  }

  Color _getBorderColor() {
    if (!enabled) {
      return AppColors.borderNor;
    }

    if (borderColor != null) {
      return borderColor!;
    }

    switch (type) {
      case AppButtonType.primary:
        return Colors.transparent;
      case AppButtonType.secondary:
        return AppColors.primary;
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 52.h;
    final buttonWidth = width ?? double.infinity;
    final isDisabled = !enabled || isLoading;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: type == AppButtonType.primary && enabled && elevation > 0
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
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius.r),
          splashColor: type == AppButtonType.primary
              ? AppColors.white.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.1),
          highlightColor: type == AppButtonType.primary
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.primary.withValues(alpha: 0.05),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: type == AppButtonType.secondary
                  ? Border.all(color: _getBorderColor(), width: 1.5.w)
                  : null,
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.w,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  : _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    final textWidget = Text(
      text,
      style:
          textStyle ??
          AppTextStyles.button.copyWith(
            color: _getTextColor(),
            fontSize: 16.sp,
          ),
    );

    final hasPrefix = prefixIcon != null || prefixIconWidget != null;
    final hasSuffix = suffixIcon != null || suffixIconWidget != null;

    if (!hasPrefix && !hasSuffix) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasPrefix) ...[
          prefixIconWidget ??
              Icon(prefixIcon, color: _getTextColor(), size: 20.sp),
          SizedBox(width: 8.w),
        ],
        textWidget,
        if (hasSuffix) ...[
          SizedBox(width: 8.w),
          suffixIconWidget ??
              Icon(suffixIcon, color: _getTextColor(), size: 20.sp),
        ],
      ],
    );
  }
}

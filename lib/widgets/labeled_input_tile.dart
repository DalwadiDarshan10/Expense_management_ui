import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';

class LabeledInputTile extends StatelessWidget {
  const LabeledInputTile({
    super.key,
    required this.title,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.trailingWidget,
    this.onChanged,
    this.readOnly = false,
    this.errorText,
    this.maxLength,
    this.prefix,
  });

  /// Left header text (Cash, Transfer Content, Bank)
  final String title;

  /// Optional right-side widget (balance text, dropdown, etc.)
  final Widget? trailingWidget;

  /// TextField controller
  final TextEditingController controller;

  final String? hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final int? maxLength;

  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER ROW
          Row(
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(width: 6.w),

              // const Spacer(),
              if (trailingWidget != null) trailingWidget!,
            ],
          ),

          SizedBox(height: 8.h),

          /// INPUT FIELD
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            maxLength: maxLength,

            onChanged: onChanged,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: Theme.of(context).hintColor,
              ),
              prefix: prefix,
              counterText: "",
              errorText: errorText, // Mapped here
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

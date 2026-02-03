import 'package:flutter/material.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';

class TransferInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefixText;
  final String? hintText;
  final TextInputType keyboardType;

  const TransferInputField({
    super.key,
    required this.label,
    required this.controller,
    this.prefixText,
    this.hintText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.borderNor,
                width: 1,
              ), // Underline style
            ),
          ),
          child: Row(
            children: [
              if (prefixText != null)
                Text(
                  prefixText!,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ), // Larger text
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: hintText,
                    hintStyle: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.hintText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

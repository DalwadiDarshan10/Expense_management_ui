import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int points;
  final double balance;

  const ProfileStatsWidget({
    super.key,
    required this.points,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Column(
        children: [
          _buildRow(
            context,
            'Poin',
            points.toString(),
            valueColor: AppColors.success,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Divider(color: Theme.of(context).dividerColor),
          ),
          _buildRow(
            context,
            'Balance in wallet',
            currencyFormatter.format(balance),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

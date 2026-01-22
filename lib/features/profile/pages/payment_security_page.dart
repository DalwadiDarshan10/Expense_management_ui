import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentSecurityPage extends StatefulWidget {
  const PaymentSecurityPage({super.key});

  @override
  State<PaymentSecurityPage> createState() => _PaymentSecurityPageState();
}

class _PaymentSecurityPageState extends State<PaymentSecurityPage> {
  bool transferLimit = true;
  bool appLocks = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 20.r,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          'Payment Security',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Transfer Limit',
                    value: transferLimit,
                    onChanged: (val) => setState(() => transferLimit = val),
                  ),
                  Divider(color: AppColors.dividerColor, height: 24.h),
                  _buildDropdownTile(
                    title: 'Transaction limit',
                    value: '\$ 200',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'App Automatically Locks',
                    value: appLocks,
                    onChanged: (val) => setState(() => appLocks = val),
                  ),
                  Divider(color: AppColors.dividerColor, height: 24.h),
                  _buildDropdownTile(
                    title: 'Screen lock time',
                    value: '2 min',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.secondaryText,
                size: 24.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

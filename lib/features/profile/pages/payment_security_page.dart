import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expense/features/profile/controllers/profile_controller.dart';
import 'package:expense/features/profile/controllers/security_controller.dart';
import 'package:get/get.dart';

class PaymentSecurityPage extends StatefulWidget {
  const PaymentSecurityPage({super.key});

  @override
  State<PaymentSecurityPage> createState() => _PaymentSecurityPageState();
}

class _PaymentSecurityPageState extends State<PaymentSecurityPage> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final SecurityController _securityController = Get.find<SecurityController>();

  String get transferLimitTillValue => AppStrings.endOfDay;

  String _getTimeLabel(int seconds) {
    if (seconds == 30) return AppStrings.time30Sec;
    if (seconds == 60) return AppStrings.time1Min;
    if (seconds == 120) return AppStrings.time2Min;
    if (seconds == 180) return AppStrings.time3Min;
    if (seconds == 300) return AppStrings.time5Min;
    return '${seconds ~/ 60} ${AppStrings.minLabel}';
  }

  void _showTransactionLimitPicker() {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _limitOption('\$ 200'),
            _limitOption('\$ 500'),
            _limitOption('\$ 1000'),
            _limitOption('\$ 2000'),
            _limitOption('\$ 5000'),
          ],
        ),
      ),
    );
  }

  Widget _limitOption(String label) {
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: () {
        // Parse value from label e.g. "$ 200" -> 200.0
        final cleanVal = label.replaceAll(RegExp(r'[^\d.]'), '');
        final double limit = double.tryParse(cleanVal) ?? 200.0;

        _profileController.updateTransactionLimit(limit);
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          AppStrings.paymentSecurity,
          style: AppTextStyles.titleLarge.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Column(
                children: [
                  Obx(
                    () => _buildSwitchTile(
                      title: AppStrings.transferLimit,
                      value: _profileController.isTransactionLimitEnabled.value,
                      onChanged: (val) =>
                          _profileController.toggleTransactionLimit(val),
                    ),
                  ),
                  Divider(color: Theme.of(context).dividerColor, height: 24.h),
                  Obx(
                    () => _buildDropdownTile(
                      title: AppStrings.transactionLimit,
                      value:
                          '\$ ${_profileController.transactionLimit.value.toStringAsFixed(0)}',
                      onTap: _showTransactionLimitPicker,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Obx(
                () => Column(
                  children: [
                    _buildSwitchTile(
                      title: AppStrings.appAutoLocks,
                      value: _securityController.isAutoLockEnabled.value,
                      onChanged: (val) {
                        if (val && _securityController.pinHash.value.isEmpty) {
                          Get.toNamed('/pin-setup');
                        } else {
                          _securityController.toggleAutoLock(val);
                        }
                      },
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 24.h,
                    ),
                    _buildDropdownTile(
                      title: AppStrings.screenLockTime,
                      value: _getTimeLabel(
                        _securityController.autoLockTimeout.value,
                      ),
                      onTap: _showTimePicker,
                    ),
                  ],
                ),
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
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.success, // green background
          activeThumbColor: Colors.white, // white circle
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
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).iconTheme.color,
                size: 24.r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimePicker() {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _timeOption(AppStrings.time30Sec, 30),
            _timeOption(AppStrings.time1Min, 60),
            _timeOption(AppStrings.time2Min, 120),
            _timeOption(AppStrings.time3Min, 180),
            _timeOption(AppStrings.time5Min, 300),
          ],
        ),
      ),
    );
  }

  Widget _timeOption(String label, int seconds) {
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: () {
        _securityController.updateTimeout(seconds);
        Get.back();
      },
    );
  }
}

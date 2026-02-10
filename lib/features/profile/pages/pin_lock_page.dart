import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controllers/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PinLockPage extends StatefulWidget {
  const PinLockPage({super.key});

  @override
  State<PinLockPage> createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage> {
  final SecurityController _securityController = Get.find<SecurityController>();
  String _pin = '';
  String _errorMessage = '';

  void _handleKeyPress(String value) {
    setState(() {
      _errorMessage = '';
      if (_pin.length < 4) {
        _pin += value;
      }
      if (_pin.length == 4) {
        _verifyPin();
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _verifyPin() {
    if (_securityController.verifyPin(_pin)) {
      // success - unlockApp is called inside controller
    } else {
      setState(() {
        _pin = '';
        _errorMessage = AppStrings.incorrectPin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Icon(Icons.lock_outline, size: 64.r, color: AppColors.primary),
            SizedBox(height: 24.h),
            Text(
              AppStrings.enterPinTitle,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.enterPinMsg,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: 40.h),
            _buildPinDots(_pin),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 20.h),
              Text(
                _errorMessage,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
            const Spacer(),
            _buildKeyboard(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isFilled = index < pin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.grey.withOpacity(0.3),
            border: Border.all(
              color: isFilled
                  ? AppColors.primary
                  : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 70.w),
              _buildKey('0'),
              _buildKey('backspace', isIcon: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, {bool isIcon = false}) {
    return InkWell(
      onTap: () {
        if (isIcon) {
          _handleBackspace();
        } else {
          _handleKeyPress(value);
        }
      },
      borderRadius: BorderRadius.circular(35.r),
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).cardColor,
        ),
        alignment: Alignment.center,
        child: isIcon
            ? Icon(
                Icons.backspace_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            : Text(
                value,
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

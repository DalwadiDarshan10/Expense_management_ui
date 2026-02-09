import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/profile/controller/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final SecurityController _securityController = Get.find<SecurityController>();
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMessage = '';

  void _handleKeyPress(String value) {
    setState(() {
      _errorMessage = '';
      if (_isConfirming) {
        if (_confirmPin.length < 4) {
          _confirmPin += value;
        }
        if (_confirmPin.length == 4) {
          _verifyAndSave();
        }
      } else {
        if (_pin.length < 4) {
          _pin += value;
        }
        if (_pin.length == 4) {
          _isConfirming = true;
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _verifyAndSave() async {
    if (_pin == _confirmPin) {
      await _securityController.setPin(_pin);
      Get.back();
      _showSuccessSnackbar();
    } else {
      setState(() {
        _confirmPin = '';
        _errorMessage = AppStrings.pinMismatch;
      });
    }
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      AppStrings.success,
      'PIN set successfully',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isConfirming
        ? AppStrings.confirmPinTitle
        : AppStrings.setPinTitle;
    final message = _isConfirming
        ? AppStrings.confirmPinMsg
        : AppStrings.setPinMsg;
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            _buildPinDots(currentPin),
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

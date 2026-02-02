import 'dart:ui';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_by_wallet_controller.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TransferByWalletPage extends GetView<TransferByWalletController> {
  const TransferByWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dark theme mood specifically for this premium screen if acceptable,
    // or just use deep colors.
    final backgroundColor = Color(0xFF1F2937); // Deep premium blue/grey

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Gradient Spots
          Positioned(
            top: -100,
            left: -50,
            child: _buildGlowOrb(AppColors.primary, 300),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlowOrb(AppColors.secondary, 250),
          ),

          // Glassmorphic Overlay/Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(),

                SizedBox(height: 20.h),

                // Recipient Avatar (The "North Star")
                _buildRecipientSection(),

                Spacer(),

                // Amount Display
                _buildAmountDisplay(),

                SizedBox(height: 20.h),

                // Note Field
                _buildGlassNoteField(),

                Spacer(),

                // Keypad & Swipe
                _buildKeypadAndSwipe(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.4),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 100,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          ),
          Text(
            "Transfer Money",
            style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: () {}, // Maybe help or options
            icon: Icon(Icons.more_horiz, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 40.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "Direct Transfer",
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "From Wallet Balance",
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildAmountDisplay() {
    return Obx(() {
      final amount = controller.amountController.text;
      final isEmpty = amount.isEmpty;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "\$",
                style: AppTextStyles.headingLarge.copyWith(
                  color: isEmpty ? Colors.white30 : Colors.white,
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                isEmpty ? "0" : amount,
                style: AppTextStyles.headingLarge.copyWith(
                  color: isEmpty ? Colors.white30 : Colors.white,
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (controller.amountError.value != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                controller.amountError.value!,
                style: TextStyle(color: AppColors.error, fontSize: 14.sp),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildGlassNoteField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 300.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller.contentController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(Icons.edit, color: Colors.white54, size: 18.sp),
              hintText: "Add a note",
              hintStyle: TextStyle(color: Colors.white30),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadAndSwipe() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        children: [
          // Custom Keypad
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.8,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _numberButton("1"),
                _numberButton("2"),
                _numberButton("3"),
                _numberButton("4"),
                _numberButton("5"),
                _numberButton("6"),
                _numberButton("7"),
                _numberButton("8"),
                _numberButton("9"),
                _numberButton("."),
                _numberButton("0"),
                _backspaceButton(),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Swipe Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: AppSwipeButton(
              onAction: () async {
                await controller.onTransfer();
              },
              text: "Swipe to Send",
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberButton(String val) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Create "Real App" feel
        controller.onNumberPress(val);
      },
      child: Center(
        child: Text(
          val,
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
            fontSize: 24.sp,
          ),
        ),
      ),
    );
  }

  Widget _backspaceButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.onBackspace();
      },
      child: Center(
        child: Icon(
          Icons.backspace_outlined,
          color: Colors.white70,
          size: 24.sp,
        ),
      ),
    );
  }
}

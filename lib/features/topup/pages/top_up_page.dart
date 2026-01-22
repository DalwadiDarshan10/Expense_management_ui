import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/features/topup/controllers/top_up_controller.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TopUpPage extends GetView<TopUpController> {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Top Up',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Denominations Section
            _buildDenominationsSection(),

            SizedBox(height: 8.h),

            // Cash Section
            _buildCashSection(),

            SizedBox(height: 8.h),

            // Selected Bank Card Section
            _buildBankCardSection(),

            SizedBox(height: 40.h),

            AppSwipeButton(
              onAction: () async {
                controller.performTopUp();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDenominationsSection() {
    final List<int> denominations = [50, 100, 200, 500, 1000, 2000];

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Denominations',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.5,
            ),
            itemCount: denominations.length,
            itemBuilder: (context, index) {
              final amount = denominations[index];
              return Obx(() {
                final isSelected =
                    controller.selectedDenomination.value == amount;

                return GestureDetector(
                  onTap: () => controller.selectDenomination(amount),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '\$$amount',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCashSection() {
    return LabeledInputTile(
      title: 'Cash',
      controller: controller.customAmountController,
      keyboardType: TextInputType.number,
      hintText: '\$ Enter amount',
      trailingWidget: Row(
        children: [
          Text(
            '(Surplus: ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Text(
            '\$12,789.00',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            ')',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankCardSection() {
    return Obx(() {
      // Use the first saved card if available, else show a placeholder
      if (controller.savedCards.isEmpty) {
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderNor),
          ),
          child: Row(
            children: [
              AppImageViewer(
                imagePath: AppImages.appLogo,
                width: 56.w,
                height: 56.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'No cards available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final selectedCard =
          controller.savedCards[controller.selectedCardIndex.value];
      final maskedCardNumber = _maskCardNumber(selectedCard.cardNumber);

      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderNor),
        ),
        child: Row(
          children: [
            // Card Icon
            AppImageViewer(
              imagePath: AppImages.appLogoSquare,
              width: 56.w,
              height: 56.h,
            ),
            SizedBox(width: 12.w),
            // Card Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCard.bankName,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    maskedCardNumber,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            // More Options
            Icon(Icons.more_horiz, color: AppColors.secondaryText, size: 24.sp),
          ],
        ),
      );
    });
  }

  String _maskCardNumber(String cardNumber) {
    // Remove spaces and non-digits
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length < 4) return cardNumber;

    // Show only last 4 digits, mask the rest
    final lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '•••• •••• •••• $lastFour';
  }
}

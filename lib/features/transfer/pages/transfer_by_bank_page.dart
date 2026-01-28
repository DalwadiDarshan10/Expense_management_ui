import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_by_bank_controller.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:expense/widgets/users_componant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TransferByBankPage extends GetView<TransferByBankController> {
  const TransferByBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors
          .surface, // Matches the grey/white bg from design context usually
      appBar: AppBar(
        title: Text('Transfer By Bank', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: AppColors.primaryText,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Bank Card (Source) - using SelectedUserTile
                    SelectedUserTile(
                      name: 'AVI BANK',
                      subtitle: '123 456 789 000',
                      isArrowRight: true,
                      isBig: true,
                      isBorder: true,
                      onTap: () {}, // Potentially open source selector
                      avatar: AppImageViewer(
                        imagePath: AppImages.appLogoSquare,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // To The Account
                    Obx(
                      () => LabeledInputTile(
                        title: 'To The Account',
                        controller: controller.accountController,
                        hintText: '122 456 141 250',
                        keyboardType: TextInputType.number,
                        errorText: controller.accountError.value,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Bank Selection - Custom implementation to match style since LabeledInputTile is TextField only
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedBank.value,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.secondaryText,
                                ),
                                hint: Text(
                                  'Select Bank',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                items: controller.banks.map((String bank) {
                                  return DropdownMenuItem<String>(
                                    value: bank,
                                    child: Text(
                                      bank,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: controller.onBankSelected,
                              ),
                            ),
                          ),
                          // Add a divider line to match LabeledInputTile look
                          const Divider(
                            color: AppColors.dividerColor,
                            height: 1,
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Cash Amount
                    Obx(
                      () => LabeledInputTile(
                        title: 'Cash',
                        controller: controller.amountController,
                        hintText: '\$ 12.00.00',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: controller.amountError.value,
                        trailingWidget: Text(
                          '(balance \$${controller.balance.toStringAsFixed(2)})',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(
                              0xFF6B7280,
                            ), // Cool gray / blurple text
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Transfer Content
                    LabeledInputTile(
                      title: 'Transfer Content',
                      controller: controller.contentController,
                      hintText: 'Loan Payment',
                    ),

                    SizedBox(height: 40.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: AppSwipeButton(
                        onAction: () async {
                          controller.onTransfer();
                        },
                        text: "SWIPE TO TRANSFER",
                      ),
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
}

import 'package:expense/core/constants/app_strings.dart';
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
        title: Text(
          AppStrings.transferByBankTitle,
          style: AppTextStyles.titleLarge,
        ),
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

                    // Bank Card (Source) - Selectable
                    Obx(() {
                      final bank = controller.selectedSourceBank.value;
                      final bankName = bank != null
                          ? bank['bankName']
                          : "Select Bank";
                      final balance = bank != null
                          ? "\$${bank['balance']}"
                          : "";

                      return SelectedUserTile(
                        name: bankName ?? "Unknown Bank",
                        subtitle: balance,
                        isArrowRight: true,
                        isBig: true,
                        isBorder: true,
                        onTap: () {
                          // Show Bottom Sheet to select Source Bank
                          Get.bottomSheet(
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Select Source Bank",
                                    style: AppTextStyles.titleMedium,
                                  ),
                                  SizedBox(height: 10.h),
                                  Expanded(
                                    child: Obx(
                                      () => ListView.builder(
                                        itemCount: controller
                                            .walletController
                                            .savedBankAccounts
                                            .length,
                                        itemBuilder: (context, index) {
                                          final b = controller
                                              .walletController
                                              .savedBankAccounts[index];
                                          return ListTile(
                                            title: Text(
                                              b['bankName'] ?? "Bank",
                                            ),
                                            subtitle: Text(
                                              "Balance: \$${b['balance']}",
                                            ),
                                            onTap: () {
                                              controller.onSourceBankSelected(
                                                b,
                                              );
                                              Get.back();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        avatar: AppImageViewer(
                          imagePath: AppImages.appLogoSquare,
                        ),
                      );
                    }),

                    SizedBox(height: 12.h),

                    // To The Account
                    Obx(
                      () => LabeledInputTile(
                        title: AppStrings.toTheAccountLabel,
                        controller: controller.accountController,
                        hintText: AppStrings.toTheAccountHint,
                        keyboardType: TextInputType.number,
                        errorText: controller.accountError.value,
                        maxLength: 16,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Bank Selection (Recipient Bank)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.bankLabel,
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
                                value: controller.selectedRecipientBank.value,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.secondaryText,
                                ),
                                hint: Text(
                                  AppStrings.selectBank,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                items: controller.recipientBanks.map((
                                  String bank,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: bank,
                                    child: Text(
                                      bank,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: controller.onRecipientBankSelected,
                              ),
                            ),
                          ),
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
                    Obx(() {
                      final balance =
                          controller.selectedSourceBank.value?['balance'] ?? 0;
                      return LabeledInputTile(
                        title: AppStrings.cashLabel,
                        controller: controller.amountController,
                        hintText: AppStrings.cashHintBank,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        errorText: controller.amountError.value,
                        trailingWidget: Text(
                          '(balance \$${balance.toString()})',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF6B7280),
                            fontSize: 12.sp,
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 12.h),

                    // Transfer Content
                    LabeledInputTile(
                      title: AppStrings.transferContentLabel,
                      controller: controller.contentController,
                      hintText: AppStrings.transferContentHint,
                    ),

                    SizedBox(height: 40.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: AppSwipeButton(
                        onAction: () async {
                          await controller.onTransfer();
                        },
                        text: AppStrings.swipeToTransfer,
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

import 'dart:ui';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_by_bank_controller.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:expense/widgets/users_componant.dart';

class TransferByBankPage extends GetView<TransferByBankController> {
  const TransferByBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.transferByBankTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: AppColors.primary,
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
                              color: Theme.of(context).cardColor,
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
                        avatar: const AppImageViewer(
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.bankLabel,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color, // Fixed
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
                                dropdownColor: Theme.of(
                                  context,
                                ).cardColor, // Ensure popup matches
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
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        // Inherit color
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: controller.onRecipientBankSelected,
                              ),
                            ),
                          ),
                          // Add a divider line to match LabeledInputTile look
                          Divider(
                            color: Theme.of(context).dividerColor,
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
                        trailingWidget: RichText(
                          text: TextSpan(
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium, // base style
                            children: [
                              const TextSpan(text: '(balance '),

                              TextSpan(
                                text: '\$ ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              TextSpan(
                                text: balance.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),

                              const TextSpan(text: ')'),
                            ],
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

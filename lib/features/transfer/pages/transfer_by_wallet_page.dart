import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_by_wallet_controller.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TransferByWalletPage extends GetView<TransferByWalletController> {
  const TransferByWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.transferByWalletTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // Amount Input
                    Obx(
                      () => LabeledInputTile(
                        title: AppStrings.cashLabel,
                        controller: controller.amountController,
                        hintText: AppStrings.cashHintWallet,
                        prefix: Text(
                          "",
                          style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 16.sp,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
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
                                text: controller.balance.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),

                              const TextSpan(text: ')'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Note / Content
                    LabeledInputTile(
                      title: AppStrings.transferContentLabel,
                      controller: controller.contentController,
                      hintText: AppStrings.transferContentHint,
                    ),

                    SizedBox(height: 8.h),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.only(
                        left: 24.w,
                        top: 14.h,
                        bottom: 14.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.greetingCards,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color, // Fixed
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 80.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.greetingCards.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                final cardImage =
                                    controller.greetingCards[index];
                                return Obx(() {
                                  final isSelected =
                                      controller.selectedGreetingIndex.value ==
                                      index;
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.selectGreetingCard(index),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 80.w,
                                      height: 80.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: isSelected
                                            ? Border.all(
                                                color: AppColors.primary,
                                                width: 1.5,
                                              )
                                            : null,
                                      ),
                                      padding: EdgeInsets.all(8.r),
                                      child: AppImageViewer(
                                        imagePath: cardImage,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Greeting Cards Section
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
                    SizedBox(height: 20.h),
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

import 'package:expense/widgets/app_swipe_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/labeled_input_tile.dart' show LabeledInputTile;
import 'package:expense/widgets/users_componant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_by_wallet_controller.dart';

class TransferByWalletPage extends GetView<TransferByWalletController> {
  const TransferByWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Transfer By Wallet', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    SelectedUserTile(
                      name: "Irene Perry",
                      subtitle: "505-287-8051",
                      isBorder: true,
                      isArrowRight: false,
                      onTap: () {},
                      isBig: true,
                    ),

                    // Selected User Card
                    SizedBox(height: 8.h),
                    LabeledInputTile(
                      title: "Cash",
                      controller: controller.amountController,
                      hintText: "\$ 12,000.00",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8.h),
                    // Transfer Content
                    LabeledInputTile(
                      title: "Transfer Content",
                      controller: controller.contentController,
                      hintText: "Loan Payment",
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 13.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Greeting Cards",
                            style: AppTextStyles.titleMedium,
                          ),
                          SizedBox(height: 12.h),

                          SizedBox(
                            height: 80.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.greetingCards.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  final isSelected =
                                      controller.selectedGreetingIndex.value ==
                                      index;

                                  return GestureDetector(
                                    onTap: () =>
                                        controller.selectGreetingCard(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: AppImageViewer(
                                        imagePath:
                                            controller.greetingCards[index],
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

                    const SizedBox(height: 32),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: AppSwipeButton(
                        onAction: () async {},
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

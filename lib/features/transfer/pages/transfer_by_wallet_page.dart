import 'package:expense/core/constants/app_strings.dart';
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
        title: Text(
          AppStrings.transferByWalletTitle,
          style: AppTextStyles.titleLarge,
        ),
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
                    Obx(() {
                      final contact = controller.selectedContact.value;
                      if (contact == null) return const SizedBox.shrink();
                      return SelectedUserTile(
                        name: contact.name, // "Irene Perry"
                        subtitle: contact.phone, // "505-287-8051"
                        isBorder: true,
                        isArrowRight: false,
                        onTap: () {},
                        isBig: true,
                        avatar: Container(
                          width: 54.w,
                          height: 54.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: CircleAvatar(
                            backgroundColor: AppColors.bgSeparator,
                            backgroundImage: contact.avatarUrl != null
                                ? AssetImage(contact.avatarUrl!)
                                : null,
                            child: contact.avatarUrl == null
                                ? Text(
                                    contact.name.isNotEmpty
                                        ? contact.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: AppColors.primaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),

                    // Selected User Card
                    SizedBox(height: 8.h),
                    LabeledInputTile(
                      title: AppStrings.cashLabel,
                      controller: controller.amountController,
                      hintText: AppStrings.cashHintWallet,
                      keyboardType: TextInputType.number,
                      errorText: controller.amountError.value,
                    ),
                    SizedBox(height: 8.h),
                    // Transfer Content
                    LabeledInputTile(
                      title: AppStrings.transferContentLabel,
                      controller: controller.contentController,
                      hintText: AppStrings.transferContentHint,
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
                            AppStrings.greetingCards,
                            style: AppTextStyles.titleMedium,
                          ),
                          SizedBox(height: 12.h),

                          SizedBox(
                            height: 80.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.greetingCards.length,
                              separatorBuilder: (_, _) => SizedBox(width: 12.w),
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
                        onAction: () async {
                          controller.onTransfer();
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

import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/friends/models/friend_model.dart';
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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Recipient info
                    Obx(() {
                      if (controller.isFetchingRecipient.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final contact = controller.selectedContact.value;
                      if (contact == null) {
                        return _buildSelectRecipientPlaceholder(context);
                      }

                      // If scanned (has receiverUid), show detailed profile
                      if (controller.receiverUid.value != null) {
                        return _buildScannedUserProfile(context, contact);
                      }

                      // Otherwise show list-tile style for picked friend
                      return _buildSelectedFriendProfile(context, contact);
                    }),

                    SizedBox(height: 8.h),

                    // Amount Input
                    Obx(
                      () => LabeledInputTile(
                        title: AppStrings.cashLabel,
                        controller: controller.amountController,
                        hintText: AppStrings.cashHintWallet,
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
                          SizedBox(height: 8.h),
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

  Widget _buildSelectRecipientPlaceholder(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickContact(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add_rounded,
                color: AppColors.primary,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Recipient",
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    "Please select who you want to transfer money to",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryText,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.r,
              color: AppColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedUserProfile(BuildContext context, FriendModel contact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40.r,
            backgroundColor: AppColors.primary,
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : "?",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Name
          Text(
            contact.name,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8.h),
          // Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, size: 16.sp, color: AppColors.secondaryText),
              SizedBox(width: 8.w),
              Text(
                contact.phone,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 16.sp, color: AppColors.secondaryText),
              SizedBox(width: 8.w),
              Text(
                contact.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFriendProfile(BuildContext context, FriendModel friend) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        onTap: () => controller.pickContact(),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        leading: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5.w),
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          friend.name,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          friend.phone,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.r,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}

import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/wallet/widgets/credit_card_widget.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class WalletsDashboardPage extends GetView<WalletController> {
  const WalletsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Blue Header Section with Background Image (Matches HomePage)
            _buildHeaderSection(context),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  // Add New Card Button
                  SizedBox(
                    height: 58.h,
                    child: AppButton(
                      text: AppStrings.btnAddNewCard,
                      onPressed: () {
                        controller.resetForm();
                        Get.toNamed(AppNamed.addNewCard);
                      },
                      prefixIcon: Icons.add_circle_outline,
                      isCenter: false,
                    ),
                  ),
                  // Saved Cards List
                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.savedCards.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(controller.savedCards[index]),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.30, // width of action
                            children: [
                              CustomSlidableAction(
                                backgroundColor: AppColors.critical.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                onPressed: (context) {
                                  final card = controller.savedCards[index];
                                  Get.defaultDialog(
                                    title: AppStrings.deleteCardTitle,
                                    middleText: AppStrings.deleteCardMessage,
                                    textCancel: AppStrings.cancel,
                                    textConfirm: AppStrings.delete,
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.red,
                                    onConfirm: () {
                                      controller.removeCard(card);
                                      Get.back();
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 24.sp, // 🔥 ICON SIZE CONTROL
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (controller.savedCards.isNotEmpty &&
                                  index < controller.savedCards.length) {
                                controller.populateForEdit(
                                  controller.savedCards[index],
                                );
                                Get.toNamed(AppNamed.addNewCard);
                              }
                            },
                            child: CreditCardWidget(
                              card: controller.savedCards[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        // Blue curved background using SVG image/Asset
        Container(
          height: 200.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          width: double.infinity,
          child: AppImageViewer(
            imagePath: AppImages.menuPageBackground,
            fit: BoxFit.fill,
          ),
        ),
        // Content on top of the background
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      AppStrings.myWallet,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Placeholder for balance/alignment
                    SizedBox(width: 40.w),
                  ],
                ),
                SizedBox(height: 14.h),
                // Balance Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.balance,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        '.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '\$${controller.walletBalance.value.toStringAsFixed(2)}',
                        style: AppTextStyles.headingLarge.copyWith(
                          color: AppColors.primarySup,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),
                // Action Buttons Row (in a container like HomePage)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildHeaderAction(
                            context,
                            icon: AppImages.topupIcon,
                            label: AppStrings.topUp,
                            onTap: () => Get.toNamed(AppNamed.topUpPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            context,
                            icon: AppImages.transferIcon,
                            label: AppStrings.transferTitle,

                            onTap: () => Get.toNamed(AppNamed.transferPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            context,
                            icon: AppImages.withdrawIcon,
                            label: AppStrings.withdraw,

                            onTap: () => Get.toNamed(AppNamed.withdrawPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            context,
                            icon: AppImages.historyIcon,
                            label: AppStrings.history,
                            onTap: () => Get.toNamed(AppNamed.notificationPage),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderAction(
    BuildContext context, {
    required String icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AppImageViewer(
            imagePath: icon,
            height: 24.h,
            width: 24.w,
            color: color,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: Theme.of(context).textTheme.labelMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

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
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Blue Header Section with Background Image (Matches HomePage)
            _buildHeaderSection(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  // Add New Card Button
                  AppButton(
                    text: AppStrings.btnAddNewCard,
                    onPressed: () => Get.toNamed(AppNamed.addNewCard),
                    prefixIcon: Icons.add_circle_outline,
                    isCenter: false,
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
                                backgroundColor: AppColors.bgSeparator,
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
                          child: CreditCardWidget(
                            card: controller.savedCards[index],
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

  Widget _buildHeaderSection() {
    return Stack(
      children: [
        // Blue curved background using SVG image/Asset
        Container(
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
                    const Opacity(
                      opacity: 0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: null,
                      ),
                    ),
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
                    Text(
                      '\$12,769.00',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.primarySup,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),
                // Action Buttons Row (in a container like HomePage)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
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
                            icon: AppImages.topupIcon,
                            label: AppStrings.topUp,
                            onTap: () => Get.toNamed(AppNamed.topUpPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            icon: AppImages.walletIcon,
                            label: AppStrings.transferTitle,
                            color: AppColors.primary,
                            onTap: () => Get.toNamed(AppNamed.transferPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            icon: AppImages.scanIcon,
                            label: AppStrings.withdraw,
                            color: AppColors.primary,
                            onTap: () => Get.toNamed(AppNamed.withdrawPage),
                          ),
                        ),
                        Expanded(
                          child: _buildHeaderAction(
                            icon: AppImages.notificationIcon,
                            label: AppStrings.history,
                            color: AppColors.primary,
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

  Widget _buildHeaderAction({
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
              color: AppColors.primaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

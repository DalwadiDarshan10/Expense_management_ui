import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Blue Header Section with Background Image
            _buildHeaderSection(context),
            SizedBox(height: 24.h),
            // Send Again Section
            _buildSendAgainSection(),
            Container(height: 8.h, color: AppColors.background),
            // Payment List Section
            _buildPaymentListSection(),
            Container(height: 8.h, color: AppColors.background),
            // Trading History Section
            _buildTradingHistorySection(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        // Blue curved background using SVG image
        SizedBox(
          height: 210.h,
          width: double.infinity,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
            child: AppImageViewer(
              imagePath: AppImages.menuPageBackground,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content on top of the background
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                // Notification row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppNamed.notificationPage);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        child: Stack(
                          children: [
                            AppImageViewer(
                              imagePath: AppImages.notificationIcon,
                              height: 24.h,
                              width: 24.w,
                              color: AppColors.white,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySup,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Balance Section
                GestureDetector(
                  onTap: () {
                    final walletController = Get.find<WalletController>();
                    _showBalanceDetails(context, walletController);
                  },
                  child: Column(
                    children: [
                      Text(
                        AppStrings.balance,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(() {
                        final walletController = Get.find<WalletController>();
                        // Helper to format currency if needed, or just toStringAsFixed
                        return Text(
                          '\$${walletController.totalBankBalance.toStringAsFixed(2)}',
                          style: AppTextStyles.headingLarge.copyWith(
                            color: AppColors.primarySup,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                // Action Buttons Row
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.backLanding,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppNamed.topUpPage);
                            },
                            child: _buildActionButton(
                              icon: AppImages.topupIcon,
                              label: AppStrings.topUp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppNamed.walletsDashboard);
                            },
                            child: _buildActionButton(
                              icon: AppImages.walletIcon,
                              label: AppStrings.wallet,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppNamed.scannerPage);
                            },
                            child: _buildActionButton(
                              icon: AppImages.scanIcon,
                              label: AppStrings.qrScan,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppNamed.myQrPage);
                            },
                            child: _buildActionButton(
                              icon: AppImages.myQrcodeIcon,
                              label: AppStrings.myQr,
                            ),
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

  Widget _buildActionButton({required String icon, required String label}) {
    return Column(
      children: [
        AppImageViewer(imagePath: icon, height: 24.h, width: 24.w),
        SizedBox(height: 5.h),
        Text(label),
      ],
    );
  }

  Widget _buildSendAgainSection() {
    final contacts = [
      {'name': 'John', 'color': const Color(0xFFFFB74D)},
      {'name': 'Lovi ', 'color': const Color(0xFF4FC3F7)},
      {'name': 'Hametrius', 'color': const Color(0xFFE57373)},
      {'name': 'Leshaad', 'color': const Color(0xFF81C784)},
      {'name': 'Lane R.', 'color': const Color(0xFFBA68C8)},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.sendAgain,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: contacts.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _buildContactAvatar(
                  name: contact['name'] as String,
                  color: contact['color'] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAvatar({required String name, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Center(
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 64.w,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.secondaryText,
              height: 1.2,
              fontSize: 12.sp, // Explicit font size to ensure fit
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentListSection() {
    final paymentItems = [
      {
        'icon': AppImages.electricityBadge,
        'label': AppStrings.categoryElectricity,
        // 'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.internetBadge,
        'label': AppStrings.categoryInternet,
        // 'color': const Color(0xFF9C27B0),
      },
      {
        'icon': AppImages.insuranceBadge,
        'label': AppStrings.insurance,
        // 'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.medicalBadge,
        'label': AppStrings.categoryMedical,
        // 'color': const Color(0xFFF44336),
      },
      {
        'icon': AppImages.marketBadge,
        'label': AppStrings.categoryMarket,
        // 'color': const Color(0xFF4CAF50),
      },
      {
        'icon': AppImages.electricBillBadge,
        'label': AppStrings.electricBill,
        // 'color': const Color(0xFFFF9800),
      },
      {
        'icon': AppImages.televisionBadge,
        'label': AppStrings.television,
        // 'color': const Color(0xFF2196F3),
      },
      {
        'icon': AppImages.waterbillBadge,
        'label': AppStrings.waterBill,
        // 'color': const Color(0xFF03A9F4),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.paymentList,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 11.h,
              // crossAxisSpacing: 1.w,
              childAspectRatio: 0.85,
            ),
            itemCount: paymentItems.length,
            itemBuilder: (context, index) {
              final item = paymentItems[index];
              return _buildPaymentItem(
                icon: item['icon'] as String,
                label: item['label'] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({required String icon, required String label}) {
    return Column(
      children: [
        AppImageViewer(imagePath: icon, height: 56.h, width: 56.w),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTradingHistorySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tradingHistory,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTransactionItem(
            icon: AppImages.electricBillBadge,
            title: AppStrings.electricBillTitle,
            subtitle: AppStrings.sent,
            amount: '-\$420',
            isNegative: true,
            date: "Today - 3.14",
            onTap: () => Get.toNamed(AppNamed.shareBill),
          ),
          SizedBox(height: 20.h),
          _buildTransactionItem(
            icon: AppImages.televisionBadge,
            title: AppStrings.televisionBillTitle,
            subtitle: AppStrings.sent,
            amount: '\$420',
            isNegative: true,
            date: "22 jan- 3.14",
            onTap: () => Get.toNamed(AppNamed.shareBill),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isNegative,
    required String date,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AppImageViewer(imagePath: icon, height: 56.h, width: 56.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      amount,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isNegative
                            ? AppColors.success
                            : AppColors.primaryText,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      date,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBalanceDetails(BuildContext context, WalletController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Accounts",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.savedBankAccounts.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final bank = controller.savedBankAccounts[index];
                    final bankName = bank['bankName'] ?? 'Bank Account';
                    final balance = bank['balance'] ?? 0;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(bankName, style: AppTextStyles.bodyLarge),
                      trailing: Text(
                        "\$${balance.toString()}",
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(thickness: 1.5),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Balance",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Text(
                    "\$${controller.totalBankBalance.toStringAsFixed(2)}",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

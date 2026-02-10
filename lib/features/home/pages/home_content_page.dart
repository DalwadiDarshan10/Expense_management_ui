import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/transfer/controllers/transfer_controller.dart';
import 'package:expense/features/bill/controller/utility_bill_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Blue Header Section with Background Image
              _buildHeaderSection(context),
              SizedBox(height: 24.h),
              // Send Again Section
              _buildSendAgainSection(context),
              Container(
                height: 8.h,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              // Payment List Section
              _buildPaymentListSection(context),
              Container(
                height: 8.h,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              // Trading History Section
              _buildTradingHistorySection(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 40.h,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),
              ),
              child: const AppImageViewer(
                imagePath: AppImages.menuPageBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Notification row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(AppNamed.allTransactions),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              AppImageViewer(
                                imagePath: AppImages.notificationIcon,
                                height: 24.h,
                                width: 24.w,
                                color: AppColors.white,
                              ),
                              Positioned(
                                right: 1.r,
                                top: -2.r,
                                child: Container(
                                  width: 8.r,
                                  height: 8.r,
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
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\$${walletController.totalBankBalance.toStringAsFixed(2)}',
                              style: AppTextStyles.headingLarge.copyWith(
                                color: AppColors.primarySup,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Action Buttons Row
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 8.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildHeaderActionButton(
                            onTap: () => Get.toNamed(AppNamed.topUpPage),
                            icon: AppImages.topupIcon,
                            label: AppStrings.topUp,
                            context: context,
                          ),
                          _buildHeaderActionButton(
                            onTap: () => Get.toNamed(AppNamed.walletsDashboard),
                            icon: AppImages.walletIcon,
                            label: AppStrings.wallet,
                            context: context,
                          ),
                          _buildHeaderActionButton(
                            onTap: () => Get.toNamed(AppNamed.scannerPage),
                            icon: AppImages.scanIcon,
                            label: AppStrings.qrScan,
                            context: context,
                          ),
                          _buildHeaderActionButton(
                            onTap: () => Get.toNamed(AppNamed.myQrPage),
                            icon: AppImages.myQrcodeIcon,
                            label: AppStrings.myQr,
                            context: context,
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
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required VoidCallback onTap,
    required String icon,
    required String label,
    required BuildContext context,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImageViewer(imagePath: icon, height: 24.h, width: 24.w),
            SizedBox(height: 8.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendAgainSection(BuildContext context) {
    final controller = Get.put(TransferController());

    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.sendAgain,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              child: Obx(() {
                final recipients = controller.recentRecipients;

                if (recipients.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noRecentTransfers,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recipients.length,
                  separatorBuilder: (context, index) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) {
                    final tx = recipients[index];
                    return GestureDetector(
                      onTap: () => controller.onContactSelected(tx),
                      child: _buildContactAvatar(
                        name: tx.recipientName ?? tx.recipientInfo ?? '?',
                        color: _getContactColor(index),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContactColor(int index) {
    final colors = [
      const Color(0xFFFFB74D),
      const Color(0xFF4FC3F7),
      const Color(0xFFE57373),
      const Color(0xFF81C784),
      const Color(0xFFBA68C8),
    ];
    return colors[index % colors.length];
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

  Widget _buildPaymentListSection(BuildContext context) {
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

    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.paymentList,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            // SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 11.h,
                childAspectRatio: 0.85,
              ),
              itemCount: paymentItems.length,
              itemBuilder: (context, index) {
                final item = paymentItems[index];
                return GestureDetector(
                  onTap: () {
                    final billController = Get.put(UtilityBillController());
                    billController.setCategory(item['label'] as String);
                    Get.toNamed(AppNamed.utilityBills);
                  },
                  child: _buildPaymentItem(
                    icon: item['icon'] as String,
                    label: item['label'] as String,
                    context: context,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem({
    required String icon,
    required String label,
    required BuildContext context,
  }) {
    return Column(
      children: [
        AppImageViewer(imagePath: icon, height: 53.h, width: 53.w),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTradingHistorySection(BuildContext context) {
    final controller = Get.find<TransferController>();

    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.tradingHistory,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                const Spacer(),
                TextButton(
                  child: Text(AppStrings.viewAll),
                  onPressed: () {
                    Get.toNamed(AppNamed.allTransactions);
                  },
                ),
              ],
            ),

            Obx(() {
              if (controller.allTransactions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      AppStrings.noTransactions,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                );
              }

              // Show only top 5 recent transactions on home
              final recentTxs = controller.allTransactions.take(5).toList();

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTxs.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final tx = recentTxs[index];
                  return TradingHistoryItemWidget(
                    icon: _getTransactionIcon(tx),
                    title: tx.title,
                    status: tx.type == 'bill'
                        ? tx.recipientInfo ?? 'Bill'
                        : AppStrings.sent,
                    amount: tx.amount,
                    date: _formatDate(tx.createdAt),
                    isExpense: tx.isExpense,
                    onTap: () => Get.toNamed(AppNamed.shareBill),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getTransactionIcon(dynamic tx) {
    if (tx.type == 'bill') {
      final category = tx.recipientInfo;
      if (category == AppStrings.categoryElectricity) {
        return AppImages.electricityBadge;
      }
      if (category == AppStrings.categoryInternet) {
        return AppImages.internetBadge;
      }
      if (category == AppStrings.insurance) return AppImages.insuranceBadge;
      if (category == AppStrings.categoryMedical) return AppImages.medicalBadge;
      if (category == AppStrings.categoryMarket) return AppImages.marketBadge;
      if (category == AppStrings.electricBill) {
        return AppImages.electricBillBadge;
      }
      if (category == AppStrings.television) return AppImages.televisionBadge;
      if (category == AppStrings.waterBill) return AppImages.waterbillBadge;
      return AppImages.electricBillBadge;
    }
    if (tx.type == 'topup')
      return AppImages.topupIcon; // Need to ensure this exists or use fallback
    if (tx.type == 'withdraw') return AppImages.withdrawIcon;
    if (tx.type == 'transfer') return ''; // Empty to trigger letter-based icon
    return AppImages.electricBillBadge;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      return "${AppStrings.today} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    if (difference == 1) {
      return "${AppStrings.yesterday} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    }
    return "${date.day} ${_getMonthName(date.month)} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _showBalanceDetails(BuildContext context, WalletController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.myAccounts,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.savedBankAccounts.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Theme.of(context).dividerColor),
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
                      title: Text(
                        bankName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      trailing: Text(
                        "\$${balance.toString()}",
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(thickness: 1.5, color: Theme.of(context).dividerColor),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalBalance,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
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

import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_colors.dart';
// import 'package:expense/core/theme/app_text_styles.dart'; // Unused
import 'package:expense/features/analytics/widgets/trading_history_item_widget.dart';
import 'package:expense/features/transfer/controllers/transfer_controller.dart';
import 'package:expense/features/transfer/widgets/transfer_widgets.dart';
import 'package:expense/routes/app_named.dart';
import 'package:intl/intl.dart';

class TransferPage extends GetView<TransferController> {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppStrings.transferTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            ActionTile(
              title: AppStrings.transferByWallet,
              icon: AppImages.walletinactive,
              onTap: controller.onTransferByWallet,
              iconColor: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 8),
            ActionTile(
              title: AppStrings.transferByBank,
              icon: AppImages.bankIcon,
              onTap: controller.onTransferByBank,
              iconColor: Theme.of(context).iconTheme.color,
            ),

            const SizedBox(height: 8),

            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: SectionTitle(
                      title: AppStrings.recentTransfer,
                      onViewAll: () => Get.toNamed(AppNamed.recentTransfers),
                    ),
                  ),
                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.transactions.length > 4
                          ? 4
                          : controller.transactions.length,
                      itemBuilder: (context, index) {
                        final tx = controller.transactions[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TradingHistoryItemWidget(
                            icon: '', // Fallback to initial logic in widget
                            title: tx.title,
                            status: tx.displayStatus,
                            amount: tx.amount,
                            date: DateFormat(
                              'MMM d, h:mm a',
                            ).format(tx.createdAt),
                            isExpense: tx.isExpense,
                            onTap: () => controller.onContactSelected(tx),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: AppColors.dropSection.withOpacity(0.1),
                          thickness: 1,
                          indent: 16.w,
                          endIndent: 16.w,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: SectionTitle(
                      title: AppStrings.friends,
                      onViewAll: () => Get.toNamed(AppNamed.friends),
                    ),
                  ),

                  Obx(() {
                    final displayFriends = controller.randomFriends;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayFriends.length,
                      itemBuilder: (context, index) {
                        final contact = displayFriends[index];
                        return ContactTile(
                          name: contact.name,
                          phone: contact.phone,
                          avatarUrl: contact.imageUrl,
                          onTap: () => controller.onContactSelected(contact),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: AppColors.dropSection,
                          thickness: 2,
                          indent: 16.w,
                          endIndent: 16.w,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

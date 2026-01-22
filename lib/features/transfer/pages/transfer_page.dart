import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/transfer/controllers/transfer_controller.dart';
import 'package:expense/features/transfer/widgets/transfer_widgets.dart';

class TransferPage extends GetView<TransferController> {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Transfer', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            ActionTile(
              title: 'Transfer by Avipay wallet',
              icon: Icons.account_balance_wallet_outlined,
              onTap: controller.onTransferByWallet,
            ),
            const SizedBox(height: 8),
            ActionTile(
              title: 'Transfer by Bank',
              icon: Icons.account_balance_outlined,
              onTap: controller.onTransferByBank,
            ),

            const SizedBox(height: 8),

            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: SectionTitle(title: 'Recent Transfer'),
                  ),
                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recentContacts.length,
                      itemBuilder: (context, index) {
                        final contact = controller.recentContacts[index];
                        return ContactTile(
                          name: contact.name,
                          phone: contact.phone,
                          avatarUrl: contact.avatarUrl,
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: SectionTitle(title: 'Friends'),
                  ),

                  Obx(
                    () => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.friends.length,
                      itemBuilder: (context, index) {
                        final contact = controller.friends[index];
                        return ContactTile(
                          name: contact.name,
                          phone: contact.phone,
                          avatarUrl: contact.avatarUrl,
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
}

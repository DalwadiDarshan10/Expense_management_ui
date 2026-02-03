import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_colors.dart';
// import 'package:expense/core/theme/app_text_styles.dart'; // Unused
import 'package:expense/features/transfer/controllers/transfer_controller.dart';
import 'package:expense/features/transfer/widgets/transfer_widgets.dart';

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
                    child: SectionTitle(title: AppStrings.recentTransfer),
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
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: SectionTitle(title: AppStrings.friends),
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

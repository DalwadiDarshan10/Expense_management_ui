import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/withdraw/controllers/withdraw_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:expense/widgets/app_swipe_button.dart';
import 'package:expense/widgets/labeled_input_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithdrawPage extends GetView<WithdrawController> {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.withdrawTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            // Withdraw To Section
            _buildWithdrawToSection(context),

            SizedBox(height: 8.h),

            // Denominations Section
            Container(
              color: Theme.of(context).cardColor,
              child: _buildDenominationsSection(context),
            ),

            SizedBox(height: 8.h),

            // Cash Section
            _buildCashSection(),

            SizedBox(height: 40.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: AppSwipeButton(
                text: AppStrings.swipeToWithdraw,
                onAction: () async {
                  controller.performWithdraw();
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWithdrawToSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          final details = controller.primaryBankDetails;
          return ListTile(
            title: Text(
              details['name']!,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            subtitle: Text(
              details['number']!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              controller.changeBank();
            },
          );
        }),
      ),
    );
  }

  Widget _buildDenominationsSection(BuildContext context) {
    final List<int> denominations = [50, 100, 200, 500, 1000, 2000];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.denominations,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.5,
            ),
            itemCount: denominations.length,
            itemBuilder: (context, index) {
              final amount = denominations[index];
              return Obx(() {
                final isSelected =
                    controller.selectedDenomination.value == amount;

                return GestureDetector(
                  onTap: () => controller.selectDenomination(amount),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '\$$amount',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCashSection() {
    return LabeledInputTile(
      title: AppStrings.cashLabel,
      controller: controller.customAmountController,
      keyboardType: TextInputType.number,
      hintText: AppStrings.enterAmountHint,
      prefix: Text("\$ "),

      onChanged: (val) {
        if (int.tryParse(val) != controller.selectedDenomination.value) {
          controller.selectedDenomination.value = 0;
        }
      },
      trailingWidget: Row(
        children: [
          Text(
            '(Surplus: ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Obx(
            () => Text(
              '\$ ${controller.walletBalance.value.toStringAsFixed(2)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            ')',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

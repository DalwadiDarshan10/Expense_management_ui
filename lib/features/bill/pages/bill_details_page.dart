import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/bill/controller/utility_bill_controller.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:expense/widgets/app_image_viewer.dart';
import 'package:expense/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BillDetailsPage extends GetView<UtilityBillController> {
  const BillDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
            size: 20.r,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.selectedProvider.value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Source Selection (Tap Bar style)
            _buildSourceSelectionSection(context),

            SizedBox(height: 8.h),

            // Bank Selection (Visible if Bank selected)
            Obx(
              () => !controller.isWalletSelected.value
                  ? _buildBankSelectionSection(context)
                  : const SizedBox.shrink(),
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Period",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: "Month",
                          value: controller.selectedMonth,
                          items: controller.months,
                          context: context,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildDropdown(
                          label: "Year",
                          value: controller.selectedYear,
                          items: controller.years,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      Obx(
                        () => Text(
                          "(Balance: \$${controller.currentBalance.toStringAsFixed(2)})",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    hint: "Enter amount",
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      controller.amount.value = double.tryParse(val) ?? 0.0;
                    },
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Description",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  AppTextField(
                    hint: "Write details here...",
                    maxLines: 3,
                    onChanged: (val) => controller.description.value = val,
                  ),
                  SizedBox(height: 40.h),
                  Obx(
                    () => AppButton(
                      text: "PAY NOW",
                      isLoading: controller.isLoading.value,
                      onPressed: () => controller.payBill(),
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

  Widget _buildSourceSelectionSection(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Source",
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleSmall?.color,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSourceTab(
                      label: "Wallet",
                      isSelected: controller.isWalletSelected.value,
                      onTap: () => controller.isWalletSelected.value = true,
                      context: context,
                    ),
                  ),
                  Expanded(
                    child: _buildSourceTab(
                      label: "Bank",
                      isSelected: !controller.isWalletSelected.value,
                      onTap: () => controller.isWalletSelected.value = false,
                      context: context,
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

  Widget _buildSourceTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }

  Widget _buildBankSelectionSection(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(20.w),
      child: Obx(() {
        final bank = controller.selectedBank;
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              AppImageViewer(
                imagePath: AppImages.appLogoSquare,
                width: 48.w,
                height: 48.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank?['bankName'] ?? "Select Bank",
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleSmall?.color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Balance: \$${bank?['balance'] ?? '0.00'}",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.changeBank(),
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.secondaryText,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value,
                isExpanded: true,
                dropdownColor: Theme.of(context).cardColor,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    value.value = newValue;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

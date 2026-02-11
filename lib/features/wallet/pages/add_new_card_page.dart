import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/wallet/widgets/credit_card_widget.dart';
import 'package:expense/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddNewCardPage extends GetView<WalletController> {
  const AddNewCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dropdown list for Bank Name setup
    final List<String> bankNames = [
      "State Bank Of India",
      "HDFC Bank",
      "ICICI Bank",
      "Axis Bank",
      "Kotak Mahindra Bank",
      "Bank Of Baroda",
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.editingCardId.value != null
                ? 'Edit Card'
                : AppStrings.addNewCardTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              controller.currentCard.value; // Observation trigger
              return _buildTextField(
                context,
                label: AppStrings.cardNumberLabel,
                hint: AppStrings.cardNumberHint,
                controller: controller.cardNumberController,
                keyboardType: TextInputType.number,
                errorText: controller.cardNumberError.value,
                readOnly:
                    controller.editingCardId.value !=
                    null, // Read-only if editing
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
              );
            }),
            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 8.h,
            ),

            Obx(() {
              controller.currentCard.value; // Observation trigger
              return _buildTextField(
                context,
                label: AppStrings.expiredLabel,
                hint: AppStrings.expiredHint,
                controller: controller.expiryDateController,
                keyboardType: TextInputType.datetime,
                errorText: controller.expiryDateError.value,
                readOnly: true,
                onTap: () => _selectExpiryDate(context),
              );
            }),
            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 8.h,
            ),

            // Bank Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.bankLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Obx(() {
                    controller.currentCard.value; // Observation trigger
                    return DropdownButtonFormField<String>(
                      dropdownColor: Theme.of(context).cardColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 12.h,
                        ),
                        errorText: controller.bankNameError.value,
                        errorStyle: AppTextStyles.bodySmall.copyWith(
                          color: Colors.red,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        // Disable decoration appearance if editing
                        enabled: controller.editingCardId.value == null,
                      ),
                      initialValue:
                          controller.bankNameController.text.isNotEmpty
                          // Check if value actually exists in dropdown list to avoid error
                          ? (bankNames.contains(
                                  controller.bankNameController.text,
                                )
                                ? controller.bankNameController.text
                                : null)
                          : null,
                      hint: Text(
                        AppStrings.selectBank,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondaryText.withValues(alpha: 0.5),
                        ),
                      ),
                      items: bankNames.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: controller.editingCardId.value != null
                          ? null // Disable interaction if editing
                          : (val) {
                              if (val != null) {
                                controller.bankNameController.text =
                                    val; // Manually update the controller or use a dedicated one
                                controller.currentCard.update((card) {
                                  card?.bankName = val;
                                });
                                // Clear error when value is selected
                                if (controller.bankNameError.value != null) {
                                  controller.bankNameError.value = null;
                                }
                              }
                            },
                    );
                  }),
                ],
              ),
            ),

            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 8.h,
            ),
            Obx(() {
              controller.currentCard.value; // Observation trigger
              return _buildTextField(
                context,
                label: AppStrings.cardHolderNameLabel,
                hint: AppStrings.cardHolderNameHint,
                controller: controller.cardHolderNameController,
                errorText: controller.cardHolderNameError.value,
              );
            }),
            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 8.h,
            ),
            // Result (Live Preview)
            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.resultLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () =>
                          CreditCardWidget(card: controller.currentCard.value),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 24.h,
            ),

            // Add Card Button
            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : AppButton(
                          text: controller.editingCardId.value != null
                              ? 'Update Card'
                              : AppStrings.btnAddNewCard,
                          onPressed: controller.addNewCard,
                        ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month);
    final DateTime lastDate = DateTime(now.year + 20, 12);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      final String formatted =
          "${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().substring(2)}";
      controller.expiryDateController.text = formatted;
    }
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),

          TextField(
            onTap: onTap,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            style: AppTextStyles.titleMedium.copyWith(
              color: readOnly
                  ? Theme.of(context).textTheme.bodyLarge?.color
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryText.withValues(alpha: 0.5),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.bodySmall.copyWith(color: Colors.red),
              filled: true,
              fillColor: readOnly
                  ? Theme.of(context).cardColor
                  : Theme.of(context).cardColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 12.h,
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String enteredData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < enteredData.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(enteredData[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}

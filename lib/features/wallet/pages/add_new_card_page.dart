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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.editingCardId.value != null
                ? 'Edit Card'
                : AppStrings.addNewCardTitle,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 24.h),
            // Form Fields
            Obx(
              () => _buildTextField(
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
              ),
            ),
            Container(color: AppColors.background, height: 8.h),

            Obx(
              () => _buildTextField(
                label: AppStrings.expiredLabel,
                hint: AppStrings.expiredHint,
                controller: controller.expiryDateController,
                keyboardType: TextInputType.number,
                errorText: controller.expiryDateError.value,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateFormatter(),
                ],
              ),
            ),
            Container(color: AppColors.background, height: 8.h),
            // Bank Dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.bankLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
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
                      value: controller.bankNameController.text.isNotEmpty
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
                          child: Text(value),
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
                    ),
                  ),
                ],
              ),
            ),

            Container(color: AppColors.background, height: 8.h),
            Obx(
              () => _buildTextField(
                label: AppStrings.cardHolderNameLabel,
                hint: AppStrings.cardHolderNameHint,
                controller: controller.cardHolderNameController,
                errorText: controller.cardHolderNameError.value,
              ),
            ),
            Container(color: AppColors.background, height: 8.h),
            // Result (Live Preview)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.resultLabel,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(
                    () => CreditCardWidget(card: controller.currentCard.value),
                  ),
                ],
              ),
            ),

            Container(color: AppColors.background, height: 24.h),

            // Add Card Button
            Container(
              color: AppColors.background,

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                  () => AppButton(
                    text: controller.editingCardId.value != null
                        ? 'Update Card'
                        : AppStrings.btnAddNewCard,
                    onPressed: controller.addNewCard,
                  ),
                ),
              ),
            ),
            Container(color: AppColors.background, height: 24.h),
            Container(color: AppColors.background, child: Spacer()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    bool readOnly = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),

          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            style: AppTextStyles.titleMedium.copyWith(
              color: readOnly ? Colors.grey : AppColors.primaryText,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.secondaryText.withValues(alpha: 0.5),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.bodySmall.copyWith(color: Colors.red),
              filled: true,
              fillColor: readOnly ? Colors.grey.shade200 : AppColors.white,
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

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

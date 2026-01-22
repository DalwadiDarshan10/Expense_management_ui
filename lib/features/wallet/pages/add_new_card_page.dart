import 'package:expense/core/theme/app_colors.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/wallet/widgets/credit_card_widget.dart';
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
      'CBB BANK',
      'AVI BANK',
      'My Bank',
      'Citi Bank',
      'Chase',
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
        title: Text(
          'Add New Card',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            // Form Fields
            Obx(
              () => _buildTextField(
                label: 'Card Number',
                hint: '1234 4567 8901 2345',
                controller: controller.cardNumberController,
                keyboardType: TextInputType.number,
                errorText: controller.cardNumberError.value,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => _buildTextField(
                label: 'Expired',
                hint: '12/24',
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
            SizedBox(height: 16.h),
            // Bank Dropdown
            Text(
              "Bank",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 8.h),
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
                ),
                hint: Text(
                  "Select Bank",
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
                onChanged: (val) {
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
            SizedBox(height: 16.h),
            Obx(
              () => _buildTextField(
                label: 'Card Holder Name',
                hint: 'Melvin Guerrero',
                controller: controller.cardHolderNameController,
                errorText: controller.cardHolderNameError.value,
              ),
            ),
            SizedBox(height: 40.h),
            // Result (Live Preview)
            Text(
              'Result',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Obx(() => CreditCardWidget(card: controller.currentCard.value)),

            SizedBox(height: 24.h),

            // Add Card Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: controller.addNewCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Add New Card',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          style: AppTextStyles.titleMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.secondaryText.withValues(alpha: 0.5),
            ),
            errorText: errorText,
            errorStyle: AppTextStyles.bodySmall.copyWith(color: Colors.red),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12.h),
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

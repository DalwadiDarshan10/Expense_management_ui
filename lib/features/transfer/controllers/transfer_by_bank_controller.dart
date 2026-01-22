import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense/core/theme/app_colors.dart';

class TransferByBankController extends GetxController {
  final amountController = TextEditingController();
  final accountController = TextEditingController();
  final contentController = TextEditingController();

  final selectedBank = RxnString();
  final isValid = false.obs;

  final double balance = 12769.00;

  final banks = ['AVI Bank', 'Chase Bank', 'Citi Bank', 'Bank of America'];

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(_validate);
    accountController.addListener(_validate);
    // Default bank selection
    selectedBank.value = banks[0];
  }

  @override
  void onClose() {
    amountController.dispose();
    accountController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void _validate() {
    final amountText = amountController.text;
    final amount = double.tryParse(amountText.replaceAll(',', ''));

    bool amountValid = amount != null && amount > 0 && amount <= balance;
    bool accountValid = accountController.text.isNotEmpty;
    bool bankValid = selectedBank.value != null;

    isValid.value = amountValid && accountValid && bankValid;
  }

  void onBankSelected(String? bank) {
    selectedBank.value = bank;
    _validate();
  }

  void onTransfer() {
    if (!isValid.value) return;

    Get.snackbar(
      'Success',
      'Transfer of \$${amountController.text} to account ${accountController.text} successful!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
    );
  }
}

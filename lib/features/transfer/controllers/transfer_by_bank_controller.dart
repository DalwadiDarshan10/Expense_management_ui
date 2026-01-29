import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferByBankController extends GetxController {
  final amountController = TextEditingController();
  final accountController = TextEditingController();
  final contentController = TextEditingController();

  final selectedBank = RxnString();
  final isValid = false.obs;

  final amountError = RxnString();
  final accountError = RxnString();

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
    // Simplified validation: simple isNotEmpty checks
    bool amountValid = amountText.isNotEmpty;

    if (!amountValid) {
      // If amount is not valid (i.e., empty)
      amountError.value = null;
    } else {
      final amount = double.tryParse(amountText.replaceAll(',', ''));
      if (amount == null) {
        amountError.value = "Invalid number";
        amountValid = false; // Mark as invalid if it's not a number
      } else if (amount <= 0) {
        amountError.value = "Amount must be positive";
        amountValid = false; // Mark as invalid if not positive
      } else {
        amountError.value = null;
      }
    }

    bool accountValid = accountController.text.isNotEmpty;
    if (accountValid) accountError.value = null;

    bool bankValid = selectedBank.value != null;

    isValid.value = amountValid && accountValid && bankValid;
  }

  void onBankSelected(String? bank) {
    selectedBank.value = bank;
    _validate();
  }

  void onTransfer() {
    // Explicit final check before transfer
    bool isAmountEmpty = amountController.text.isEmpty;
    bool isAccountEmpty = accountController.text.isEmpty;

    if (isAmountEmpty || isAccountEmpty || selectedBank.value == null) {
      if (isAccountEmpty) {
        accountError.value = "Account required";
      }
      if (isAmountEmpty) {
        amountError.value = "Amount required";
      }

      Get.snackbar(
        "Invalid Input",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final amountText = amountController.text;
    final amount = double.tryParse(amountText.replaceAll(',', ''));
    if (amount == null) {
      amountError.value = "Invalid number";
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid number for amount",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (amount <= 0) {
      amountError.value = "Amount must be positive";
      Get.snackbar(
        "Invalid Input",
        "Amount must be positive",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      AppNamed.transactionSuccess,
      arguments: TransactionSuccessArgs(
        type: TransactionType.transfer,
        amount: amountController.text,
        recipientName: selectedBank.value ?? "Unknown Bank",
        recipientInfo: accountController.text,
      ),
    );
  }
}

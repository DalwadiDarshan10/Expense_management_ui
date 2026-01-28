import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawController extends GetxController {
  final customAmountController = TextEditingController();
  final selectedDenomination = 0.obs;

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }

  void selectDenomination(int amount) {
    if (selectedDenomination.value == amount) {
      selectedDenomination.value = 0;
      customAmountController.clear();
    } else {
      selectedDenomination.value = amount;
      customAmountController.text = amount.toString();
    }
  }

  void performWithdraw() {
    final amount = customAmountController.text;
    if (amount.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount');
      return;
    }
    // Implement actual withdraw logic here
    Get.toNamed(
      AppNamed.transactionSuccess,
      arguments: TransactionSuccessArgs(
        type: TransactionType.withdraw,
        amount: amount,
        recipientName: "AVI Bank",
        recipientInfo: "123456 *** 789",
      ),
    );
    // Get.back();
  }
}

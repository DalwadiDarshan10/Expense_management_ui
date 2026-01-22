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
    Get.snackbar('Success', 'Withdraw of \$$amount initiated');
    // Navigate back or reset
    // Get.back();
  }
}

import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/wallet/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpController extends GetxController {
  // Dependency on WalletController to get saved cards
  // We can find it because it should be alive in the app, or we can fetch it.
  // Ideally, WalletController handles card data. TopUpController handles TopUp logic.
  final WalletController _walletController = Get.find<WalletController>();

  List<CardModel> get savedCards => _walletController.savedCards;

  // Top-up related state
  final RxInt selectedDenomination = 50.obs;
  final TextEditingController customAmountController = TextEditingController();
  final RxInt selectedCardIndex = 0.obs;

  void selectDenomination(int amount) {
    selectedDenomination.value = amount;
    customAmountController.text = amount.toString();
  }

  void performTopUp() {
    final amount = customAmountController.text.isNotEmpty
        ? int.tryParse(customAmountController.text) ??
              selectedDenomination.value
        : selectedDenomination.value;

    if (savedCards.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add a card first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Simulate top-up success
    Get.snackbar(
      'Success',
      'Top up of \$$amount completed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Reset the custom amount
    customAmountController.clear();
    selectedDenomination.value = 50;
  }

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }
}

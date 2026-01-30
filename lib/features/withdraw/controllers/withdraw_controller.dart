import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
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

  WalletController get _walletController => Get.find<WalletController>();

  RxInt get walletBalance => _walletController.walletBalance;

  // Helper to get bank details
  // Returns a map with 'name' and 'number'
  Map<String, String> get primaryBankDetails {
    if (_walletController.savedBankAccounts.isEmpty) {
      return {"name": "No Bank Linked", "number": "----"};
    }

    final bank = _walletController.savedBankAccounts.first;
    final bankName = bank['bankName'] ?? "Unknown Bank";
    final linkedCardId = bank['linkedCardId'];

    String number = "**** **** **** ****";
    if (linkedCardId != null) {
      final card = _walletController.savedCards.firstWhereOrNull(
        (c) => c.cardId == linkedCardId,
      );
      if (card != null) {
        // Format: 1234 5678 9012 3456 -> **** 3456
        if (card.cardNumber.length >= 4) {
          number =
              "**** ${card.cardNumber.substring(card.cardNumber.length - 4)}";
        } else {
          number = card.cardNumber;
        }
      }
    }
    return {"name": bankName, "number": number};
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

  Future<void> performWithdraw() async {
    final amountText = customAmountController.text;
    if (amountText.isEmpty) {
      Get.snackbar('Error', 'Please enter an amount');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    try {
      final walletController = Get.find<WalletController>();
      if (walletController.savedBankAccounts.isEmpty) {
        Get.snackbar('Error', 'No bank account found to withdraw to');
        return;
      }

      // Default to first bank account for now
      final bankAccount = walletController.savedBankAccounts.first;
      final bankId = bankAccount['id'];
      final bankName = bankAccount['bankName'] ?? 'Bank';

      await walletController.withdraw(bankId: bankId, amount: amount);

      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.withdraw,
          amount: amount.toString(),
          recipientName: bankName,
          recipientInfo: "Linked Account",
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

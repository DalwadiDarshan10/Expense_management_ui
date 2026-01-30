import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/features/wallet/models/card_model.dart';
import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopUpController extends GetxController {
  // Dependency on WalletController to get saved cards
  // We can find it because it should be alive in the app, or we can fetch it.
  // Ideally, WalletController handles card data. TopUpController handles TopUp logic.
  WalletController get walletController => _walletController;
  final WalletController _walletController = Get.find<WalletController>();

  List<CardModel> get savedCards => walletController.savedCards;

  // Top-up related state
  final RxInt selectedDenomination = 50.obs;
  final TextEditingController customAmountController = TextEditingController();
  final RxInt selectedCardIndex = 0.obs;

  // Selected Bank Balance
  int get selectedBankBalance {
    if (walletController.savedCards.isEmpty) return 0;
    if (selectedCardIndex.value >= walletController.savedCards.length) {
      return 0;
    }

    final card = walletController.savedCards[selectedCardIndex.value];
    final bankAccount = walletController.getBankAccountForCard(card.cardId);

    return bankAccount != null ? (bankAccount['balance'] as int? ?? 0) : 0;
  }

  void selectDenomination(int amount) {
    selectedDenomination.value = amount;
    customAmountController.text = amount.toString();
  }

  Future<void> performTopUp() async {
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

    // Verify balance
    if (selectedBankBalance < amount) {
      Get.snackbar(
        'Error',
        'Insufficient bank balance',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final card = savedCards[selectedCardIndex.value];
    final bankAccount = walletController.getBankAccountForCard(card.cardId);

    if (bankAccount == null) {
      Get.snackbar(
        'Error',
        'Bank account not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await walletController.topUp(bankId: bankAccount['id'], amount: amount);

      // Navigate to Success Page
      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.topUp,
          amount: amount.toString(),
          recipientName: card.bankName,
          recipientInfo: "**** **** **** ${card.last4 ?? ''}",
        ),
      );

      // Reset the custom amount
      customAmountController.clear();
      selectedDenomination.value = 50;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeBank() {
    if (savedCards.isEmpty) return;

    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Select Bank'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedCards.length,
                itemBuilder: (context, index) {
                  final card = savedCards[index];
                  return ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(card.bankName),
                    subtitle: Text('**** ${card.last4}'),
                    onTap: () {
                      selectedCardIndex.value = index;
                      Get.back();
                    },
                    selected: index == selectedCardIndex.value,
                    trailing: index == selectedCardIndex.value
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }
}

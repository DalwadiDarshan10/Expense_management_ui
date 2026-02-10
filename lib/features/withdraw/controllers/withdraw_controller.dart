import 'package:expense/core/constants/app_strings.dart';
import 'package:expense/core/theme/app_text_styles.dart';
import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawController extends GetxController {
  final customAmountController = TextEditingController();
  final selectedDenomination = 0.obs;
  final selectedCardIndex = 0.obs;

  @override
  void onClose() {
    customAmountController.dispose();
    super.onClose();
  }

  WalletController get _walletController => Get.find<WalletController>();

  RxDouble get walletBalance => _walletController.walletBalance;

  // Helper to get bank details
  // Returns a map with 'name' and 'number'
  Map<String, String> get primaryBankDetails {
    if (_walletController.savedCards.isEmpty) {
      return {"name": "No Bank Linked", "number": "----"};
    }

    if (selectedCardIndex.value >= _walletController.savedCards.length) {
      return {"name": "Invalid Selection", "number": "----"};
    }

    final card = _walletController.savedCards[selectedCardIndex.value];
    final bankAccount = _walletController.getBankAccountForCard(card.cardId);

    final bankName = bankAccount?['bankName'] ?? "Unknown Bank";
    String number = "**** **** **** ****";
    if (card.last4 != null) {
      number = "**** **** **** **** ${card.last4}";
    } else if (card.cardNumber.length >= 4) {
      number =
          "**** **** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}";
    }

    return {"name": bankName, "number": number};
  }

  void changeBank() {
    if (_walletController.savedCards.isEmpty) return;

    Get.bottomSheet(
      Container(
        color: Theme.of(Get.context!).cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppStrings.selectBank),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: _walletController.savedCards.length,
                  itemBuilder: (context, index) {
                    final card = _walletController.savedCards[index];
                    return ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(
                        card.bankName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Text(
                        '**** **** **** **** ${card.last4 ?? (card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : '')}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
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
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
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
      Get.snackbar(AppStrings.errorTitle, 'Please enter an amount');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      Get.snackbar(AppStrings.errorTitle, 'Please enter a valid amount');
      return;
    }

    try {
      final walletController = Get.find<WalletController>();
      if (walletController.savedBankAccounts.isEmpty) {
        Get.snackbar('Error', 'No bank account found to withdraw to');
        return;
      }

      // Use selected bank account
      final card = walletController.savedCards[selectedCardIndex.value];
      final bankAccount = walletController.getBankAccountForCard(card.cardId);

      if (bankAccount == null) {
        Get.snackbar('Error', 'Bank account not found for selected card');
        return;
      }

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
        AppStrings.errorTitle,
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

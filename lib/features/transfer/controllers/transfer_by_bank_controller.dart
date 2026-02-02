import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferByBankController extends GetxController {
  final WalletController walletController = Get.find<WalletController>();

  final amountController = TextEditingController();
  final accountController = TextEditingController(); // Recipient Account Number
  final contentController = TextEditingController();

  // Selected SOURCE Bank
  final Rxn<Map<String, dynamic>> selectedSourceBank =
      Rxn<Map<String, dynamic>>();

  // Selected RECIPIENT Bank Name (Dropdown)
  final RxnString selectedRecipientBank = RxnString();

  final isValid = false.obs;

  final amountError = RxnString();
  final accountError = RxnString();

  // Hardcoded recipient banks list (for the dropdown)
  final recipientBanks = [
    'AVI Bank',
    'Chase Bank',
    'Citi Bank',
    'Bank of America',
    'Wells Fargo',
  ];

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(_validate);
    accountController.addListener(_validate);

    // Auto-select first available source bank
    if (walletController.savedBankAccounts.isNotEmpty) {
      selectedSourceBank.value = walletController.savedBankAccounts.first;
    }

    // Listen to bank accounts changes
    // Listen to bank accounts changes
    walletController.savedBankAccounts.listen((banks) {
      if (selectedSourceBank.value == null && banks.isNotEmpty) {
        selectedSourceBank.value = banks.first;
      }
    });

    // Default recipient bank selection (optional)
    selectedRecipientBank.value = recipientBanks[0];
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
    bool amountValid = amountText.isNotEmpty;

    if (!amountValid) {
      amountError.value = null;
    } else {
      final amount = double.tryParse(amountText.replaceAll(',', ''));
      if (amount == null) {
        amountError.value = "Invalid number";
        amountValid = false;
      } else if (amount <= 0) {
        amountError.value = "Amount must be positive";
        amountValid = false;
      } else {
        amountError.value = null;
      }
    }

    bool accountValid = accountController.text.isNotEmpty;
    if (accountValid) accountError.value = null;

    bool recipientBankValid = selectedRecipientBank.value != null;
    bool sourceBankValid = selectedSourceBank.value != null;

    isValid.value =
        amountValid && accountValid && recipientBankValid && sourceBankValid;
  }

  void onRecipientBankSelected(String? bank) {
    selectedRecipientBank.value = bank;
    _validate();
  }

  void onSourceBankSelected(Map<String, dynamic> bank) {
    selectedSourceBank.value = bank;
    _validate();
  }

  Future<void> onTransfer() async {
    // Reset errors first
    amountError.value = null;
    accountError.value = null;

    final amountText = amountController.text;
    final accountText = accountController.text;

    bool hasError = false;

    // 1. Validate Empty Fields
    if (amountText.isEmpty) {
      amountError.value = "Amount required";
      hasError = true;
    }
    if (accountText.isEmpty) {
      accountError.value = "Account required";
      hasError = true;
    }

    if (hasError) return;

    // 2. Validate Numbers & Logic
    final amount = double.tryParse(amountText.replaceAll(',', ''));
    if (amount == null) {
      amountError.value = "Invalid number";
      return;
    }

    // 3. Validate Balance
    if (selectedSourceBank.value != null) {
      final double currentBalance = (selectedSourceBank.value!['balance'] ?? 0)
          .toDouble();
      if (amount > currentBalance) {
        amountError.value = "Insufficient balance";
        return;
      }
    } else {
      // Should not happen if logic is correct, but safe check
      Get.snackbar("Error", "No source bank selected");
      return;
    }

    try {
      await walletController.transferFromBank(
        bankId: selectedSourceBank.value!['id'],
        amount: amount,
        // recipientName is not stored, but we pass it effectively to SuccessArgs
        recipientAccount: accountText,
        recipientBankName: selectedRecipientBank.value,
      );

      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.transfer,
          amount: amountController.text,
          recipientName: selectedRecipientBank.value ?? "Unknown Bank",
          recipientInfo: accountText,
        ),
      );
    } catch (e) {
      // Show error properly
      String msg = e.toString().replaceAll("Exception:", "").trim();
      if (msg.contains("Insufficient")) {
        amountError.value = msg;
      } else {
        Get.snackbar(
          "Transfer Failed",
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}

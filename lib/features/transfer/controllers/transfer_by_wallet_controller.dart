import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:expense/features/transfer/models/contact_model.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:flutter/material.dart'; // For Colors, SnackPosition

class TransferByWalletController extends GetxController {
  final WalletController walletController = Get.find<WalletController>();

  final amountController = TextEditingController();
  final contentController = TextEditingController();

  final selectedContact = Rxn<ContactModel>();
  final isValid = false.obs;
  final amountError = RxnString();

  // Use WalletController balance
  double get balance => walletController.walletBalance.value.toDouble();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ContactModel) {
      selectedContact.value = args;
    }

    // Listen to amount changes
    amountController.addListener(_validate);
  }

  // Keypad Logic
  void onNumberPress(String value) {
    if (amountController.text.contains('.') && value == '.') return;
    if (amountController.text.length > 8) return; // Prevent too long numbers

    // If text is "0" and we press a number (not .), replace 0
    if (amountController.text == "0" && value != ".") {
      amountController.text = value;
    } else {
      amountController.text += value;
    }
  }

  void onBackspace() {
    final text = amountController.text;
    if (text.isNotEmpty) {
      amountController.text = text.substring(0, text.length - 1);
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void _validate() {
    final amountText = amountController.text;
    bool amountValid = amountController.text.isNotEmpty;

    if (!amountValid && amountText.isNotEmpty) {
      amountError.value = null;
    } else {
      final amount = double.tryParse(amountText.replaceAll(',', ''));
      if (amount == null && amountText.isNotEmpty) {
        amountError.value = "Invalid number";
      } else if (amount != null && amount > balance) {
        amountError.value = "Insufficient funds";
        amountValid = false;
      } else {
        amountError.value = null;
      }
    }

    isValid.value = amountValid;
  }

  Future<void> onTransfer() async {
    // Reset error
    amountError.value = null;

    final amountText = amountController.text;

    if (amountText.isEmpty) {
      amountError.value = "Amount required";
      return;
    }

    final amount = double.tryParse(amountText.replaceAll(',', ''));
    if (amount == null) {
      amountError.value = "Invalid number";
      return;
    }

    if (amount > balance) {
      amountError.value = "Insufficient funds";
      return;
    }

    try {
      await walletController.transferFromWallet(
        amount: amount,
        // recipientName is not stored in Firestore schema anymore (optional parameter)
        // We pass it if we want, but schema doesn't require it.
        // We'll pass it as optional to verify interface consistency or omit it.
        // Based on signature: transferFromWallet({amount, recipientInfo, recipientName})
        recipientName: selectedContact.value?.name ?? "Direct Debit",
        recipientInfo: selectedContact.value?.phone ?? "Wallet Transfer",
      );

      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.transfer,
          amount: amountController.text,
          recipientName: selectedContact.value?.name ?? "My Wallet",
          recipientInfo: selectedContact.value?.phone ?? "Debit",
        ),
      );
    } catch (e) {
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

  final RxInt selectedGreetingIndex = (-1).obs;

  void selectGreetingCard(int index) {
    selectedGreetingIndex.value = selectedGreetingIndex.value == index
        ? -1
        : index;
  }

  final greetingCards = [
    AppImages.greetingCard1,
    AppImages.greetingCard2,
    AppImages.greetingCard3,
    AppImages.greetingCard1,
    AppImages.greetingCard1,
    AppImages.greetingCard2,
    AppImages.greetingCard3,
    AppImages.greetingCard1,
  ];
}

import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/routes/app_named.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:expense/features/transfer/models/contact_model.dart';
import 'package:expense/core/constants/app_images.dart';

class TransferByWalletController extends GetxController {
  final amountController = TextEditingController();
  final contentController = TextEditingController();

  final selectedContact = Rxn<ContactModel>();
  final isValid = false.obs;
  final amountError = RxnString();

  // Hardcoded balance for demo
  final double balance = 12769.00;

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

  @override
  void onClose() {
    amountController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void _validate() {
    final amountText = amountController.text;
    // Simplified: Check only if text is not empty.
    // If user inputs "0" or valid text, we consider it valid for "not empty" rule.
    bool amountValid = amountController.text.isNotEmpty;

    if (!amountValid && amountText.isNotEmpty) {
      // Just keep existing error logic if useful but don't block invalid logic on pure text empty check
      amountError.value = null;
    } else {
      // if we want to show invalid number error:
      final amount = double.tryParse(amountText.replaceAll(',', ''));
      if (amount == null && amountText.isNotEmpty) {
        amountError.value = "Invalid number";
      } else {
        amountError.value = null;
      }
    }

    // We still need a contact to transfer TO.
    isValid.value = amountValid && selectedContact.value != null;
  }

  void onTransfer() {
    bool isAmountEmpty = amountController.text.isEmpty;

    if (isAmountEmpty) {
      if (isAmountEmpty) {
        amountError.value = "Amount required";
      }

      Get.snackbar(
        "Invalid Input",
        "Please enter an amount",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      AppNamed.transactionSuccess,
      arguments: TransactionSuccessArgs(
        type: TransactionType.transfer,
        amount: amountController.text,
        recipientName: selectedContact.value?.name ?? "Unknown",
        recipientInfo: selectedContact.value?.phone ?? "",
      ),
    );
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

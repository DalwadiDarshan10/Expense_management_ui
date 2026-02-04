import 'package:expense/features/shared/pages/transaction_success_page.dart';
import 'package:expense/features/wallet/controllers/wallet_controller.dart';
import 'package:expense/routes/app_named.dart';
import 'package:get/get.dart';
import 'package:expense/features/friends/models/friend_model.dart';
import 'package:expense/features/wallet/models/transaction_model.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/features/transfer/controllers/transfer_controller.dart';
import 'package:flutter/material.dart';

class TransferByWalletController extends GetxController {
  final WalletController walletController = Get.find<WalletController>();

  final amountController = TextEditingController();
  final contentController = TextEditingController();
  final recipientController = TextEditingController(); // Manual recipient input

  final selectedContact = Rxn<FriendModel>();
  final isValid = false.obs;
  final amountError = RxnString();
  final recipientError = RxnString();

  // Use WalletController balance
  double get balance => walletController.walletBalance.value.toDouble();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is FriendModel) {
      selectedContact.value = args;
      recipientController.text = args.phone;
    } else if (args is TransactionModel) {
      // Try to find matching friend in TransferController
      final transferController = Get.find<TransferController>();
      final friend = transferController.friends.firstWhereOrNull(
        (f) =>
            f.phone == args.recipientInfo ||
            f.phone == args.recipientAccount ||
            f.name == args.recipientName,
      );

      if (friend != null) {
        selectedContact.value = friend;
        recipientController.text = friend.phone;
      } else {
        recipientController.text =
            args.recipientInfo ?? args.recipientAccount ?? "";
      }
    }

    // Listen to amount changes
    amountController.addListener(_validate);
    recipientController.addListener(_validate);
  }

  @override
  void onClose() {
    amountController.dispose();
    contentController.dispose();
    recipientController.dispose();
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

    bool recipientValid =
        recipientController.text.isNotEmpty || selectedContact.value != null;
    // Simple validation for recipient

    isValid.value = amountValid && recipientValid;
  }

  Future<void> pickContact() async {
    final result = await Get.toNamed(
      AppNamed.friends,
      arguments: {'isSelectionMode': true},
    );

    if (result is FriendModel) {
      selectedContact.value = result;
      recipientController.text = result.phone;
      _validate();
    }
  }

  Future<void> onTransfer() async {
    // Reset error
    amountError.value = null;
    recipientError.value = null;

    final amountText = amountController.text;
    final recipientText = selectedContact.value != null
        ? selectedContact.value!.phone
        : recipientController.text.trim();

    if (amountText.isEmpty) {
      amountError.value = "Amount required";
      return;
    }

    if (recipientText.isEmpty) {
      Get.snackbar("Error", "Recipient required");
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
        recipientInfo: recipientText,
        recipientName: selectedContact.value?.name ?? "Unknown",
      );

      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.transfer,
          amount: amountController.text,
          recipientName: selectedContact.value?.name ?? "Recipient",
          recipientInfo: recipientText,
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

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:expense/features/transfer/models/contact_model.dart';
import 'package:expense/core/theme/app_colors.dart'; // For snackbar colors if needed
import 'package:expense/core/constants/app_images.dart';

class TransferByWalletController extends GetxController {
  final amountController = TextEditingController();
  final contentController = TextEditingController();

  final selectedContact = Rxn<ContactModel>();
  final isValid = false.obs;

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
    final amount = double.tryParse(
      amountText.replaceAll(',', ''),
    ); // Simple parsing

    // Validate: Amount > 0 and User selected
    // Note: If no user selected, we might still allow input but disable button

    bool amountValid = amount != null && amount > 0 && amount <= balance;
    // For now, require contact to be selected?
    // If entered via "Transfer by Wallet" without contact, we might need a way to select one.
    // For simplicity, we assume contact is either passed or we simulate selection.
    // Or we strictly require contact.

    isValid.value = amountValid && selectedContact.value != null;
  }

  void onTransfer() {
    if (!isValid.value) return;

    Get.snackbar(
      'Success',
      'Transfer of \$${amountController.text} to ${selectedContact.value?.name} successful!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
    );
    // Navigate back or to receipt
    // Get.offNamed(AppNamed.transferSuccess); // If we had one
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

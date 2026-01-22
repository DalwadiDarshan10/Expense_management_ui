import 'dart:math';

import 'package:expense/core/constants/app_images.dart';
import 'package:expense/features/wallet/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  // List of saved cards
  final RxList<CardModel> savedCards = <CardModel>[].obs;

  // Current card being added (for live preview)
  final Rx<CardModel> currentCard = CardModel.empty().obs;

  // Form controllers
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cardHolderNameController =
      TextEditingController();

  // Selected Color Index for UI
  final RxInt selectedColorIndex = 0.obs;

  // Error messages for validation
  final RxnString bankNameError = RxnString(null);
  final RxnString cardNumberError = RxnString(null);
  final RxnString expiryDateError = RxnString(null);
  final RxnString cardHolderNameError = RxnString(null);

  // Available card images
  final List<String> cardImages = [
    AppImages.greenBgCreditCard,
    AppImages.blueBgCreditCard,
    AppImages.yellowBgCreditCard,
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize with one default card as seen in the design "My Wallet"
    savedCards.add(
      CardModel(
        bankName: 'CBB BANK',
        cardNumber: '1234567812344200',
        expiryDate: '12/25',
        cardHolderName: 'Melvin Guerrero',
        cardImage: AppImages.blueBgCreditCard,
      ),
    );
    savedCards.add(
      CardModel(
        bankName: 'AVI BANK',
        cardNumber: '1234567812344200',
        expiryDate: '01/25',
        cardHolderName: 'Melvin Guerrero',
        cardImage: AppImages.greenBgCreditCard,
      ),
    );

    // Set default image for new card
    assignRandomCardImage();

    // Listen to text changes to update the live preview and clear errors
    bankNameController.addListener(() {
      currentCard.update((val) {
        val?.bankName = bankNameController.text;
      });
      if (bankNameError.value != null && bankNameController.text.isNotEmpty) {
        bankNameError.value = null;
      }
    });
    cardNumberController.addListener(() {
      currentCard.update((val) {
        val?.cardNumber = cardNumberController.text;
      });
      if (cardNumberError.value != null &&
          cardNumberController.text.isNotEmpty) {
        cardNumberError.value = null;
      }
    });
    expiryDateController.addListener(() {
      currentCard.update((val) {
        val?.expiryDate = expiryDateController.text;
      });
      if (expiryDateError.value != null &&
          expiryDateController.text.isNotEmpty) {
        expiryDateError.value = null;
      }
    });
    cardHolderNameController.addListener(() {
      currentCard.update((val) {
        val?.cardHolderName = cardHolderNameController.text;
      });
      if (cardHolderNameError.value != null &&
          cardHolderNameController.text.isNotEmpty) {
        cardHolderNameError.value = null;
      }
    });
  }

  void updateCardImage(int index) {
    selectedColorIndex.value = index;
    currentCard.update((val) {
      val?.cardImage = cardImages[index];
    });
  }

  void addNewCard() {
    if (validateForm()) {
      savedCards.add(
        CardModel(
          bankName: currentCard.value.bankName,
          cardNumber: currentCard.value.cardNumber,
          expiryDate: currentCard.value.expiryDate,
          cardHolderName: currentCard.value.cardHolderName,
          cardImage: currentCard.value.cardImage,
        ),
      );

      // Reset form and current card
      resetForm();
      Get.back(); // Go back to dashboard
      Get.snackbar(
        'Success',
        'Card added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  bool validateForm() {
    bool isValid = true;

    if (bankNameController.text.isEmpty) {
      bankNameError.value = "Please select a bank";
      isValid = false;
    } else {
      bankNameError.value = null;
    }

    if (cardNumberController.text.isEmpty) {
      cardNumberError.value = "Card Number is required";
      isValid = false;
    } else {
      cardNumberError.value = null;
    }

    if (expiryDateController.text.isEmpty) {
      expiryDateError.value = "Expiry Date is required";
      isValid = false;
    } else {
      expiryDateError.value = null;
    }

    if (cardHolderNameController.text.isEmpty) {
      cardHolderNameError.value = "Card Holder Name is required";
      isValid = false;
    } else {
      cardHolderNameError.value = null;
    }

    return isValid;
  }

  void resetForm() {
    bankNameController.clear();
    cardNumberController.clear();
    expiryDateController.clear();
    cardHolderNameController.clear();

    bankNameError.value = null;
    cardNumberError.value = null;
    expiryDateError.value = null;
    cardHolderNameError.value = null;

    selectedColorIndex.value = 0;
    currentCard.value = CardModel.empty();
    assignRandomCardImage();
  }

  void assignRandomCardImage() {
    final randomIndex = Random().nextInt(cardImages.length);
    currentCard.update((val) {
      val?.cardImage = cardImages[randomIndex];
    });
  }

  void removeCard(CardModel card) {
    savedCards.removeWhere(
      (c) =>
          c.bankName == card.bankName &&
          c.cardNumber == card.cardNumber &&
          c.expiryDate == card.expiryDate,
    );
  }

  @override
  void onClose() {
    bankNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cardHolderNameController.dispose();
    super.onClose();
  }
}

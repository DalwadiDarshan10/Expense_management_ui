import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/core/constants/app_images.dart';
import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/core/utils/app_logger.dart';
import 'package:expense/features/wallet/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class WalletController extends GetxController {
  // List of saved cards (Observed from Firestore)
  final RxList<CardModel> savedCards = <CardModel>[].obs;

  // Current card being added (for live preview in UI)
  final Rx<CardModel> currentCard = CardModel.empty().obs;

  // List of saved bank accounts (Observed from Firestore)
  // Maps bankId (or docId) to dynamic data: {balance: int, ...}
  final RxList<Map<String, dynamic>> savedBankAccounts =
      <Map<String, dynamic>>[].obs;

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

  final _uuid = const Uuid();

  // Wallet Balance
  final RxDouble walletBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    // START Firestore Logic
    fetchCards();
    fetchBankAccounts();
    ensureWalletExists();
    fetchWalletBalance();
    // END Firestore Logic

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
        // Also update last4 for preview logic if needed, though mostly visual
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

  /// Ensure wallet exists (balance = 0)
  Future<void> ensureWalletExists() async {
    try {
      final walletRef = FirestoreService.userDoc()
          .collection('wallet')
          .doc('main');

      final walletSnap = await walletRef.get();
      if (!walletSnap.exists) {
        AppLogger.info("Initializing wallet...");
        await walletRef.set({"balance": 0, "currency": "USD"});
        AppLogger.info("Wallet initialized with 0 balance.");
      }
    } catch (e, s) {
      AppLogger.error("Error ensuring wallet exists", e, s);
    }
  }

  /// FETCH WALLET BALANCE (REAL-TIME)
  void fetchWalletBalance() {
    try {
      final uid = FirestoreService.uid;
      final path = 'users/$uid/wallet/main';
      AppLogger.info("Listening to wallet balance at: $path");

      FirestoreService.userDoc()
          .collection('wallet')
          .doc('main')
          .snapshots()
          .listen(
            (snapshot) {
              if (snapshot.exists) {
                final data = snapshot.data();
                AppLogger.info("Snapshot found! Data: $data");
                walletBalance.value =
                    (data?['balance'] as num?)?.toDouble() ?? 0.0;
                AppLogger.info(
                  "Wallet balance updated: ${walletBalance.value}",
                );
              } else {
                AppLogger.warning("Snapshot DOES NOT exist at: $path");
                // Temporary Debug Snackbar
                Get.snackbar(
                  "Debug: No Wallet Found",
                  "Please Top Up to create wallet.\nPath: $path",
                  snackPosition: SnackPosition.TOP,
                  duration: const Duration(seconds: 10),
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            onError: (e) {
              AppLogger.error("Error in wallet balance stream", e);
              Get.snackbar("Error", "Stream Error: $e");
            },
          );
    } catch (e, s) {
      AppLogger.error("Error setting up wallet balance fetch", e, s);
    }
  }

  /// FETCH CARDS (REAL-TIME)
  void fetchCards() {
    try {
      AppLogger.info("Listening to cards collection...");
      FirestoreService.userDoc()
          .collection('cards')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              savedCards.value = snapshot.docs
                  .map((e) => CardModel.fromMap(e.data()))
                  .toList();
              AppLogger.info("Fetched ${savedCards.length} cards.");
            },
            onError: (e) {
              AppLogger.error("Error in card stream", e);
            },
          );
    } catch (e, s) {
      AppLogger.error("Error setting up card fetch", e, s);
    }
  }

  /// FETCH BANK ACCOUNTS (REAL-TIME)
  void fetchBankAccounts() {
    try {
      AppLogger.info("Listening to bankAccounts collection...");
      FirestoreService.userDoc()
          .collection('bankAccounts')
          .snapshots()
          .listen(
            (snapshot) {
              savedBankAccounts.value = snapshot.docs.map((e) {
                final data = e.data();
                data['id'] = e.id;
                return data;
              }).toList();
              AppLogger.info(
                "Fetched ${savedBankAccounts.length} bank accounts.",
              );
            },
            onError: (e) {
              AppLogger.error("Error in bank accounts stream", e);
            },
          );
    } catch (e, s) {
      AppLogger.error("Error setting up bank accounts fetch", e, s);
    }
  }

  /// COMPUTED: Total Bank Balance
  double get totalBankBalance {
    return savedBankAccounts.fold(0.0, (sum, bank) {
      final balance = bank['balance'];
      if (balance is int) return sum + balance;
      if (balance is double) return sum + balance;
      return sum;
    });
  }

  /// GET BANK ACCOUNT FOR CARD
  Map<String, dynamic>? getBankAccountForCard(String? cardId) {
    if (cardId == null) return null;
    // We look for a bank account that has 'linkedCardId' == cardId
    return savedBankAccounts.firstWhereOrNull(
      (element) => element['linkedCardId'] == cardId,
    );
  }

  /// TOP-UP: Bank ➜ Wallet
  Future<void> topUp({required String bankId, required num amount}) async {
    final userDoc = FirestoreService.userDoc();

    final walletRef = userDoc.collection('wallet').doc('main');
    final bankRef = userDoc.collection('bankAccounts').doc(bankId);
    final txnRef = userDoc.collection('transactions').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      /// READ CURRENT DATA
      final walletSnap = await transaction.get(walletRef);
      final bankSnap = await transaction.get(bankRef);

      if (!walletSnap.exists || !bankSnap.exists) {
        throw Exception("Wallet or Bank account not found");
      }

      final num walletBalance = walletSnap['balance'] ?? 0;
      final num bankBalance = bankSnap['balance'] ?? 0;

      /// VALIDATION
      if (amount <= 0) {
        throw Exception("Invalid top-up amount");
      }

      if (bankBalance < amount) {
        throw Exception("Insufficient bank balance");
      }

      /// UPDATE BANK (↓)
      transaction.update(bankRef, {"balance": bankBalance - amount});

      /// UPDATE WALLET (↑)
      transaction.update(walletRef, {"balance": walletBalance + amount});

      /// SAVE TRANSACTION
      transaction.set(txnRef, {
        "type": "topup",
        "amount": amount,
        "from": "bank",
        "to": "wallet",
        "status": "success",
        "createdAt": Timestamp.now(),
      });
    });
  }

  /// WITHDRAW: Wallet ➜ Bank
  Future<void> withdraw({required String bankId, required num amount}) async {
    final userDoc = FirestoreService.userDoc();

    final walletRef = userDoc.collection('wallet').doc('main');
    final bankRef = userDoc.collection('bankAccounts').doc(bankId);
    final txnRef = userDoc.collection('transactions').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      /// READ CURRENT DATA
      final walletSnap = await transaction.get(walletRef);
      final bankSnap = await transaction.get(bankRef);

      if (!walletSnap.exists || !bankSnap.exists) {
        throw Exception("Wallet or Bank account not found");
      }

      final num walletBalance = walletSnap['balance'];
      final num bankBalance = bankSnap['balance'];

      /// VALIDATION
      if (amount <= 0) {
        throw Exception("Invalid withdraw amount");
      }

      if (walletBalance < amount) {
        throw Exception("Insufficient wallet balance");
      }

      /// UPDATE WALLET (↓)
      transaction.update(walletRef, {"balance": walletBalance - amount});

      /// UPDATE BANK (↑)
      transaction.update(bankRef, {"balance": bankBalance + amount});

      /// SAVE TRANSACTION
      transaction.set(txnRef, {
        "type": "withdraw",
        "amount": amount,
        "from": "wallet",
        "to": "bank",
        "bankId": bankId,
        "status": "success",
        "createdAt": Timestamp.now(),
      });
    });
  }

  /// TRANSFER FROM BANK (P2P): My Bank ➜ Recipient
  /// TRANSFER FROM BANK (P2P): My Bank ➜ Recipient
  Future<void> transferFromBank({
    required String bankId,
    required double amount,
    required String recipientAccount,
    String? recipientBankName,
    String? recipientName, // Kept optional for UI/Logging but simplified schema
  }) async {
    final userDoc = FirestoreService.userDoc();
    final bankRef = userDoc.collection('bankAccounts').doc(bankId);
    final txnRef = userDoc.collection('transactions').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final bankSnap = await transaction.get(bankRef);
      if (!bankSnap.exists) throw Exception("Source Bank account not found");

      final num currentBalance = bankSnap['balance'] ?? 0;

      if (amount <= 0) throw Exception("Invalid amount");
      if (currentBalance < amount) throw Exception("Insufficient bank funds");

      // Deduct from My Bank
      transaction.update(bankRef, {"balance": currentBalance - amount});

      // Record Transaction
      transaction.set(txnRef, {
        "type": "transfer",
        "amount": amount,
        "from": "bank",
        "sourceBankId": bankId,
        "recipientAccount":
            recipientAccount, // Removed recipientName from storage
        "recipientBankName": recipientBankName,
        "status": "success",
        "createdAt": Timestamp.now(),
      });
    });
  }

  /// TRANSFER FROM WALLET (P2P): My Wallet ➜ Recipient
  /// TRANSFER FROM WALLET (P2P): My Wallet ➜ Recipient
  Future<void> transferFromWallet({
    required double amount,
    required String recipientInfo,
    String? recipientName,
  }) async {
    final userDoc = FirestoreService.userDoc();
    final walletRef = userDoc.collection('wallet').doc('main');
    final txnRef = userDoc.collection('transactions').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final walletSnap = await transaction.get(walletRef);
      if (!walletSnap.exists) throw Exception("Wallet not found");

      final num currentBalance = walletSnap['balance'] ?? 0;

      if (amount <= 0) throw Exception("Invalid amount");
      if (currentBalance < amount) throw Exception("Insufficient wallet funds");

      // Deduct from Wallet
      transaction.update(walletRef, {"balance": currentBalance - amount});

      // Record Transaction
      transaction.set(txnRef, {
        "type": "transfer",
        "amount": amount,
        "from": "wallet",
        "recipientInfo": recipientInfo, // Removed recipientName from storage
        "status": "success",
        "createdAt": Timestamp.now(),
      });
    });
  }

  /// ADD CARD + CREATE BANK ACCOUNT WITH $1000
  Future<void> addCard({
    required String bankName,
    required String cardType,
    required String cardNumber,
    required String expiry,
    required String cardHolderName,
  }) async {
    final cardId = _uuid.v4();
    final bankId = _uuid.v4();

    AppLogger.info("Attempting to add card: $bankName, Type: $cardType");
    final card = CardModel(
      cardId: cardId,
      bankName: bankName,
      cardType: cardType,
      cardNumber: cardNumber,
      expiryDate: expiry,
      cardHolderName: cardHolderName,
      cardImage: "", // Not saved
    );

    final userDoc = FirestoreService.userDoc();
    final cardData = card.toMap();

    AppLogger.debug("Card Data to save: $cardData");

    /// Save card
    await userDoc.collection('cards').doc(cardId).set(cardData);

    AppLogger.info("Card saved to Firestore: $cardId");

    /// Create bank account with $5000
    await userDoc.collection('bankAccounts').doc(bankId).set({
      "bankName": bankName,
      "linkedCardId": cardId,
      "balance": 5000,
      "createdAt": Timestamp.now(),
    });

    AppLogger.info("Bank account created: $bankId with \$5000");
  }

  void updateCardImage(int index) {
    selectedColorIndex.value = index;
    currentCard.update((val) {
      val?.cardImage = cardImages[index];
    });
  }

  // State for Edit Mode
  final RxnString editingCardId = RxnString(null);

  // Triggered by UI Button
  Future<void> addNewCard() async {
    if (validateForm()) {
      try {
        AppLogger.info("Attempting to save card from UI.");
        // Detect card type (simple logic or default)
        String cardType = "Debit"; // Default or logic

        if (editingCardId.value != null) {
          await updateCard(
            cardId: editingCardId.value!,
            bankName: bankNameController.text,
            cardType: cardType,
            cardNumber: cardNumberController.text,
            expiry: expiryDateController.text,
            cardHolderName: cardHolderNameController.text,
          );
        } else {
          await addCard(
            bankName: bankNameController.text,
            cardType: cardType,
            cardNumber: cardNumberController.text,
            expiry: expiryDateController.text,
            cardHolderName: cardHolderNameController.text,
          );
        }

        // Reset form and current card
        resetForm();
        Get.back(); // Go back to dashboard
        Get.snackbar(
          'Success',
          editingCardId.value != null
              ? 'Card updated'
              : 'Card added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e, s) {
        AppLogger.error("Failed to save card", e, s);
        Get.snackbar(
          'Error',
          'Failed to save card: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void populateForEdit(CardModel card) {
    // Fill controllers
    bankNameController.text = card.bankName;
    cardNumberController.text = card.cardNumber;
    expiryDateController.text = card.expiryDate;
    cardHolderNameController.text = card.cardHolderName;

    // Use a copy to avoid mutating the original object in the list
    currentCard.value = card.copyWith();
    editingCardId.value = card.cardId;

    // Clear errors
    bankNameError.value = null;
    cardNumberError.value = null;
    expiryDateError.value = null;
    cardHolderNameError.value = null;

    // Explicitly refresh since we updated multiple values
    currentCard.refresh();
  }

  Future<void> updateCard({
    required String cardId,
    required String bankName,
    required String cardType,
    required String cardNumber,
    required String expiry,
    required String cardHolderName,
  }) async {
    AppLogger.info("Updating card: $cardId");

    // If cardNumber is empty, we might want to keep old?
    // But our validator requires it. So user must have entered it.
    // If we only store last4, we just update last4.

    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    final last4 = cleanNumber.length >= 4
        ? cleanNumber.substring(cleanNumber.length - 4)
        : cleanNumber;

    final updateData = {
      "bankName": bankName,
      "cardType": cardType,
      "expiry": expiry,
      "cardHolderName": cardHolderName,
    };

    // Only update last4 if user entered a full number (validation ensures this if not empty)
    // If we relax validation for edit later, this needs check.
    // Currently validation requires 16 digits.
    updateData["last4"] = last4;

    await FirestoreService.userDoc()
        .collection('cards')
        .doc(cardId)
        .update(updateData);

    AppLogger.info("Card updated in Firestore");
  }

  bool validateForm() {
    bool isValid = true;

    if (bankNameController.text.isEmpty) {
      bankNameError.value = "Please select a bank";
      isValid = false;
    } else {
      bankNameError.value = null;
    }

    if (cardNumberController.text.isEmpty ||
        cardNumberController.text.length < 16) {
      cardNumberError.value = "Valid Card Number is required";
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

    // Card Holder Name is required by UI form, even if not saved
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

    editingCardId.value = null; // Exit edit mode
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

  Future<void> removeCard(CardModel card) async {
    // Delete from Firestore if it has an ID
    if (card.cardId != null && card.cardId!.isNotEmpty) {
      try {
        await FirestoreService.userDoc()
            .collection('cards')
            .doc(card.cardId)
            .delete();
        AppLogger.info("Card deleted: ${card.cardId}");
      } catch (e, s) {
        AppLogger.error("Error deleting card", e, s);
        Get.snackbar("Error", "Could not delete card");
      }
    }
    // No need to remove from savedCards manually as the stream will update
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

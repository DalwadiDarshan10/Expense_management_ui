import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/core/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final RxnString receiverUid = RxnString();
  final RxBool isFetchingRecipient = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is FriendModel) {
      selectedContact.value = args;
      recipientController.text = args.phone;
    } else if (args is TransactionModel) {
      // ... existing logic ...
      _handleTransactionModelArgs(args);
    } else if (args is Map && args.containsKey('receiverUid')) {
      receiverUid.value = args['receiverUid'];
      _fetchRecipientDetails(receiverUid.value!);
    }

    // Listen to amount changes
    amountController.addListener(_validate);
    recipientController.addListener(_validate);
  }

  void _handleTransactionModelArgs(TransactionModel args) {
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

  Future<void> _fetchRecipientDetails(String uid) async {
    isFetchingRecipient.value = true;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        selectedContact.value = FriendModel(
          id: uid,
          name: data['username'] ?? 'Unknown User',
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
        );
        recipientController.text = selectedContact.value!.phone;
      } else {
        Get.snackbar("Error", "User not found for UID: $uid");
      }
    } on FirebaseException catch (e) {
      debugPrint("Firebase Error [${e.code}]: ${e.message}");
      Get.snackbar("Firebase Error", "[${e.code}]: ${e.message}");
    } catch (e) {
      debugPrint("Error fetching recipient details for UID $uid: $e");
      Get.snackbar("Error", "Failed to fetch user details: $e");
    } finally {
      isFetchingRecipient.value = false;
      _validate();
    }
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

    if (amountValid) {
      final amount = double.tryParse(amountText.replaceAll(',', ''));
      if (amount == null) {
        amountError.value = "Invalid number";
        amountValid = false;
      } else if (amount <= 0) {
        amountError.value = "Amount must be greater than 0";
        amountValid = false;
      } else if (amount > balance) {
        amountError.value = "Insufficient funds";
        amountValid = false;
      } else {
        amountError.value = null;
      }
    }

    bool recipientValid =
        recipientController.text.isNotEmpty || selectedContact.value != null;

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
      receiverUid.value = null; // Clear if manual contact picked
      _validate();
    }
  }

  Future<void> onTransfer() async {
    // Reset error
    amountError.value = null;
    recipientError.value = null;

    final amountText = amountController.text;
    final amount = double.tryParse(amountText.replaceAll(',', ''));

    if (amount == null || amount <= 0) {
      amountError.value = "Invalid amount";
      return;
    }

    if (amount > balance) {
      amountError.value = "Insufficient funds";
      return;
    }

    final recipient = selectedContact.value;
    if (recipient == null) {
      Get.snackbar("Error", "Recipient required");
      return;
    }

    try {
      if (receiverUid.value != null) {
        await _secureTransfer(receiverUid.value!, amount);
      } else {
        // Fallback to existing logic if no UID (manual/friend transfer)
        await walletController.transferFromWallet(
          amount: amount,
          recipientInfo: recipient.phone,
          recipientName: recipient.name,
        );
      }

      Get.toNamed(
        AppNamed.transactionSuccess,
        arguments: TransactionSuccessArgs(
          type: TransactionType.transfer,
          amount: amountController.text,
          recipientName: recipient.name,
          recipientInfo: recipient.phone,
        ),
      );

      NotificationService.instance.showNotification(
        title: "Transfer Successful",
        body:
            "You have successfully transferred ${amountController.text} to ${recipient.name}",
      );
    } catch (e) {
      Get.snackbar("Transfer Failed", e.toString());
    }
  }

  Future<void> _secureTransfer(String rUid, double amount) async {
    final senderUid = FirebaseAuth.instance.currentUser!.uid;
    final senderWalletRef = FirebaseFirestore.instance
        .collection('users')
        .doc(senderUid)
        .collection('wallet')
        .doc('main');
    final receiverWalletRef = FirebaseFirestore.instance
        .collection('users')
        .doc(rUid)
        .collection('wallet')
        .doc('main');
    final receiverDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(rUid);
    final txnRef = FirebaseFirestore.instance.collection('transactions').doc();

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final senderWalletSnap = await transaction.get(senderWalletRef);
      final receiverWalletSnap = await transaction.get(receiverWalletRef);
      final receiverDocSnap = await transaction.get(receiverDocRef);

      if (!senderWalletSnap.exists) throw Exception("Sender wallet not found");
      if (!receiverWalletSnap.exists)
        throw Exception("Receiver wallet not found");

      final double sBalance =
          (senderWalletSnap.data()?['balance'] as num?)?.toDouble() ?? 0.0;
      final double rBalance =
          (receiverWalletSnap.data()?['balance'] as num?)?.toDouble() ?? 0.0;

      if (sBalance < amount) throw Exception("Insufficient balance");

      // Update balances
      transaction.update(senderWalletRef, {'balance': sBalance - amount});
      transaction.update(receiverWalletRef, {'balance': rBalance + amount});

      // Create transaction record
      transaction.set(txnRef, {
        'senderUid': senderUid,
        'receiverUid': rUid,
        'amount': amount,
        'status': 'success',
        'type': 'transfer',
        'from': 'wallet',
        'recipientInfo': receiverDocSnap.data()?['phone'] ?? '',
        'recipientName': receiverDocSnap.data()?['username'] ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
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

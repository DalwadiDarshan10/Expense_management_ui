import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/core/utils/app_logger.dart';
import 'package:expense/features/friends/models/friend_model.dart';
import 'package:expense/features/wallet/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:expense/routes/app_named.dart';

class TransferController extends GetxController {
  final transactions = <TransactionModel>[].obs; // Transfers only
  final allTransactions = <TransactionModel>[].obs; // All transaction types
  final friends = <FriendModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _listenToTransactions();
    _listenToFriends();
  }

  void _listenToTransactions() {
    try {
      AppLogger.info("Listening to transactions for transfer page...");
      FirestoreService.userDoc()
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final allTxs = snapshot.docs
                  .map((doc) => TransactionModel.fromMap(doc.id, doc.data()))
                  .toList();

              allTransactions.assignAll(allTxs);

              // Filter for transfers only in-memory
              final transferTxs = allTxs
                  .where((tx) => tx.type == 'transfer')
                  .toList();

              transactions.assignAll(transferTxs);
              AppLogger.info(
                "Fetched ${allTxs.length} total, filtered ${transactions.length} transfers.",
              );
            },
            onError: (error) {
              AppLogger.error("Error listening to transactions: $error");
            },
          );
    } catch (e) {
      AppLogger.error("Failed to setup transactions sync: $e");
    }
  }

  void _listenToFriends() {
    try {
      AppLogger.info("Listening to friends for transfer page...");
      FirestoreService.userDoc()
          .collection('friends')
          .snapshots()
          .listen(
            (snapshot) {
              friends.assignAll(
                snapshot.docs
                    .map((doc) => FriendModel.fromMap(doc.data()))
                    .toList(),
              );
              AppLogger.info("Fetched ${friends.length} friends.");
            },
            onError: (error) {
              AppLogger.error("Error listening to friends: $error");
            },
          );
    } catch (e) {
      AppLogger.error("Failed to setup friends sync: $e");
    }
  }

  void onTransferByWallet() {
    Get.toNamed(AppNamed.transferByWalletPage);
  }

  void onTransferByBank() {
    Get.toNamed(AppNamed.transferByBankPage);
  }

  void onContactSelected(dynamic contact) {
    Get.toNamed(AppNamed.transferByWalletPage, arguments: contact);
  }

  List<FriendModel> get randomFriends {
    final list = List<FriendModel>.from(friends);
    list.shuffle();
    return list.take(3).toList();
  }

  List<TransactionModel> get recentRecipients {
    final Map<String, TransactionModel> uniqueRecipients = {};
    // Only include transfers from wallet (friend transfers)
    final walletTransfers = transactions.where((tx) => tx.from == 'wallet');

    for (var tx in walletTransfers) {
      final key = tx.recipientInfo ?? tx.recipientName ?? tx.id;
      if (!uniqueRecipients.containsKey(key)) {
        uniqueRecipients[key] = tx;
      }
    }
    return uniqueRecipients.values.take(10).toList();
  }
}

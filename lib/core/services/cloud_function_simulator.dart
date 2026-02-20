import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense/core/services/firestore_service.dart'; // Unused
import 'package:expense/core/services/notification_service.dart';
import 'package:expense/core/utils/app_logger.dart';
// import 'package:get/get.dart'; // Unused

/// SIMULATOR: Mimics a Firebase Cloud Function environment.
/// In a real app, this logic would live in `functions/src/index.ts` (Node.js).
class CloudFunctionSimulator {
  static final CloudFunctionSimulator instance = CloudFunctionSimulator._();
  CloudFunctionSimulator._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Simulates `transferMoney` Cloud Function.
  /// Handles:
  /// 1. Validation
  /// 2. UID Lookup (if phone provided)
  /// 3. Atomic Transaction (Sender --, Receiver ++)
  /// 4. Transaction Recording
  /// 5. Notification Trigger
  Future<void> transferMoney({
    required String senderUid,
    required double amount,
    String? receiverUid,
    String? receiverPhone, // Alternative if UID unknown
    String? note,
  }) async {
    AppLogger.info("☁️ [Server Simulator] Processing Transfer...");

    if (amount <= 0) {
      throw Exception("Amount must be positive.");
    }
    if (senderUid == receiverUid) {
      throw Exception("Cannot transfer to self.");
    }

    try {
      final result = await _firestore.runTransaction((transaction) async {
        // 1. Resolve Receiver
        DocumentReference? receiverRef;
        Map<String, dynamic>? receiverData;
        String finalReceiverUid = '';

        if (receiverUid != null) {
          finalReceiverUid = receiverUid;
          receiverRef = _firestore.collection('users').doc(receiverUid);
          final snap = await transaction.get(receiverRef);
          if (!snap.exists) throw Exception("Receiver not found (UID).");
          receiverData = snap.data() as Map<String, dynamic>?;
        } else if (receiverPhone != null) {
          throw Exception(
            "Security: Transfer requires Receiver UID. Lookup should happen before 'Function' call.",
          );
        } else {
          throw Exception("Target required (UID or Phone).");
        }

        final senderWalletRef = _firestore
            .collection('users')
            .doc(senderUid)
            .collection('wallet')
            .doc('main');

        final receiverWalletRef = _firestore
            .collection('users')
            .doc(finalReceiverUid)
            .collection('wallet')
            .doc('main');

        final senderWalletSnap = await transaction.get(senderWalletRef);
        final receiverWalletSnap = await transaction.get(receiverWalletRef);

        // 2. Validate Wallets
        if (!senderWalletSnap.exists) {
          throw Exception("Sender wallet not found.");
        }
        if (!receiverWalletSnap.exists) {
          throw Exception("Receiver wallet not setup.");
        }

        final double senderBal =
            (senderWalletSnap.data()?['balance'] as num?)?.toDouble() ?? 0.0;
        final double receiverBal =
            (receiverWalletSnap.data()?['balance'] as num?)?.toDouble() ?? 0.0;

        // 3. Check Balance
        if (senderBal < amount) {
          throw Exception("Insufficient funds.");
        }

        // 4. Perform Updates
        final newSenderBal = senderBal - amount;
        final newReceiverBal = receiverBal + amount;

        transaction.update(senderWalletRef, {"balance": newSenderBal});
        transaction.update(receiverWalletRef, {"balance": newReceiverBal});

        // 5. Create Transaction Record
        final txnRef = _firestore.collection('transactions').doc();
        transaction.set(txnRef, {
          "type": "p2p_transfer",
          "amount": amount,
          "senderUid": senderUid,
          "receiverUid": finalReceiverUid,
          "receiverName": receiverData?['username'] ?? "Unknown",
          "receiverPhone": receiverData?['phone'] ?? "",
          "status": "success",
          "note": note ?? "",
          "createdAt": FieldValue.serverTimestamp(),
          // Legacy fields for UI compatibility if needed
          "from": "wallet",
          "to": "wallet",
        });

        AppLogger.info(
          "☁️ [Server] Transfer Configured: $senderBal -> $newSenderBal | $receiverBal -> $newReceiverBal",
        );

        // Return data for notifications
        return {
          "newSenderBal": newSenderBal,
          "newReceiverBal": newReceiverBal,
          "receiverData": receiverData,
          "finalReceiverUid": finalReceiverUid,
        };
      });

      AppLogger.info("☁️ [Server] Transaction Committed Successfully.");

      // 6. Trigger Notification (Side Effect)
      final newSenderBal = result["newSenderBal"] as double;
      final newReceiverBal = result["newReceiverBal"] as double;
      final receiverData = result["receiverData"] as Map<String, dynamic>?;
      final finalReceiverUid = result["finalReceiverUid"] as String;

      // Notify Sender (Current User)
      NotificationService.instance.showNotification(
        title: "Money Sent 💸",
        body:
            "Sent ₹$amount to ${receiverData?['username'] ?? 'User'}. Balance: ₹$newSenderBal",
        payload: {"type": "transfer_sent"},
      );

      AppLogger.info(
        "☁️ [Server] Sending FCM to Receiver ($finalReceiverUid): 'You received ₹$amount from Sender. Balance: ₹$newReceiverBal'",
      );

      // Notify Receiver (Simulation - Delayed)
      Future.delayed(const Duration(seconds: 2), () {
        NotificationService.instance.showNotification(
          title: "Money Received! 💰",
          body: "You received ₹$amount. New Balance: ₹$newReceiverBal",
          payload: {"type": "transfer_received"},
        );
      });
    } catch (e) {
      AppLogger.error("☁️ [Server] Transaction Failed", e);
      rethrow;
    }
  }
}

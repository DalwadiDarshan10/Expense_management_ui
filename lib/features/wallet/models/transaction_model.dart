import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TransactionModel {
  final String id;
  final String type; // 'transfer', 'topup', 'withdraw'
  final double amount;
  final String from; // 'bank', 'wallet'
  final String? to; // 'wallet', 'bank' (optional for transfers)
  final String? sourceBankId;
  final String? recipientAccount;
  final String? recipientName;
  final String? recipientBankName;
  final String? recipientInfo;
  final String status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.from,
    this.to,
    this.sourceBankId,
    this.recipientAccount,
    this.recipientName,
    this.recipientBankName,
    this.recipientInfo,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> map) {
    return TransactionModel(
      id: id,
      type: map['type'] ?? 'unknown',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      from: map['from'] ?? 'unknown',
      to: map['to'],
      sourceBankId: map['sourceBankId'],
      recipientAccount: map['recipientAccount'],
      recipientName: map['recipientName'],
      recipientBankName: map['recipientBankName'],
      recipientInfo: map['recipientInfo'],
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'from': from,
      'to': to,
      'sourceBankId': sourceBankId,
      'recipientAccount': recipientAccount,
      'recipientName': recipientName,
      'recipientBankName': recipientBankName,
      'recipientInfo': recipientInfo,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Helper getters for UI
  String get title {
    if (type == 'transfer') {
      return recipientName ?? recipientInfo ?? 'Transfer';
    }
    return type.capitalizeFirst ?? 'Transaction';
  }

  String get displayStatus {
    return status.capitalizeFirst ?? 'Status';
  }

  bool get isExpense {
    // In this app's context, topup is income to wallet, transfer/withdraw are expenses from their respective sources
    if (type == 'topup' && to == 'wallet') return false;
    return true;
  }
}

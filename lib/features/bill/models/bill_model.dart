import 'package:cloud_firestore/cloud_firestore.dart';

class BillModel {
  final String id;
  final String category; // Electricity, Internet, etc.
  final String companyName;
  final String month;
  final String year;
  final double amount;
  final String description;
  final String status; // 'paid', 'unpaid'
  final DateTime createdAt;
  final String? userId;

  BillModel({
    required this.id,
    required this.category,
    required this.companyName,
    required this.month,
    required this.year,
    required this.amount,
    required this.description,
    required this.status,
    required this.createdAt,
    this.userId,
  });

  factory BillModel.fromMap(String id, Map<String, dynamic> map) {
    return BillModel(
      id: id,
      category: map['category'] ?? '',
      companyName: map['companyName'] ?? '',
      month: map['month'] ?? '',
      year: map['year'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      status: map['status'] ?? 'paid',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'companyName': companyName,
      'month': month,
      'year': year,
      'amount': amount,
      'description': description,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }
}

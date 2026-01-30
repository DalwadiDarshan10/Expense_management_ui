import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:expense/core/constants/app_images.dart';

class CardModel {
  // UI Fields
  String bankName;
  String cardNumber; // Used for UI display/formatting
  String expiryDate; // Used for UI display
  String cardHolderName; // Used for UI display
  String cardImage; // Used for UI display

  // Firestore Fields
  String? cardId;
  String? cardType;
  String? last4;
  DateTime? createdAt;

  CardModel({
    required this.bankName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cardImage,
    this.cardId,
    this.cardType,
    this.last4,
    this.createdAt,
  });

  // Create an empty card for initialization
  factory CardModel.empty() {
    return CardModel(
      bankName: '',
      cardNumber: '',
      expiryDate: '',
      cardHolderName: '',
      cardImage: "", // Will get assigned a default image by controller
    );
  }

  // Define available images for random assignment on fetch
  static final List<String> _cardImages = [
    AppImages.greenBgCreditCard,
    AppImages.blueBgCreditCard,
    AppImages.yellowBgCreditCard,
  ];

  Map<String, dynamic> toMap() {
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');
    return {
      "cardId": cardId,
      "bankName": bankName,
      "cardType": cardType ?? "Debit", // Default if not set
      "last4": last4 ?? cleanNumber.substring(max(0, cleanNumber.length - 4)),
      "expiry": expiryDate,
      "cardHolderName": cardHolderName,
      "createdAt": createdAt ?? DateTime.now(),
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    // Assign a deterministic image based on cardId so it doesn't flicker
    final String cardId = map['cardId'] ?? '';
    final int hash = cardId.hashCode;
    final int index = hash.abs() % _cardImages.length;
    final deterministicImage = _cardImages[index];

    final last4 = map['last4'] ?? '';

    return CardModel(
      cardId: cardId,
      bankName: map['bankName'] ?? '',
      // Reconstruct a partial card number for UI or just use last4
      cardNumber: "**** **** **** $last4",
      expiryDate: map['expiry'] ?? '',
      cardHolderName: map['cardHolderName'] ?? 'CARD HOLDER',
      cardImage: deterministicImage,
      cardType: map['cardType'],
      last4: last4,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

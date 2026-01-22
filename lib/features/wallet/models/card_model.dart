class CardModel {
  String bankName;
  String cardNumber;
  String expiryDate;
  String cardHolderName;

  String cardImage; // Renamed from cardColor to cardImage

  CardModel({
    required this.bankName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,

    required this.cardImage,
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
}

class LuhnValidator {
  /// Validates a credit card number using the Luhn Algorithm.
  /// Returns `true` if valid, `false` otherwise.
  static bool validate(String cardNumber) {
    // 1. Remove non-digits
    String cleanNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    // 2. Basic length check (usually between 8 and 19 for major cards)
    if (cleanNumber.length < 16) return false;

    int sum = 0;
    bool isSecond = false;

    // 3. Iterate from right to left
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);

      if (isSecond) {
        digit = digit * 2;
        if (digit > 9) {
          digit = digit - 9;
        }
      }

      sum += digit;
      isSecond = !isSecond;
    }

    // 4. Check modulo 10
    return (sum % 10 == 0);
  }
}

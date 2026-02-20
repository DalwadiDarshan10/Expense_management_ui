import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // TODO: In production, fetch this from a secure remote config or user-specific key derivation.
  // NEVER hardcode keys in a real banking app. This is for demonstration of the mechanism.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = encrypt.IV.fromLength(16);

  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Encrypts plain text (e.g., card number)
  static String encryptCard(String plainText) {
    try {
      return _encrypter.encrypt(plainText, iv: _iv).base64;
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  /// Decrypts encrypted base64 string
  static String decryptCard(String encryptedBase64) {
    try {
      return _encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedBase64),
        iv: _iv,
      );
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }
}

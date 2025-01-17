import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final key = encrypt.Key.fromLength(32); // AES 256-bit key length
  static final iv = encrypt.IV.fromLength(16); // 16-byte initialization vector

  // Encrypt file data
  static Future<List<int>> encryptFile(File file) async {
    final bytes = await file.readAsBytes();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return encrypted.bytes;
  }

  // Decrypt file data
  static Future<List<int>> decryptFile(File file) async {
    final bytes = await file.readAsBytes();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(bytes), iv: iv);
    return decrypted;
  }
}

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  static const String _encryptionKey = 'BOC_SECRET_KEY_2025_32CHARS!!';

  // Encryption
  String encryptData(String data) {
    try {
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      return encrypter.encrypt(data, iv: iv).base64;
    } catch (e) {
      debugPrint('Encryption error: $e');
      return data;
    }
  }

  String decryptData(String encryptedData) {
    try {
      final key = encrypt.Key.fromUtf8(_encryptionKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      return encrypter.decrypt64(encryptedData, iv: iv);
    } catch (e) {
      debugPrint('Decryption error: $e');
      return encryptedData;
    }
  }

  // Password hashing
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Secure Storage
  Future<void> saveSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }

  // Biometric Authentication
  Future<bool> checkBiometricSupport() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Biometric check error: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Get biometrics error: $e');
      return [];
    }
  }

  Future<bool> authenticateWithBiometric({
    String reason = 'Authenticate to access your account',
  }) async {
    try {
      final canCheck = await checkBiometricSupport();
      if (!canCheck) return false;

      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  // Token Management
  Future<void> saveToken(String token) async {
    final encrypted = encryptData(token);
    await saveSecureData('boc_token', encrypted);
  }

  Future<String?> getToken() async {
    final encrypted = await readSecureData('boc_token');
    if (encrypted == null) return null;
    return decryptData(encrypted);
  }

  Future<void> clearToken() async {
    await deleteSecureData('boc_token');
  }

  // Input Sanitization
  String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'[<>]'), '')
        .replaceAll(RegExp(r'[&"]'), '')
        .replaceAll(RegExp(r"[']"), '');
  }
}

// lib/src/services/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling secure storage operations.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  /// Initializes the SecureStorageService with FlutterSecureStorage.
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Writes a [value] to secure storage under the specified [key].
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Reads the value associated with the specified [key] from secure storage.
  /// Returns `null` if the key does not exist.
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Deletes the value associated with the specified [key] from secure storage.
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Retrieves all key-value pairs from secure storage.
  Future<Map<String, String>> readAll() async {
    return await _secureStorage.readAll();
  }

  // /// Deletes all key-value pairs from secure storage.
  // Future<void> deleteAll() async {
  //   await _secureStorage.deleteAll();
  // }
}

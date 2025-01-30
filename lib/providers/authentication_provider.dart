// src/providers/authentication_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_storage_service.dart';
import 'package:riverpod/riverpod.dart';

// Enum representing authentication states
enum AuthenticationStateStatus { authenticated, unauthenticated, loading }

// State class for authentication
class AuthenticationState {
  final AuthenticationStateStatus status;

  AuthenticationState({required this.status});

  factory AuthenticationState.initial() {
    return AuthenticationState(status: AuthenticationStateStatus.loading);
  }

  AuthenticationState copyWith({AuthenticationStateStatus? status}) {
    return AuthenticationState(
      status: status ?? this.status,
    );
  }
}

// StateNotifier to manage authentication state
class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final SecureStorageService _secureStorageService;

  AuthenticationNotifier(this._secureStorageService)
      : super(AuthenticationState.initial()) {
    _initialize();
  }

  // Initialize authentication state on startup
  Future<void> _initialize() async {
    final key = await _secureStorageService.read('SECRET_KEY');
    final secret = await _secureStorageService.read('SECRET_SECRET');
    if (key != null && secret != null) {
      state = AuthenticationState(status: AuthenticationStateStatus.authenticated);
    } else {
      state = AuthenticationState(status: AuthenticationStateStatus.unauthenticated);
    }
  }

  // Log in by storing credentials and updating state
  Future<void> login(String key, String secret) async {
    state = AuthenticationState(status: AuthenticationStateStatus.loading);
    await _secureStorageService.write('SECRET_KEY', key);
    await _secureStorageService.write('SECRET_SECRET', secret);
    state = AuthenticationState(status: AuthenticationStateStatus.authenticated);
  }

  // Log out by clearing credentials and updating state
  Future<void> logout() async {
    state = AuthenticationState(status: AuthenticationStateStatus.loading);
    await _secureStorageService.delete('SECRET_KEY');
    await _secureStorageService.delete('SECRET_SECRET');
    state = AuthenticationState(status: AuthenticationStateStatus.unauthenticated);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final key = await _secureStorageService.read('SECRET_KEY');
    final secret = await _secureStorageService.read('SECRET_SECRET');
    return key != null && secret != null;
  }
}

// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Provider for AuthenticationNotifier
final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthenticationNotifier(secureStorage);
});

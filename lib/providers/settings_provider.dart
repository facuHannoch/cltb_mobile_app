// // lib/src/providers/settings_provider.dart

// import 'dart:convert';

// import 'package:cltb_mobile_app/models/user_settings.dart';
// import 'package:cltb_mobile_app/providers/authentication_provider.dart';
// import 'package:cltb_mobile_app/services/logger_service.dart';
// import 'package:cltb_mobile_app/services/secure_storage_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// Provider for SettingsNotifier which manages UserSettings.
// final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
//   final secureStorageService = ref.watch(secureStorageServiceProvider);
//   final logger = ref.watch(loggerServiceProvider);
//   return SettingsNotifier(secureStorageService, logger);
// });

// /// StateNotifier that manages UserSettings.
// class SettingsNotifier extends StateNotifier<UserSettings> {
//   final SecureStorageService _secureStorageService;
//   final LoggerService _logger;

//   /// Constructor initializes with default UserSettings.
//   SettingsNotifier(this._secureStorageService, this._logger) : super(UserSettings.initial()) {
//     loadSettings();
//   }

//   /// Loads settings from secure storage. If not found, uses default settings.
//   Future<void> loadSettings() async {
//     try {
//       final settingsJson = await _secureStorageService.read('user_settings');
//       if (settingsJson != null) {
//         final settingsJsonData = jsonDecode(settingsJson);
//         state = UserSettings.fromJson(settingsJsonData);
//         _logger.logInfo('User settings loaded successfully.');
//       } else {
//         state = UserSettings.initial();
//         _logger.logInfo('No existing user settings found. Initialized with defaults.');
//         await saveSettings();
//       }
//     } catch (e, stackTrace) {
//       _logger.logError('Failed to load user settings.', e as Exception, stackTrace);
//     }
//   }

//   /// Saves current settings to secure storage.
//   Future<void> saveSettings() async {
//     try {
//       final settingsJsonData = state.toJson();
//       final settingsJson = jsonEncode(settingsJsonData);
//       await _secureStorageService.write('user_settings', settingsJson);
//       _logger.logInfo('User settings saved successfully.');
//     } catch (e, stackTrace) {
//       _logger.logError('Failed to save user settings.', e as Exception, stackTrace);
//     }
//   }

//   /// Updates the CEX API URL and persists the change.
//   Future<void> updateCexApiUrl(String url) async {
//     state = state.copyWith(cexBuyOrderIp: url);
//     await saveSettings();
//   }

//   /// Updates the fallback CEX API URL and persists the change.
//   Future<void> updateCexApiFallbackUrl(String? url) async {
//     state = state.copyWith(cexBuyOrderFallbackIp: url);
//     await saveSettings();
//   }


//   /// Updates the DEX API URL and persists the change.
//   Future<void> updateDexApiUrl(String url) async {
//     state = state.copyWith(dexBuyOrderIp: url);
//     await saveSettings();
//   }

//   /// Updates the fallback DEX API URL and persists the change.
//   Future<void> updateDexApiFallbackUrl(String? url) async {
//     state = state.copyWith(dexBuyOrderFallbackIp: url);
//     await saveSettings();
//   }

//   /// Updates the Quick Buy API URL and persists the change.
//   Future<void> updateQuickBuyApiUrl(String url) async {
//     state = state.copyWith(quickBuyIp: url);
//     await saveSettings();
//   }

//   /// Updates the fallback Quick Buy API URL and persists the change.
//   Future<void> updateQuickBuyApiFallbackUrl(String? url) async {
//     state = state.copyWith(quickBuyFallbackIp: url);
//     await saveSettings();
//   }

//   /// Updates the default USD quantity for Quick Buy and persists the change.
//   Future<void> updateDefaultUsdQuantityQuickBuy(double quantity) async {
//     state = state.copyWith(defaultUsdQuantityQuickBuy: quantity);
//     await saveSettings();
//   }

//   /// Bulk updates API endpoints and persists all changes.
//   Future<void> setApiEndpoints(UserSettings settings) async {
//     state = settings;
//     await saveSettings();
//   }
// }



// lib/src/providers/settings_provider.dart

import 'package:cltb_mobile_app/models/user_settings.dart';
import 'package:cltb_mobile_app/providers/authentication_provider.dart';
import 'package:cltb_mobile_app/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum representing WebSocket connection status
enum WebSocketStatus { connected, disconnected, connecting, error }

class SettingsNotifier extends StateNotifier<UserSettings> {
  SettingsNotifier(this._secureStorageService)
      : super(UserSettings(
          cexBuyOrderIp: '192.168.1.1', // Default IPs; replace with actual defaults
          cexBuyOrderFallbackIp: null,
          dexBuyOrderIp: '192.168.2.1',
          dexBuyOrderFallbackIp: null,
          quickBuyIp: '192.168.3.1',
          quickBuyFallbackIp: null,
          defaultUsdQuantityQuickBuy: 20.0,
          webSocketSettings: WebSocketSettings(
            primaryUrl: 'ws://default_websocket_url',
            isConnected: false,
          ),
        )) {
    loadSettings();
  }

  final SecureStorageService _secureStorageService;

  Future<void> loadSettings() async {
    // Load settings from secure storage or initialize with defaults
    final cexIp = await _secureStorageService.read('cexBuyOrderIp') ?? state.cexBuyOrderIp;
    final dexIp = await _secureStorageService.read('dexBuyOrderIp') ?? state.dexBuyOrderIp;
    final quickBuyIp = await _secureStorageService.read('quickBuyIp') ?? state.quickBuyIp;
    final defaultUsd = double.tryParse(await _secureStorageService.read('defaultUsdQuantityQuickBuy') ?? '20.0') ?? 20.0;

    final cexFallbackIp = await _secureStorageService.read('cexBuyOrderFallbackIp');
    final dexFallbackIp = await _secureStorageService.read('dexBuyOrderFallbackIp');
    final quickBuyFallbackIp = await _secureStorageService.read('quickBuyFallbackIp');

    state = state.copyWith(
      cexBuyOrderIp: cexIp,
      cexBuyOrderFallbackIp: cexFallbackIp,
      dexBuyOrderIp: dexIp,
      dexBuyOrderFallbackIp: dexFallbackIp,
      quickBuyIp: quickBuyIp,
      quickBuyFallbackIp: quickBuyFallbackIp,
      defaultUsdQuantityQuickBuy: defaultUsd,
      // webSocketSettings can be loaded or remain as default
    );
  }

  // Update Methods

  // Future<void> updateCexBuyOrderPort(String newIp) async {
  //   state = state.copyWith(cexBuyOrderIp: newIp);
  //   await _secureStorageService.write('cexBuyOrderIp', newIp);
  // }

  Future<void> updateCexBuyOrderIp(String newIp) async {
    state = state.copyWith(cexBuyOrderIp: newIp);
    await _secureStorageService.write('cexBuyOrderIp', newIp);
  }

  Future<void> updateCexBuyOrderFallbackIp(String? newIp) async {
    state = state.copyWith(cexBuyOrderFallbackIp: newIp);
    if (newIp != null) {
      await _secureStorageService.write('cexBuyOrderFallbackIp', newIp);
    } else {
      await _secureStorageService.delete('cexBuyOrderFallbackIp');
    }
  }

  Future<void> updateDexBuyOrderIp(String newIp) async {
    state = state.copyWith(dexBuyOrderIp: newIp);
    await _secureStorageService.write('dexBuyOrderIp', newIp);
  }

  Future<void> updateDexBuyOrderFallbackIp(String? newIp) async {
    state = state.copyWith(dexBuyOrderFallbackIp: newIp);
    if (newIp != null) {
      await _secureStorageService.write('dexBuyOrderFallbackIp', newIp);
    } else {
      await _secureStorageService.delete('dexBuyOrderFallbackIp');
    }
  }

  Future<void> updateQuickBuyIp(String newIp) async {
    state = state.copyWith(quickBuyIp: newIp);
    await _secureStorageService.write('quickBuyIp', newIp);
  }

  Future<void> updateQuickBuyFallbackIp(String? newIp) async {
    state = state.copyWith(quickBuyFallbackIp: newIp);
    if (newIp != null) {
      await _secureStorageService.write('quickBuyFallbackIp', newIp);
    } else {
      await _secureStorageService.delete('quickBuyFallbackIp');
    }
  }

  Future<void> updateDefaultUsdQuantityQuickBuy(double newQuantity) async {
    state = state.copyWith(defaultUsdQuantityQuickBuy: newQuantity);
    await _secureStorageService.write('defaultUsdQuantityQuickBuy', newQuantity.toString());
  }

  Future<void> updateWebSocketStatus(bool isConnected) async {
    state = state.copyWith(
      webSocketSettings: state.webSocketSettings.copyWith(isConnected: isConnected),
    );
  }

  // Additional methods to update WebSocket URLs if needed
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  return SettingsNotifier(secureStorageService);
});

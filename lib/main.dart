// File: lib/main.dart

import 'package:cltb_mobile_app/models/user_settings.dart';
import 'package:cltb_mobile_app/router/app_router.dart';
import 'package:cltb_mobile_app/screens/HomesScreen.dart';
import 'package:cltb_mobile_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cltb_mobile_app/providers/settings_provider.dart';
import 'package:cltb_mobile_app/providers/authentication_provider.dart';
import 'package:cltb_mobile_app/providers/network_provider.dart';
// import 'package:cltb_mobile_app/services/websocket_service.dart';
// import 'package:cltb_mobile_app/services/api_service.dart';
// import 'package:cltb_mobile_app/services/secure_storage_service.dart';
import 'package:cltb_mobile_app/services/logger_service.dart';
// import 'package:cltb_mobile_app/router/app_router.dart'; // Assumed router file
// import 'package:cltb_mobile_app/screens/splash_screen.dart'; // Assumed splash screen

/// Entry point of the Flutter application.
void main() {
  runApp(
    /// Initializes Riverpod for state management across the application.
    ProviderScope(
      child: App(),
    ),
  );
}

/// Root widget of the application.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize LoggerService
    final logger = ref.watch(loggerServiceProvider);

    // Initialize SecureStorageService
    final secureStorage = ref.watch(secureStorageServiceProvider);

    // Initialize ApiService
    final apiService = ref.watch(apiServiceProvider);

    // // Initialize WebSocketService
    // final webSocketService = ref.watch(webSocketServiceProvider);
    //
    // // Load user settings at startup
    // ref.read(settingsProvider.notifier).loadSettings().catchError((error) {
    //   logger.logError('Failed to load settings: $error');
    // });
    //
    // // Establish WebSocket connection after settings are loaded
    // ref.listen<UserSettings>(settingsProvider, (previous, next) {
    //   if (next.webSocketSettings.primaryUrl.isNotEmpty) {
    //     webSocketService.connect(next.webSocketSettings.primaryUrl).catchError((error) {
    //       logger.logError('WebSocket connection failed: $error');
    //     });
    //   } else {
    //     logger.logWarning('WebSocket primary URL is empty.');
    //   }
    // });

    return MaterialApp(
      title: 'Crypto Trading Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /// Uses AppRouter to manage navigation and routing.
      // onGenerateRoute: AppRouter.generateRoute,
      /// Displays SplashScreen while initializing.
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

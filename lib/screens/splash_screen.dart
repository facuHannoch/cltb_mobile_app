// // File: lib/src/screens/splash_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/settings_provider.dart';
// import '../providers/network_provider.dart';
// import '../services/api_service.dart';
// import '../services/websocket_service.dart';
// import '../services/logger_service.dart';
// import 'pending_launches_screen.dart'; // Assumed screen
// import 'cex_order_screen.dart'; // Assumed screen

// /// SplashScreen is the initial screen displayed when the app launches.
// /// It performs essential initialization tasks such as loading user settings,
// /// establishing WebSocket connections, fetching pending launches, and navigating
// /// to the appropriate initial screen based on the fetched data.
// class SplashScreen extends ConsumerStatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   late bool _pending_launches;

//   /// Performs initialization tasks sequentially.
//   Future<void> _initializeApp() async {
//     try {
//       // Load user settings
//       await ref.read(settingsProvider.notifier).loadSettings();
//       final settings = ref.read(settingsProvider);

//       // Establish WebSocket connection
//       if (settings.webSocketSettings.primaryUrl.isNotEmpty) {
//         await ref
//             .read(webSocketServiceProvider)
//             .connect(settings.webSocketSettings.primaryUrl);
//       } else {
//         ref.read(loggerServiceProvider).logWarning(
//             'WebSocket primary URL is empty. Connection not established.');
//       }

//       // Fetch pending launches
//       final apiService = ref.read(apiServiceProvider);
//       final pendingLaunchesResponse = await apiService.getPendingLaunches();

//       if (pendingLaunchesResponse.success &&
//           pendingLaunchesResponse.data != null) {
//         // final pendingLaunches = pendingLaunchesResponse.data!;
//         _pending_launches = true;
//         // _navigateToInitialScreen(pendingLaunches.isNotEmpty);
//       } else {
//         // Log the error and navigate to CEX Order screen as fallback
//         ref.read(loggerServiceProvider).logError(
//             'Failed to fetch pending launches: ${pendingLaunchesResponse.errorMessage}');
//         // _navigateToInitialScreen(false);
//         _pending_launches = false;
//       }
//     } catch (e, stackTrace) {
//       // Log any unexpected errors
//       ref.read(loggerServiceProvider).logError('Initialization failed: $e',
//           e as Exception?, stackTrace);
//       // Navigate to CEX Order screen as fallback
//       // _navigateToInitialScreen(false);
//       _pending_launches = false;
//     }
//   }

//   // /// Navigates to the appropriate initial screen based on [hasPendingLaunches].
//   // void _navigateToInitialScreen(bool hasPendingLaunches) {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     if (hasPendingLaunches) {
//   //       Navigator.of(context).pushReplacement(
//   //         MaterialPageRoute(builder: (_) => PendingLaunchesScreen()),
//   //       );
//   //     } else {
//   //       Navigator.of(context).pushReplacement(
//   //         MaterialPageRoute(builder: (_) => CEXOrderScreen()),
//   //       );
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         /// Displays a loading indicator while initialization tasks are in progress.
//         child: CircularProgressIndicator(),
//         if
//       ),
//     );
//   }
// }

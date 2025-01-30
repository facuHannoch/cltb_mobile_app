// // File: lib/src/router/app_router.dart

// import 'package:flutter/material.dart';
// import '../screens/splash_screen.dart';
// // import '../screens/main_screen.dart';
// // import '../screens/cex_order_screen.dart';
// // import '../screens/pending_launches_screen.dart';
// // import '../screens/dex_order_screen.dart';
// // import '../screens/quick_buy_screen.dart';

// class AppRouter {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => SplashScreen());
//       // case '/main':
//       //   return MaterialPageRoute(builder: (_) => MainScreen());
//       // case '/cex':
//       //   return MaterialPageRoute(builder: (_) => CEXOrderScreen());
//       // case '/pending':
//       //   return MaterialPageRoute(builder: (_) => PendingLaunchesScreen());
//       // case '/dex':
//       //   return MaterialPageRoute(builder: (_) => DEXOrderScreen());
//       // case '/quick_buy':
//       //   return MaterialPageRoute(builder: (_) => QuickBuyScreen());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }
// }

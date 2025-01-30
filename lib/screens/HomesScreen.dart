import 'package:cltb_mobile_app/screens/cex_order_screen.dart';
import 'package:cltb_mobile_app/screens/dex_order_screen.dart';
import 'package:cltb_mobile_app/screens/pending_launches_screen.dart';
import 'package:cltb_mobile_app/screens/quick_buy_screen.dart';
import 'package:cltb_mobile_app/screens/settings_screen.dart';
import 'package:cltb_mobile_app/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:cltb_mobile_app/services/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // ExampleWidget(),
    CEXOrderScreen(),
    PendingLaunchesScreen(),
    DexOrderScreen(),
    QuickBuyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      appBar: AppBar(
        actions: [
          IconButton.outlined(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.transfer_within_a_station),
          //   label: 'TEST',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'CEX',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_tilt_shift_rounded),
            label: 'DEX',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Quick Buy',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Example usage in another part of the application

// import 'package:flutter/material.dart';
// import 'package:cltb_mobile_app/services/websocket_service.dart';

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    // Connect to the WebSocket server
    _webSocketService.connect('ws://your_server_url');

    print(_webSocketService.connectionStatus);
    print(_webSocketService.isConnected);

    // Listen to incoming messages
    _webSocketService.messages.listen((message) {
      print('Received message: $message');
    });

    // Listen to connection status changes
    _webSocketService.connectionStatus.listen((status) {
      print('Connection Status: $status');
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_webSocketService.isConnected) {
      _webSocketService.sendMessage('Hello Server!');
    } else {
      print('WebSocket is not connected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            ElevatedButton(
              onPressed: () async {
                final s = SecureStorageService();
                String key = await s.read('api_key') ?? "null";
                print(key);

                final allKeys = await s.readAll();
                print(allKeys);
              },
              child: Text('Print secure key'),
            ),
          ],
        ),
      ),
    );
  }
}

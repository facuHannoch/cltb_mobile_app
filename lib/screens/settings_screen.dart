// lib/src/screens/settings_screen.dart

import 'package:cltb_mobile_app/providers/authentication_provider.dart';
import 'package:cltb_mobile_app/providers/network_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cltb_mobile_app/providers/settings_provider.dart';
import 'package:cltb_mobile_app/services/secure_storage_service.dart';
import 'package:cltb_mobile_app/services/websocket_service.dart';
import 'package:cltb_mobile_app/utils/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cltb_mobile_app/models/user_settings.dart'; // Ensure this import is present

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cexPrimaryPortController =
      TextEditingController();

  // Controllers for IP addresses
  final TextEditingController _cexPrimaryIpController = TextEditingController();
  final TextEditingController _cexFallbackIpController =
      TextEditingController();
  final TextEditingController _dexPrimaryIpController = TextEditingController();
  final TextEditingController _dexFallbackIpController =
      TextEditingController();
  final TextEditingController _quickBuyPrimaryIpController =
      TextEditingController();
  final TextEditingController _quickBuyFallbackIpController =
      TextEditingController();

  // Controller for Default USD Quantity
  final TextEditingController _defaultUsdQuantityController =
      TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current settings
    final settings = ref.read(settingsProvider);
    _cexPrimaryIpController.text = settings.cexBuyOrderIp;
    _cexFallbackIpController.text = settings.cexBuyOrderFallbackIp ?? '';
    _dexPrimaryIpController.text = settings.dexBuyOrderIp;
    _dexFallbackIpController.text = settings.dexBuyOrderFallbackIp ?? '';
    _quickBuyPrimaryIpController.text = settings.quickBuyIp;
    _quickBuyFallbackIpController.text = settings.quickBuyFallbackIp ?? '';
    _defaultUsdQuantityController.text =
        settings.defaultUsdQuantityQuickBuy.toString();
  }

  @override
  void dispose() {
    _cexPrimaryIpController.dispose();
    _cexFallbackIpController.dispose();
    _dexPrimaryIpController.dispose();
    _dexFallbackIpController.dispose();
    _quickBuyPrimaryIpController.dispose();
    _quickBuyFallbackIpController.dispose();
    _defaultUsdQuantityController.dispose();
    super.dispose();
  }

  Future<void> _showCredentialsDialog(BuildContext context) async {
    final TextEditingController keyController = TextEditingController();
    final TextEditingController secretController = TextEditingController();
    final _dialogFormKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Credentials'),
          content: Form(
            key: _dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    labelText: 'SECRET_KEY',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter SECRET_KEY';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: secretController,
                  decoration: const InputDecoration(
                    labelText: 'SECRET_SECRET',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter SECRET_SECRET';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_dialogFormKey.currentState!.validate()) {
                  final key = keyController.text.trim();
                  final secret = secretController.text.trim();

                  await ref
                      .read(secureStorageServiceProvider)
                      .write('SECRET_KEY', key);
                  await ref
                      .read(secureStorageServiceProvider)
                      .write('SECRET_SECRET', secret);

                  // Update settingsProvider with new credentials if necessary
                  // Assuming UserSettings has fields for credentials, otherwise handle accordingly

                  Fluttertoast.showToast(msg: 'Credentials saved successfully');

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _testWebSocketConnection(WidgetRef ref) async {
    final webSocketService = ref.read(webSocketServiceProvider);
    try {
      webSocketService.sendMessage('ping');
      // Depending on your server's implementation, handle the response accordingly.
      Fluttertoast.showToast(msg: 'WebSocket connection OK');
    } catch (e) {
      Fluttertoast.showToast(msg: 'WebSocket connection failed');
    }
  }

  Future<void> _setUpWebSocket(WidgetRef ref) async {
    final webSocketService = ref.read(webSocketServiceProvider);
    final settings = ref.read(settingsProvider);

    try {
      await webSocketService.connect(settings.webSocketSettings.primaryUrl);
      Fluttertoast.showToast(msg: 'WebSocket connected');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to connect WebSocket');
    }
  }

  Future<void> _closeWebSocket(WidgetRef ref) async {
    final webSocketService = ref.read(webSocketServiceProvider);

    try {
      webSocketService.disconnect();
      Fluttertoast.showToast(msg: 'WebSocket disconnected');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to disconnect WebSocket');
    }
  }

  void _updateCexPrimaryIp(String value) {
    if (validateUrl(value) == null) {
      ref.read(settingsProvider.notifier).updateCexBuyOrderIp(value.trim());
    }
  }

  // void _updateCexPrimaryPort(String value) {
  //   if (validatePort(value) == null) {
  //     ref.read(settingsProvider.notifier).updateCexBuyOrderIp(value.trim());
  //   }
  // }

  void _updateCexFallbackIp(String value) {
    if (value.isEmpty || validateUrl(value) == null) {
      ref.read(settingsProvider.notifier).updateCexBuyOrderFallbackIp(
          value.trim().isEmpty ? null : value.trim());
    }
  }

  void _updateDexPrimaryIp(String value) {
    if (validateUrl(value) == null) {
      ref.read(settingsProvider.notifier).updateDexBuyOrderIp(value.trim());
    }
  }

  void _updateDexFallbackIp(String value) {
    if (value.isEmpty || validateUrl(value) == null) {
      ref.read(settingsProvider.notifier).updateDexBuyOrderFallbackIp(
          value.trim().isEmpty ? null : value.trim());
    }
  }

  void _updateQuickBuyPrimaryIp(String value) {
    if (validateUrl(value) == null) {
      ref.read(settingsProvider.notifier).updateQuickBuyIp(value.trim());
    }
  }

  void _updateQuickBuyFallbackIp(String value) {
    if (value.isEmpty || validateUrl(value) == null) {
      ref
          .read(settingsProvider.notifier)
          .updateQuickBuyFallbackIp(value.trim().isEmpty ? null : value.trim());
    }
  }

  void _updateDefaultUsdQuantity(String value) {
    final error = validateUsdAmount(value);
    if (error == null) {
      final quantity = double.parse(value.trim());
      ref
          .read(settingsProvider.notifier)
          .updateDefaultUsdQuantityQuickBuy(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IP Address Configuration
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'IP Addresses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // CEX Buy Orders IP
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CEX Buy Orders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: _cexPrimaryIpController,
                decoration: const InputDecoration(
                  labelText: 'Primary IP Address',
                  hintText:
                      'e.g., 192.168.1.1 or 2001:0db8:85a3:0000:0000:8a2e:0370:7334',
                ),
                keyboardType: TextInputType.text,
                validator: validateUrl,
                onChanged: _updateCexPrimaryIp,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: TextFormField(
              //         controller: _cexPrimaryIpController,
              //         decoration: const InputDecoration(
              //           labelText: 'Primary IP Address',
              //           hintText:
              //               'e.g., 192.168.1.1 or 2001:0db8:85a3:0000:0000:8a2e:0370:7334',
              //         ),
              //         keyboardType: TextInputType.text,
              //         validator: validateUrl,
              //         onChanged: _updateCexPrimaryIp,
              //       ),
              //     ),
              //     Flexible(
              //       flex: 1,
              //       child: TextFormField(
              //         controller: _cexPrimaryPortController,
              //         decoration: const InputDecoration(
              //           labelText: 'Port',
              //           hintText: 'e.g., 5000',
              //         ),
              //         keyboardType: TextInputType.text,
              //         validator: validatePort,
              //         onChanged: _updateCexPrimaryIp,
              //       ),
              //     ),
              //   ],
              // ),
              TextFormField(
                controller: _cexFallbackIpController,
                decoration: const InputDecoration(
                  labelText: 'Fallback IP Address',
                  hintText:
                      'e.g., 192.168.1.2 or 2001:0db8:85a3:0000:0000:8a2e:0370:7335',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return validateUrl(value);
                  }
                  return null;
                },
                onChanged: _updateCexFallbackIp,
              ),
              const SizedBox(height: 20),

              // DEX Buy Orders IP
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DEX Buy Orders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: _dexPrimaryIpController,
                decoration: const InputDecoration(
                  labelText: 'Primary IP Address',
                  hintText:
                      'e.g., 192.168.2.1 or 2001:0db8:85a3:0000:0000:8a2e:0370:7336',
                ),
                keyboardType: TextInputType.text,
                validator: validateUrl,
                onChanged: _updateDexPrimaryIp,
              ),
              TextFormField(
                controller: _dexFallbackIpController,
                decoration: const InputDecoration(
                  labelText: 'Fallback IP Address',
                  hintText:
                      'e.g., 192.168.2.2 or 2001:0db8:85a3:0000:0000:8a2e:0370:7337',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return validateUrl(value);
                  }
                  return null;
                },
                onChanged: _updateDexFallbackIp,
              ),
              const SizedBox(height: 20),

              // Quick Buy IP
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Buy',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              TextFormField(
                controller: _quickBuyPrimaryIpController,
                decoration: const InputDecoration(
                  labelText: 'Primary IP Address',
                  hintText:
                      'e.g., 192.168.3.1 or 2001:0db8:85a3:0000:0000:8a2e:0370:7338',
                ),
                keyboardType: TextInputType.text,
                validator: validateUrl,
                onChanged: _updateQuickBuyPrimaryIp,
              ),
              TextFormField(
                controller: _quickBuyFallbackIpController,
                decoration: const InputDecoration(
                  labelText: 'Fallback IP Address',
                  hintText:
                      'e.g., 192.168.3.2 or 2001:0db8:85a3:0000:0000:8a2e:0370:7339',
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return validateUrl(value);
                  }
                  return null;
                },
                onChanged: _updateQuickBuyFallbackIp,
              ),
              const SizedBox(height: 30),

              // Authentication Credentials
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Authentication Credentials',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showCredentialsDialog(context),
                child: const Text('Set Credentials'),
              ),
              const SizedBox(height: 30),

              // Quick Buy Configuration
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Buy Configuration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _defaultUsdQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Default USD Quantity',
                  hintText: 'e.g., 20.0',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: validateUsdAmount,
                onChanged: _updateDefaultUsdQuantity,
              ),
              const SizedBox(height: 30),

              // WebSocket Connection Settings
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'WebSocket Connection',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _testWebSocketConnection(ref),
                child: const Text('Test Connection'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _setUpWebSocket(ref),
                    child: const Text('Set Up'),
                  ),
                  ElevatedButton(
                    onPressed: () => _closeWebSocket(ref),
                    child: const Text('Close'),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.red,
                    // ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Display Current WebSocket Status
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Current WebSocket Status:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                settings.webSocketSettings.isConnected
                    ? 'Connected'
                    : 'Disconnected',
                style: TextStyle(
                  color: settings.webSocketSettings.isConnected
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

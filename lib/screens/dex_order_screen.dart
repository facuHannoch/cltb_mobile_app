// lib/src/screens/dex_order_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cltb_mobile_app/models/dex_order.dart';
import 'package:cltb_mobile_app/services/api_service.dart';
import 'package:cltb_mobile_app/services/logger_service.dart';
import 'package:cltb_mobile_app/widgets/json_preview_popup.dart';
import 'package:cltb_mobile_app/providers/network_provider.dart';
import 'package:cltb_mobile_app/utils/validators.dart';
import 'package:cltb_mobile_app/utils/json_formatter.dart';

/// A screen that allows users to create and send orders to decentralized exchanges (DEX).
class DexOrderScreen extends ConsumerStatefulWidget {
  const DexOrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DexOrderScreen> createState() => _DexOrderScreenState();
}

class _DexOrderScreenState extends ConsumerState<DexOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _tokenAddressController = TextEditingController();
  String? _selectedNetwork;
  final TextEditingController _customNetworkController = TextEditingController();
  final TextEditingController _dexController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // List of predefined networks
  final List<String> _networks = ['SOL', 'BSC', 'BASE', 'ARB', 'Other'];

  // Variable to control visibility of custom network input
  bool _isCustomNetwork = false;

  @override
  void dispose() {
    _tokenAddressController.dispose();
    _customNetworkController.dispose();
    _dexController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Handles the submission of the DEX order form.
  Future<void> _submitDEXOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Construct the network value
      String network = _selectedNetwork!;
      if (_selectedNetwork == 'Other') {
        network = _customNetworkController.text.trim();
      }

      // Parse quantity if provided
      double? quantity;
      if (_quantityController.text.trim().isNotEmpty) {
        quantity = double.parse(_quantityController.text.trim());
      }

      // Create DEXOrder instance
      DEXOrder dexOrder = DEXOrder(
        tokenAddress: _tokenAddressController.text.trim(),
        network: network,
        dex: _dexController.text.trim().isEmpty ? null : _dexController.text.trim(),
        quantity: quantity,
      );

      // Convert DEXOrder to formatted JSON
      String jsonData;
      try {
        jsonData = JsonFormatter.formatJson(jsonEncode(dexOrder.toJson()));
      } catch (e) {
        ref.read(loggerServiceProvider).logError('JSON Formatting Error', e as Exception?, StackTrace.current);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to format JSON data.')),
        );
        return;
      }

      // Show JSON Preview Popup
      bool? shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (context) => JsonPreviewPopup(
          jsonData: jsonData,
          onSubmit: () => Navigator.of(context).pop(true),
        ),
      );

      if (shouldSubmit == true) {
        // Send DEX Order via ApiService
        ApiService apiService = ref.read(apiServiceProvider);
        ApiResponse response = await apiService.sendDEXOrder(dexOrder);

        // Handle the response
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('DEX Order submitted successfully.')),
          );
          _formKey.currentState?.reset();
          setState(() {
            _selectedNetwork = null;
            _isCustomNetwork = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit DEX Order: ${response.errorMessage}')),
          );
          ref.read(loggerServiceProvider).logError('DEX Order Submission Failed', null, StackTrace.current);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = ref.watch(loggerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send DEX Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Token Address Field
              TextFormField(
                controller: _tokenAddressController,
                decoration: const InputDecoration(
                  labelText: 'Token Address',
                  hintText: 'Enter the token address',
                ),
                validator: validateTokenAddress,
              ),
              const SizedBox(height: 16.0),

              // Network Selection Dropdown
              DropdownButtonFormField<String>(
                value: _selectedNetwork,
                decoration: const InputDecoration(
                  labelText: 'Network',
                ),
                items: _networks
                    .map(
                      (network) => DropdownMenuItem(
                        value: network,
                        child: Text(network),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedNetwork = value;
                    _isCustomNetwork = value == 'Other';
                  });
                },
                validator: (value) => validateNetwork(value, customNetwork: _customNetworkController.text),
              ),
              const SizedBox(height: 16.0),

              // Custom Network Field (Visible only if 'Other' is selected)
              if (_isCustomNetwork)
                TextFormField(
                  controller: _customNetworkController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Network',
                    hintText: 'Enter custom network name',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a custom network name.'
                      : null,
                ),
              if (_isCustomNetwork) const SizedBox(height: 16.0),

              // DEX Name Field (Optional)
              TextFormField(
                controller: _dexController,
                decoration: const InputDecoration(
                  labelText: 'DEX Name (Optional)',
                  hintText: 'Enter the DEX name',
                ),
                // validator: validateDexName, // Ensure this validator exists
              ),
              const SizedBox(height: 16.0),

              // Quantity Field (Optional)
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (Optional)',
                  hintText: 'Enter the quantity',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: validateQuantity,
              ),
              const SizedBox(height: 32.0),

              // Submit Button
              ElevatedButton(
                onPressed: _submitDEXOrder,
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/src/screens/quick_buy_screen.dart

import 'package:cltb_mobile_app/models/quick_buy.dart';
import 'package:cltb_mobile_app/providers/network_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/orders_provider.dart';
import '../services/logger_service.dart';

class QuickBuyScreen extends ConsumerStatefulWidget {
  const QuickBuyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QuickBuyScreen> createState() => _QuickBuyScreenState();
}

class _QuickBuyScreenState extends ConsumerState<QuickBuyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tokenAddressController = TextEditingController();
  final TextEditingController _usdAmountController = TextEditingController(text: '20');

  @override
  void dispose() {
    _tokenAddressController.dispose();
    _usdAmountController.dispose();
    super.dispose();
  }

  /// Validates the USD amount input.
  String? _validateUsdAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingrese la cantidad en USD.';
    }
    final usd = double.tryParse(value);
    if (usd == null) {
      return 'Ingrese un número válido.';
    }
    if (usd <= 0) {
      return 'La cantidad debe ser mayor que cero.';
    }
    final parts = value.split('.');
    if (parts.length == 2 && parts[1].length > 1) {
      return 'Máximo 1 decimal permitido.';
    }
    return null;
  }

  /// Submits the quick buy order.
  Future<void> _submitQuickBuy(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final tokenAddress = _tokenAddressController.text.trim();
    final usdAmountText = _usdAmountController.text.trim();
    final usdAmount = double.tryParse(usdAmountText) ?? 20.0;

    final quickBuyOrder = QuickBuyOrder(
      tokenAddress: tokenAddress,
      usdQuantity: usdAmount,
    );

    final apiService = ref.read(apiServiceProvider);
    final logger = ref.read(loggerServiceProvider);

    try {
      // Perform the quick buy using ApiService
      final response = await apiService.quickBuy(quickBuyOrder);

      if (response.success) {
        Fluttertoast.showToast(msg: 'Orden de Quick Buy enviada con éxito.');
        // Optionally, refresh pending launches
        await ref.read(ordersProvider.notifier).fetchPendingLaunches();
        // Clear the token address field after successful submission
        _tokenAddressController.clear();
      } else {
        Fluttertoast.showToast(msg: 'Error al enviar la orden: ${response.errorMessage}');
      }
    } catch (e, stackTrace) {
      logger.logError('Error al enviar la orden de Quick Buy', e as Exception, stackTrace);
      Fluttertoast.showToast(msg: 'Ocurrió un error inesperado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(ordersProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Buy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _tokenAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección del Token',
                        hintText: '0xdf4ee53f498ec863ab74c5ce7de56fd8ea306257',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        // Currently not validated, placeholder for future validation
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, ingrese la dirección del token.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _usdAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad en USD',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validateUsdAmount,
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submitQuickBuy(context),
                        child: const Text('Quick Buy'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

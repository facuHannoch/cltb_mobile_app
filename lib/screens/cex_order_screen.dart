// File: lib/src/screens/cex_order_screen.dart

import 'dart:convert';

import 'package:cltb_mobile_app/models/cex_order.dart';
import 'package:cltb_mobile_app/providers/network_provider.dart';
import 'package:cltb_mobile_app/services/api_service.dart';
import 'package:cltb_mobile_app/services/logger_service.dart';
import 'package:cltb_mobile_app/utils/json_formatter.dart';
import 'package:cltb_mobile_app/widgets/json_preview_popup.dart';
import 'package:cltb_mobile_app/widgets/order_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A screen that allows users to create and submit CEX orders.
/// Utilizes [CEXOrderForm] to capture user input and displays a JSON preview before submission.
class CEXOrderScreen extends ConsumerWidget {
  /// Constructs a [CEXOrderScreen].
  const CEXOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the ApiService instance from the provider
    final apiService = ref.watch(apiServiceProvider);
    // Access the LoggerService instance from the provider
    final logger = ref.watch(loggerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send CEX Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CEXOrderForm(
          onSubmit: (CEXOrder order) {
            _showJsonPreview(context, order, apiService, logger);
          },
          includeExtraConfig: true,
        ),
      ),
    );
  }

  /// Displays a popup with the formatted JSON of the [order].
  /// Provides an option to submit the order.
  void _showJsonPreview(
    BuildContext context,
    CEXOrder order,
    ApiService apiService,
    LoggerService logger,
  ) {
    final formattedJson = JsonFormatter.formatJson(jsonEncode(order.toJson()));

    showDialog(
      context: context,
      builder: (context) {
        return JsonPreviewPopup(
          jsonData: formattedJson,
          onSubmit: () {
            Navigator.of(context).pop(); // Close the popup
            _submitCEXOrder(context, order, apiService, logger);
          },
        );
      },
    );
  }

  /// Sends the [order] to the server using [apiService].
  /// Displays success or error messages based on the response.
  Future<void> _submitCEXOrder(
    BuildContext context,
    CEXOrder order,
    ApiService apiService,
    LoggerService logger,
  ) async {
    try {
      // Send the CEX order using the ApiService
      final response = await apiService.sendCEXOrder(order);

      if (response.success) {
        // If successful, show a success message
        Fluttertoast.showToast(
          msg: "Order submitted successfully. Task ID: ${response.data['task_id']}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        logger.logInfo('CEX Order submitted successfully: Task ID ${response.data['task_id']}');
      } else {
        // If failed, show an error message
        Fluttertoast.showToast(
          msg: "Failed to submit order: ${response.errorMessage}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        logger.logError('Failed to submit CEX Order: ${response.errorMessage}');
      }
    } catch (e, stackTrace) {
      // Handle any exceptions that occur during the request
      Fluttertoast.showToast(
        msg: "An error occurred while submitting the order.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      logger.logError('Exception during CEX Order submission: $e', e as Exception, stackTrace);
    }
  }
}

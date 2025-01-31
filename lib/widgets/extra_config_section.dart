// File: lib/src/widgets/extra_config_section.dart

import 'package:flutter/material.dart';
import '../utils/validators.dart';

/// A reusable widget that encapsulates the extra configuration fields required for CEX orders.
///
/// Parameters:
/// - [quoteToken]: The initial value for the Quote Token field.
/// - [profitsThreshold]: The initial value for the Profits Threshold field.
/// - [profitsTakePercent]: The initial value for the Profits Take Percentage field.
/// - [usdAllocation]: The initial value for the USD Allocation field.
/// - [maxTokenMarketPrice]: The initial value for the Max Token Market Price field.
/// - [onQuoteTokenChanged]: Callback triggered when Quote Token changes.
/// - [onProfitsThresholdChanged]: Callback triggered when Profits Threshold changes.
/// - [onProfitsTakePercentChanged]: Callback triggered when Profits Take Percentage changes.
/// - [onUsdAllocationChanged]: Callback triggered when USD Allocation changes.
/// - [onMaxTokenMarketPriceChanged]: Callback triggered when Max Token Market Price changes.
class ExtraConfigSection extends StatefulWidget {
  final String quoteToken;
  final double? profitsThreshold;
  final double? profitsTakePercent;
  final double? usdAllocation;
  final double? maxTokenMarketPrice;
  final Function(String) onQuoteTokenChanged;
  final Function(double?) onProfitsThresholdChanged;
  final Function(double?) onProfitsTakePercentChanged;
  final Function(double?) onUsdAllocationChanged;
  final Function(double?) onMaxTokenMarketPriceChanged;

  const ExtraConfigSection({
    Key? key,
    required this.quoteToken,
    required this.profitsThreshold,
    required this.profitsTakePercent,
    required this.usdAllocation,
    required this.maxTokenMarketPrice,
    required this.onQuoteTokenChanged,
    required this.onProfitsThresholdChanged,
    required this.onProfitsTakePercentChanged,
    required this.onUsdAllocationChanged,
    required this.onMaxTokenMarketPriceChanged,
  }) : super(key: key);

  @override
  _ExtraConfigSectionState createState() => _ExtraConfigSectionState();
}

class _ExtraConfigSectionState extends State<ExtraConfigSection> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _quoteTokenController;
  late TextEditingController _profitsThresholdController;
  late TextEditingController _profitsTakePercentController;
  late TextEditingController _usdAllocationController;
  late TextEditingController _maxTokenMarketPriceController;

  @override
  void initState() {
    super.initState();
    _quoteTokenController = TextEditingController(text: widget.quoteToken);
    _profitsThresholdController = TextEditingController(
        text: widget.profitsThreshold != null
            ? widget.profitsThreshold!.toStringAsFixed(3)
            : '');
    _profitsTakePercentController = TextEditingController(
        text: widget.profitsTakePercent != null
            ? widget.profitsTakePercent!.toStringAsFixed(2)
            : '');
    _usdAllocationController = TextEditingController(
        text: widget.usdAllocation != null
            ? widget.usdAllocation!.toStringAsFixed(3)
            : '');
    _maxTokenMarketPriceController = TextEditingController(
        text: widget.maxTokenMarketPrice != null
            ? widget.maxTokenMarketPrice!.toStringAsFixed(2)
            : '');
  }

  @override
  void dispose() {
    _quoteTokenController.dispose();
    _profitsThresholdController.dispose();
    _profitsTakePercentController.dispose();
    _usdAllocationController.dispose();
    _maxTokenMarketPriceController.dispose();
    super.dispose();
  }

  /// Validates the form and returns true if all fields are valid.
  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  /// Handles changes to the input fields and invokes corresponding callbacks.
  void _handleFieldChange() {
    if (_validateForm()) {
      widget.onQuoteTokenChanged(_quoteTokenController.text.trim());
      widget.onProfitsThresholdChanged(
          _profitsThresholdController.text.isNotEmpty
              ? double.tryParse(_profitsThresholdController.text)
              : null);
      widget.onProfitsTakePercentChanged(
          _profitsTakePercentController.text.isNotEmpty
              ? double.tryParse(_profitsTakePercentController.text)
              : null);
      widget.onUsdAllocationChanged(
          _usdAllocationController.text.isNotEmpty
              ? double.tryParse(_usdAllocationController.text)
              : null);
      widget.onMaxTokenMarketPriceChanged(
          _maxTokenMarketPriceController.text.isNotEmpty
              ? double.tryParse(_maxTokenMarketPriceController.text)
              : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Extra Configuration"),
      maintainState: true,
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: _handleFieldChange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote Token Field
                TextFormField(
                  controller: _quoteTokenController,
                  decoration: InputDecoration(
                    labelText: 'Quote Token (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // Optional field
                    }
                    return validateTokenSymbol(value.trim());
                  },
                ),
                SizedBox(height: 16),
                // Profits Threshold Field
                TextFormField(
                  controller: _profitsThresholdController,
                  decoration: InputDecoration(
                    labelText: 'Profits Threshold (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // Optional field
                    }
                    double? parsed = double.tryParse(value.trim());
                    if (parsed == null) {
                      return 'Enter a valid number';
                    }
                    return validateProfitsThreshold(parsed.toString());
                  },
                ),
                SizedBox(height: 16),
                // Profits Take Percentage Field
                TextFormField(
                  controller: _profitsTakePercentController,
                  decoration: InputDecoration(
                    labelText: 'Profits Take % (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // Optional field
                    }
                    double? parsed = double.tryParse(value.trim());
                    if (parsed == null) {
                      return 'Enter a valid number';
                    }
                    return validateProfitsTakePercent(parsed.toString());
                  },
                ),
                SizedBox(height: 16),
                // USD Allocation Field
                TextFormField(
                  controller: _usdAllocationController,
                  decoration: InputDecoration(
                    labelText: 'USD Allocation (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // Optional field
                    }
                    double? parsed = double.tryParse(value.trim());
                    if (parsed == null) {
                      return 'Enter a valid number';
                    }
                    return validateUsdAllocation(parsed.toString());
                  },
                ),
                SizedBox(height: 16),
                // Max Token Market Price Field
                TextFormField(
                  controller: _maxTokenMarketPriceController,
                  decoration: InputDecoration(
                    labelText: 'Max Token Market Price (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null; // Optional field
                    }
                    double? parsed = double.tryParse(value.trim());
                    if (parsed == null) {
                      return 'Enter a valid number';
                    }
                    return validateMaxTokenMarketPrice(parsed.toString());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

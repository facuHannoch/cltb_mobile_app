// File: lib/src/widgets/order_form.dart

import 'package:cltb_mobile_app/models/buy_order.dart';
import 'package:cltb_mobile_app/utils/time_utils.dart';
import 'package:cltb_mobile_app/widgets/ticker_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/cex_order.dart';
import '../models/dex_order.dart';
import '../providers/orders_provider.dart';
import '../utils/validators.dart';
import 'custom_dropdown.dart';
import 'order_list_view.dart';
import 'extra_config_section.dart';

/// A reusable widget for creating and submitting Centralized Exchange (CEX) orders.
///
/// [onSubmit] is a callback function that receives the [CEXOrder] object upon form submission.
/// [includeExtraConfig] determines whether the extra configuration section is displayed.
class CEXOrderForm extends ConsumerStatefulWidget {
  final Function(CEXOrder) onSubmit;
  final bool includeExtraConfig;

  const CEXOrderForm({
    Key? key,
    required this.onSubmit,
    this.includeExtraConfig = false,
  }) : super(key: key);

  @override
  _CEXOrderFormState createState() => _CEXOrderFormState();
}

class _CEXOrderFormState extends ConsumerState<CEXOrderForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  // String _ticker = '';
  String _exchange = 'gateio';
  String _customExchange = '';
  DateTime _launchDate = DateTime.now().toUtc();
  TimeOfDay _launchTime = TimeOfDay.now();
  List<BuyOrder> _buyOrders = [];
  // Extra configuration fields
  String _quoteToken = '';
  double _profitsThreshold = 0.0;
  double _profitsTakePercent = 0.0;
  double _usdAllocation = 0.0;
  double _maxTokenMarketPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // _buyOrders.add(); // TODO: Add default orders
    _launchDate = getDefaultLaunchDate();
    _launchTime =
        TimeOfDay.fromDateTime(roundTimeToNearestHour(DateTime.now().toUtc()));
  }

  /// Validates the form and returns true if valid, else false.
  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  /// Handles the form submission process.
  void _handleSubmit() {
    if (_validateForm()) {
      _formKey.currentState?.save();
      final now = DateTime.now();
      final launchTime = DateTime(
        _launchDate.year,
        _launchDate.month,
        _launchDate.day,
        _launchTime.hour,
        _launchTime.minute,
        0,  // second
        0   // millisecond
      );
      // TODO: fix things with times

      // Construct CEXOrder object
      CEXOrder order = CEXOrder(
        ticker: _tickerController.text,
        exchange: _exchange == 'Other' ? _customExchange : _exchange,
        // launchDate: _launchDate,
        launchTime: launchTime,
        buyOrders: _buyOrders,
        // Extra configuration
        quoteToken: _quoteToken,
        profitsThreshold: _profitsThreshold,
        profitsTakePercent: _profitsTakePercent,
        usdAllocation: _usdAllocation,
        maxTokenMarketPrice: _maxTokenMarketPrice,
      );

      // Invoke the callback with the constructed order
      widget.onSubmit(order);
    } else {
      Fluttertoast.showToast(msg: 'Please fix the errors in the form.');
    }
  }

  TextEditingController _tickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Ticker or Symbol
            TickerTextField(controller: _tickerController),
            SizedBox(height: 16),
            // Exchange Dropdown
            CustomDropdown(
              label: 'Exchange',
              options: ['gateio', 'kucoin', 'poloniex', 'lbank', 'other'],
              initialValue: _exchange,
              onChanged: (value) {
                setState(() {
                  _exchange = value;
                });
              },
              onOtherChanged: (value) {
                setState(() {
                  _customExchange = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Launch Date and Time
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _launchDate,
                        firstDate: DateTime.now().toUtc(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _launchDate = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Launch Date (UTC)'),
                        controller: TextEditingController(
                          text: formatDate(_launchDate),
                        ),
                        validator: (value) => validateLaunchDate(_launchDate),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _launchTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _launchTime = picked;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Launch Time (UTC)'),
                        controller: TextEditingController(
                          text: _launchTime.format(context),
                        ),
                        validator: (value) => validateLaunchTime(_launchTime),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Display Local and UTC Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Local Time: ${getCurrentLocalTimeString()}'),
                Text('UTC Time: ${getCurrentUtcTimeString()}'),
              ],
            ),
            SizedBox(height: 16),
            // Buy Orders List
            OrderListView(
              buyOrders: _buyOrders,
              onBuyOrdersChanged: (updatedOrders) {
                setState(() {
                  _buyOrders = updatedOrders;
                });
              },
            ),
            SizedBox(height: 16),
            // Extra Configuration Section
            if (widget.includeExtraConfig)
              ExtraConfigSection(
                quoteToken: _quoteToken,
                profitsThreshold: _profitsThreshold,
                profitsTakePercent: _profitsTakePercent,
                usdAllocation: _usdAllocation,
                maxTokenMarketPrice: _maxTokenMarketPrice,
                onQuoteTokenChanged: (value) {
                  setState(() {
                    _quoteToken = value;
                  });
                },
                onProfitsThresholdChanged: (value) {
                  setState(() {
                    _profitsThreshold = value;
                  });
                },
                onProfitsTakePercentChanged: (value) {
                  setState(() {
                    _profitsTakePercent = value;
                  });
                },
                onUsdAllocationChanged: (value) {
                  setState(() {
                    _usdAllocation = value;
                  });
                },
                onMaxTokenMarketPriceChanged: (value) {
                  setState(() {
                    _maxTokenMarketPrice = value;
                  });
                },
              ),
            SizedBox(height: 24),
            // Submit Button
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget for creating and submitting Decentralized Exchange (DEX) orders.
///
/// [onSubmit] is a callback function that receives the [DEXOrder] object upon form submission.
class DEXOrderForm extends ConsumerStatefulWidget {
  final Function(DEXOrder) onSubmit;

  const DEXOrderForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _DEXOrderFormState createState() => _DEXOrderFormState();
}

class _DEXOrderFormState extends ConsumerState<DEXOrderForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _tokenAddress = '';
  String _network = 'SOL';
  String _customNetwork = '';
  String? _dex;
  double? _quantity;

  @override
  void initState() {
    super.initState();
    // Initialize default values if necessary
  }

  /// Validates the form and returns true if valid, else false.
  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  /// Handles the form submission process.
  void _handleSubmit() {
    print("Hallo");
    if (_validateForm()) {
      _formKey.currentState?.save();

      // Construct DEXOrder object
      DEXOrder order = DEXOrder(
        tokenAddress: _tokenAddress,
        network: _network == 'Other' ? _customNetwork : _network,
        dex: _dex,
        quantity: _quantity,
      );

      // Invoke the callback with the constructed order
      widget.onSubmit(order);
    } else {
      Fluttertoast.showToast(msg: 'Please fix the errors in the form.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Token Address
          TextFormField(
            decoration: InputDecoration(labelText: 'Token Address'),
            validator: validateTokenAddress,
            onSaved: (value) => _tokenAddress = value!.trim(),
          ),
          SizedBox(height: 16),
          // Network Dropdown
          CustomDropdown(
            label: 'Network',
            options: ['SOL', 'BSC', 'BASE', 'ARB', 'Other'],
            initialValue: _network,
            onChanged: (value) {
              setState(() {
                _network = value;
              });
            },
            onOtherChanged: (value) {
              setState(() {
                _customNetwork = value;
              });
            },
          ),
          SizedBox(height: 16),
          // Dex (Optional)
          TextFormField(
            decoration: InputDecoration(labelText: 'DEX (Optional)'),
            onSaved: (value) => _dex = value?.trim(),
          ),
          SizedBox(height: 16),
          // Quantity (Optional)
          TextFormField(
            decoration: InputDecoration(labelText: 'Quantity (Optional)'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) =>
                value == null || value.isEmpty ? null : validateQuantity(value),
            onSaved: (value) => _quantity =
                value == null || value.isEmpty ? null : double.parse(value),
          ),
          SizedBox(height: 24),
          // Submit Button
          ElevatedButton(
            onPressed: _handleSubmit,
            style: ButtonStyle(


    ),

            child: Text('Submit DEX Order'),
          ),
        ],
      ),
    );
  }
}

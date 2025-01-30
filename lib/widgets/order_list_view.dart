// File: lib/src/widgets/order_list_view.dart

import 'package:cltb_mobile_app/models/buy_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/cex_order.dart';
import '../utils/validators.dart';

/// A reusable widget that manages a dynamic list of buy orders within the CEXOrderForm.
///
/// Parameters:
/// - [buyOrders]: The current list of BuyOrder objects to display.
/// - [onBuyOrdersChanged]: Callback function triggered when the buyOrders list is modified.
class OrderListView extends ConsumerStatefulWidget {
  final List<BuyOrder> buyOrders;
  final Function(List<BuyOrder>) onBuyOrdersChanged;

  const OrderListView({
    Key? key,
    required this.buyOrders,
    required this.onBuyOrdersChanged,
  }) : super(key: key);

  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<OrderListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Add Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Buy Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addBuyOrder,
              icon: Icon(Icons.add),
              label: Text('Add Order'),
            ),
          ],
        ),
        SizedBox(height: 16),
        // List of Buy Orders
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.buyOrders.length,
          itemBuilder: (context, index) {
            return BuyOrderItem(
              buyOrder: widget.buyOrders[index],
              onRemove: () => _removeBuyOrder(index),
              onUpdate: (updatedOrder) => _updateBuyOrder(index, updatedOrder),
            );
          },
        ),
      ],
    );
  }

  /// Adds a new BuyOrder with default values to the list.
  void _addBuyOrder() {
    setState(() {
      widget.buyOrders.add(
        BuyOrder(
          price: null,
          quoteTokenTotal: 0.0,
          orderType: 'limit',
          orderId: '',
          size: 0.0,
        ),
      );
      widget.onBuyOrdersChanged(widget.buyOrders);
    });
    Fluttertoast.showToast(msg: 'Buy order added.');
  }

  /// Removes the BuyOrder at the specified index from the list.
  void _removeBuyOrder(int index) {
    setState(() {
      widget.buyOrders.removeAt(index);
      widget.onBuyOrdersChanged(widget.buyOrders);
    });
    Fluttertoast.showToast(msg: 'Buy order removed.');
  }

  /// Updates the BuyOrder at the specified index with the provided updatedOrder.
  void _updateBuyOrder(int index, BuyOrder updatedOrder) {
    setState(() {
      widget.buyOrders[index] = updatedOrder;
      widget.onBuyOrdersChanged(widget.buyOrders);
    });
  }
}

/// A widget representing an individual BuyOrder item within the OrderListView.
///
/// Parameters:
/// - [buyOrder]: The BuyOrder object containing the order details.
/// - [onRemove]: Callback function triggered when the order is to be removed.
/// - [onUpdate]: Callback function triggered when the order is updated.
class BuyOrderItem extends StatefulWidget {
  final BuyOrder buyOrder;
  final VoidCallback onRemove;
  final Function(BuyOrder) onUpdate;

  const BuyOrderItem({
    Key? key,
    required this.buyOrder,
    required this.onRemove,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _BuyOrderItemState createState() => _BuyOrderItemState();
}

class _BuyOrderItemState extends State<BuyOrderItem> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _priceController;
  late TextEditingController _quoteTokenTotalController;
  late TextEditingController _orderIdController;
  late TextEditingController _sizeController;
  String _orderType = 'limit';

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _quoteTokenTotalController = TextEditingController();
    _orderIdController = TextEditingController();
    _sizeController = TextEditingController();
    _orderType = widget.buyOrder.orderType;

    if (widget.buyOrder.price != null) {
      _priceController.text = widget.buyOrder.price!.toStringAsFixed(4);
      _quoteTokenTotalController.text =
          widget.buyOrder.quoteTokenTotal?.toStringAsFixed(2) ?? '';
      if (widget.buyOrder.orderId?.isNotEmpty ?? false) {
        _orderIdController.text = widget.buyOrder.orderId!;
      }
      _sizeController.text = widget.buyOrder.size?.toStringAsFixed(4) ?? '';
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _quoteTokenTotalController.dispose();
    _orderIdController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  /// Validates the form and updates the BuyOrder if valid.
  void _validateAndSave() {
    if (double.tryParse(_quoteTokenTotalController.text) ==
        double.tryParse(_sizeController.text)) {
      Fluttertoast.showToast(
          msg: 'Either Quote token total or size must be set');
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      BuyOrder updatedOrder = BuyOrder(
        price: double.parse(_priceController.text),
        quoteTokenTotal: double.tryParse(_quoteTokenTotalController.text),
        orderType: _orderType,
        orderId:
            _orderIdController.text.isNotEmpty ? _orderIdController.text : null,
        size: double.tryParse(_sizeController.text),
      );
      widget.onUpdate(updatedOrder);
      Fluttertoast.showToast(msg: 'Buy order updated.');
    } else {
      Fluttertoast.showToast(msg: 'Please fix the errors in the buy order.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          onChanged: _validateAndSave,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Remove Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${widget.buyOrder.orderId?.isNotEmpty ?? true ? widget.buyOrder.orderId : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: validatePrice,
                onSaved: (value) {
                  // Price is already handled by the controller
                },
              ),
              SizedBox(height: 16),
              // Quote Token Total Field
              TextFormField(
                controller: _quoteTokenTotalController,
                decoration: InputDecoration(
                  labelText: 'Quote Token Total',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: validateQuoteTokenTotal,
                onSaved: (value) {
                  // Quote Token Total is already handled by the controller
                },
              ),
              SizedBox(height: 16),
              // Order Type Dropdown
              ExpansionTile(
                title: Text("Extra configuration"),
                maintainState: true,
                children: [
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _orderType,
                    decoration: InputDecoration(
                      labelText: 'Order Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ['market', 'limit']
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type.capitalize()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _orderType = value;
                        });
                        _validateAndSave();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an order type.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  // Order ID Field
                  TextFormField(
                    controller: _orderIdController,
                    decoration: InputDecoration(
                      labelText: 'Order ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      // No validation as per requirements
                      return null;
                    },
                    onSaved: (value) {
                      // Order ID is already handled by the controller
                    },
                  ),
                  SizedBox(height: 16),
                  // Size Field
                  TextFormField(
                    controller: _sizeController,
                    decoration: InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    // validator: validateSize,
                    onSaved: (value) {
                      // Size is already handled by the controller
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension method on String to capitalize the first letter.
extension StringCasingExtension on String {
  String capitalize() {
    if (this.length == 0) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

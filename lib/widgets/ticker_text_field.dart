import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom TextInputFormatter that converts all input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class TickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final String labelText;
  final String hintText;

  /// Creates a TickerTextField
  ///
  /// [controller] manages the text being edited.
  /// [maxLength] sets the maximum number of characters allowed (default is 5)
  /// [labelText] and [hintText] provide descriptive text for the field
  const TickerTextField({
    Key? key,
    required this.controller,
    this.maxLength = 5,
    this.labelText = 'Ticker Symbol',
    this.hintText = 'Enter ticker (e.g., BTC)',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
        UpperCaseTextFormatter(),
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(),
        counterText: '',
      ),
      style: TextStyle(
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

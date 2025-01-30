// File: lib/src/widgets/custom_dropdown.dart

import 'package:flutter/material.dart';

/// A customizable dropdown widget that includes an "Other" option.
/// When "Other" is selected, a text input field is displayed for custom entries.
///
/// Parameters:
/// - [label]: The label displayed above the dropdown.
/// - [options]: A list of predefined options to display.
/// - [initialValue]: The initially selected value in the dropdown.
/// - [onChanged]: Callback triggered when a different option is selected.
/// - [onOtherChanged]: Callback triggered when the custom input value changes.
class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final String initialValue;
  final Function(String) onChanged;
  final Function(String) onOtherChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.options,
    required this.initialValue,
    required this.onChanged,
    required this.onOtherChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _selectedValue;
  bool _isOtherSelected = false;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    if (_selectedValue.toLowerCase() == 'other') {
      _isOtherSelected = true;
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  /// Handles changes in the dropdown selection.
  void _handleDropdownChange(String? value) {
    if (value == null) return;
    setState(() {
      _selectedValue = value;
      if (value.toLowerCase() == 'other') {
        _isOtherSelected = true;
      } else {
        _isOtherSelected = false;
        // Clear custom input if not in "Other" mode
        _customController.clear();
      }
    });
    widget.onChanged(value);
  }

  /// Handles changes in the custom input text field.
  void _handleCustomInputChange(String value) {
    widget.onOtherChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _handleDropdownChange,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option.';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        if (_isOtherSelected)
          TextFormField(
            controller: _customController,
            decoration: InputDecoration(
              labelText: 'Please specify',
              border: OutlineInputBorder(),
            ),
            onChanged: _handleCustomInputChange,
            validator: (value) {
              if (_isOtherSelected) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a value.';
                }
                if (value.trim().length > 50) {
                  return 'Value cannot exceed 50 characters.';
                }
              }
              return null;
            },
          ),
      ],
    );
  }
}

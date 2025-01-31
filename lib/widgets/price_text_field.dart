import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
/// A custom TextFormField widget for price inputs with a '$' prefix.
///
/// This widget can be extended with additional functionalities as needed.
class PriceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final bool readOnly;
  final TextInputType keyboardType;

  const PriceTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.readOnly = false,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: '\$ ',
        border: OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: keyboardType,
    );
  }
}


// /// A custom TextFormField widget for price inputs with a '$' prefix,
// /// thousand separators, and differentiated decimal styling.
// ///
// /// This widget formats the input for display while preserving the raw numerical value.
// class PriceTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final String labelText;
//   final String? Function(String?)? validator;
//   final void Function(double?)? onSaved;
//   final void Function(double?)? onChanged;
//   final bool readOnly;
//   final TextInputType keyboardType;

//   const PriceTextField({
//     super.key,
//     this.controller,
//     required this.labelText,
//     this.validator,
//     this.onSaved,
//     this.onChanged,
//     this.readOnly = false,
//     this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
//   });

//   @override
//   PriceTextFieldState createState() => PriceTextFieldState();
// }

// class PriceTextFieldState extends State<PriceTextField> {
//   late PriceTextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller is PriceTextEditingController
//         ? widget.controller as PriceTextEditingController
//         : PriceTextEditingController(
//             onValueChanged: (value) {
//               if (widget.onChanged != null) {
//                 widget.onChanged!(value);
//               }
//             },
//           );
//   }

//   @override
//   void dispose() {
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: _controller,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         border: OutlineInputBorder(),
//       ),
//       readOnly: widget.readOnly,
//       keyboardType: widget.keyboardType,
//       validator: widget.validator,
//       onSaved: (value) {
//         if (widget.onSaved != null) {
//           widget.onSaved!(_controller.rawValue);
//         }
//       },
//       // The display is handled by the controller's buildTextSpan
//       // So, no need to handle onChanged here
//     );
//   }
// }


// /// A custom TextEditingController for formatting price inputs with thousand separators
// /// and differentiating the decimal part.
// ///
// /// It ensures that the displayed text is formatted (e.g., $100,000.94),
// /// while preserving the raw numerical value for data submission.
// class PriceTextEditingController extends TextEditingController {
//   final NumberFormat _formatter = NumberFormat('#,##0.###', 'en_US');
//   final Function(double?)? onValueChanged;

//   double? rawValue;

//   PriceTextEditingController({this.onValueChanged}) {
//     // Initialize rawValue based on the initial text
//     rawValue = _parseText(text);
//     addListener(_formatText);
//   }

//   /// Parses the formatted text to extract the numerical value.
//   double? _parseText(String text) {
//     try {
//       String cleanedText = text.replaceAll(',', '').replaceAll('\$', '').trim();
//       return double.parse(cleanedText);
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Formats the text with thousand separators and updates the rawValue.
//   void _formatText() {
//     // Avoid formatting if the text is already formatted
//     String currentText = _formatter.format(rawValue ?? 0);
//     String newText = text.replaceAll(',', '').replaceAll('\$', '').trim();

//     // Prevent unnecessary updates
//     if (newText != (rawValue?.toString() ?? '')) {
//       rawValue = _parseText(text);
//       if (onValueChanged != null) {
//         onValueChanged!(rawValue);
//       }
//     }
//   }

//   @override
//   TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
//     // Format the text with thousand separators
//     String formattedText = _formatter.format(rawValue ?? 0);

//     // Split into integer and decimal parts
//     List<String> parts = formattedText.split('.');
//     String integerPart = parts[0];
//     String decimalPart = parts.length > 1 ? '.' + parts[1] : '';

//     return TextSpan(
//       children: [
//         TextSpan(text: '\$ $integerPart', style: style),
//         TextSpan(
//           text: decimalPart,
//           style: style?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     removeListener(_formatText);
//     super.dispose();
//   }
// }

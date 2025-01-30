// lib/src/widgets/json_preview_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/json_formatter.dart';

/// A reusable widget that displays formatted JSON data in a popup dialog
/// with a "Submit" button. It allows users to review the JSON payload
/// before sending it to the server.
class JsonPreviewPopup extends StatelessWidget {
  /// The JSON string to be displayed in a formatted manner.
  final String jsonData;

  /// Callback function invoked when the "Submit" button is pressed.
  final VoidCallback onSubmit;

  /// The title of the popup dialog.
  final String title;

  /// Creates a [JsonPreviewPopup].
  ///
  /// [jsonData] and [onSubmit] are required.
  /// [title] defaults to 'JSON Preview' if not provided.
  const JsonPreviewPopup({
    Key? key,
    required this.jsonData,
    required this.onSubmit,
    this.title = 'JSON Preview',
  }) : super(key: key);

  /// Displays the [JsonPreviewPopup] as a modal dialog.
  ///
  /// - [context]: The build context to display the dialog.
  /// - [jsonData]: The JSON string to be displayed.
  /// - [onSubmit]: Callback function for the "Submit" action.
  /// - [title]: The dialog title. Defaults to 'JSON Preview'.
  static Future<void> show(
    BuildContext context, {
    required String jsonData,
    required VoidCallback onSubmit,
    String title = 'JSON Preview',
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return JsonPreviewPopup(
          jsonData: jsonData,
          onSubmit: onSubmit,
          title: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedJson;
    try {
      formattedJson = JsonFormatter.formatJson(jsonData);
    } catch (e) {
      formattedJson = 'Invalid JSON data';
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: SelectableText(
          formattedJson,
          style: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigator.of(context).pop(); // Dismiss the dialog
            onSubmit(); // Invoke the submit callback
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

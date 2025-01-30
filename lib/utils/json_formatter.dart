// lib/src/utils/json_formatter.dart

import 'dart:convert';

/// A utility class for formatting JSON strings.
class JsonFormatter {
  /// Formats a raw JSON string into a prettified version with indentation.
  ///
  /// ## Parameters
  /// - [jsonString]: The raw JSON string to be formatted.
  ///
  /// ## Returns
  /// - A prettified JSON string with proper indentation.
  ///
  /// ## Throws
  /// - [FormatException]: If the input string is not valid JSON.
  static String formatJson(String jsonString) {
    try {
      final dynamic jsonObject = jsonDecode(jsonString);
      final JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonObject);
    } on FormatException catch (e) {
      // Rethrow the exception to be handled by the caller
      throw FormatException('Invalid JSON string: ${e.message}');
    }
  }
}

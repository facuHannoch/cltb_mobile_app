// lib/src/utils/validators.dart

/// A collection of validation functions for various input fields in the application.
/// Each function returns `null` if the input is valid or an error message `String` if invalid.

import 'dart:convert';
import 'package:flutter/material.dart';

/// Validates that the token symbol is non-empty, uppercase, and does not exceed 12 characters.
String? validateTokenSymbol(String? symbol) {
  if (symbol == null || symbol.trim().isEmpty) {
    return 'El símbolo del token no puede estar vacío.';
  }
  final trimmedSymbol = symbol.trim();
  final regex = RegExp(r'^[A-Z0-9]{1,12}$');
  if (!regex.hasMatch(trimmedSymbol)) {
    return 'El símbolo debe tener hasta 12 caracteres alfanuméricos en mayúsculas.';
  }
  return null;
}

/// Validates the selected exchange. If 'Other' is selected, ensures custom exchange is provided and valid.
String? validateExchange(String? exchange, {String? customExchange}) {
  if (exchange == null || exchange.trim().isEmpty) {
    return 'Debe seleccionar un exchange.';
  }
  if (exchange == 'Other') {
    if (customExchange == null || customExchange.trim().isEmpty) {
      return 'Debe proporcionar el nombre del exchange personalizado.';
    }
    if (customExchange.trim().length > 30) {
      return 'El nombre del exchange personalizado no debe exceder 30 caracteres.';
    }
  }
  return null;
}

/// Validates that the launch date is not in the past.
String? validateLaunchDate(DateTime? launchDate) {
  if (launchDate == null) {
    return 'Debe seleccionar una fecha de lanzamiento.';
  }
  final now = DateTime.now().toUtc();
  final selectedDate = DateTime.utc(
    launchDate.year,
    launchDate.month,
    launchDate.day,
  );
  final currentDate = DateTime.utc(now.year, now.month, now.day);
  if (selectedDate.isBefore(currentDate)) {
    return 'La fecha de lanzamiento no puede ser en el pasado.';
  }
  return null;
}

/// Validates that the launch time is provided.
String? validateLaunchTime(TimeOfDay? launchTime) {
  if (launchTime == null) {
    return 'Debe seleccionar una hora de lanzamiento.';
  }
  return null;
}

/// Validates that the price is a valid float with up to 8 decimal places.
String? validatePrice(String? price) {
  if (price == null || price.trim().isEmpty) {
    return 'El precio no puede estar vacío.';
  }
  final parsedPrice = double.tryParse(price.trim());
  if (parsedPrice == null) {
    return 'El precio debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,8})?$');
  if (!regex.hasMatch(price.trim())) {
    return 'El precio puede tener hasta 8 decimales.';
  }
  return null;
}

/// Validates that the quote token total is a valid float with up to 2 decimal places.
String? validateQuoteTokenTotal(String? total) {
  if (total == null || total.trim().isEmpty) {
    return 'El total del token de cotización no puede estar vacío.';
  }
  final parsedTotal = double.tryParse(total.trim());
  if (parsedTotal == null) {
    return 'El total del token de cotización debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,2})?$');
  if (!regex.hasMatch(total.trim())) {
    return 'El total del token de cotización puede tener hasta 2 decimales.';
  }
  return null;
}

/// Validates that the order type is either 'market' or 'limit'.
String? validateOrderType(String? type) {
  if (type == null || type.trim().isEmpty) {
    return 'Debe seleccionar el tipo de orden.';
  }
  if (type != 'market' && type != 'limit') {
    return 'El tipo de orden debe ser "market" o "limit".';
  }
  return null;
}

/// Validates that the size is a valid float with up to 8 decimal places.
String? validateSize(String? size) {
  if (size == null) return null;
  // if (size == null || size.trim().isEmpty) {
  //   return 'El tamaño no puede estar vacío.';
  // }
  final parsedSize = double.tryParse(size.trim());
  if (parsedSize == null) {
    return 'El tamaño debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,8})?$');
  if (!regex.hasMatch(size.trim())) {
    return 'El tamaño puede tener hasta 8 decimales.';
  }
  return null;
}

/// Validates the token address. (Currently not implemented)
String? validateTokenAddress(String? address) {
  // Placeholder for future address validation logic.
  // Currently, no validation is performed.
  return null;
}

/// Validates the selected network. If 'Other' is selected, ensures custom network is provided and valid.
String? validateNetwork(String? network, {String? customNetwork}) {
  if (network == null || network.trim().isEmpty) {
    return 'Debe seleccionar una red.';
  }
  if (network == 'Other') {
    if (customNetwork == null || customNetwork.trim().isEmpty) {
      return 'Debe proporcionar el nombre de la red personalizada.';
    }
    if (customNetwork.trim().length > 30) {
      return 'El nombre de la red personalizada no debe exceder 30 caracteres.';
    }
  }
  return null;
}

/// Validates that the quantity is a valid float with up to 8 decimal places. Optional field.
String? validateQuantity(String? quantity) {
  if (quantity == null || quantity.trim().isEmpty) {
    // Optional field; no validation needed if empty.
    return null;
  }
  final parsedQuantity = double.tryParse(quantity.trim());
  if (parsedQuantity == null) {
    return 'La cantidad debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,8})?$');
  if (!regex.hasMatch(quantity.trim())) {
    return 'La cantidad puede tener hasta 8 decimales.';
  }
  return null;
}

/// Validates that the USD amount is a valid float with up to 1 decimal place.
String? validateUsdAmount(String? amount) {
  if (amount == null || amount.trim().isEmpty) {
    return 'La cantidad en USD no puede estar vacía.';
  }
  final parsedAmount = double.tryParse(amount.trim());
  if (parsedAmount == null) {
    return 'La cantidad en USD debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1})?$');
  if (!regex.hasMatch(amount.trim())) {
    return 'La cantidad en USD puede tener hasta 1 decimal.';
  }
  return null;
}

/// Validates that the profits threshold is a valid float with up to 3 decimal places.
String? validateProfitsThreshold(String? threshold) {
  if (threshold == null || threshold.trim().isEmpty) {
    return 'El umbral de ganancias no puede estar vacío.';
  }
  final parsedThreshold = double.tryParse(threshold.trim());
  if (parsedThreshold == null) {
    return 'El umbral de ganancias debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,3})?$');
  if (!regex.hasMatch(threshold.trim())) {
    return 'El umbral de ganancias puede tener hasta 3 decimales.';
  }
  return null;
}

/// Validates that the profits take percentage is between 0 and 100.
String? validateProfitsTakePercent(String? percent) {
  if (percent == null || percent.trim().isEmpty) {
    return 'El porcentaje de toma de ganancias no puede estar vacío.';
  }
  final parsedPercent = double.tryParse(percent.trim());
  if (parsedPercent == null) {
    return 'El porcentaje de toma de ganancias debe ser un número válido.';
  }
  if (parsedPercent < 0 || parsedPercent > 100) {
    return 'El porcentaje de toma de ganancias debe estar entre 0 y 100.';
  }
  return null;
}

/// Validates that the USD allocation is a valid float with up to 3 decimal places.
String? validateUsdAllocation(String? allocation) {
  if (allocation == null || allocation.trim().isEmpty) {
    return 'La asignación en USD no puede estar vacía.';
  }
  final parsedAllocation = double.tryParse(allocation.trim());
  if (parsedAllocation == null) {
    return 'La asignación en USD debe ser un número válido.';
  }
  final regex = RegExp(r'^\d+(\.\d{1,3})?$');
  if (!regex.hasMatch(allocation.trim())) {
    return 'La asignación en USD puede tener hasta 3 decimales.';
  }
  return null;
}

/// Validates that the maximum token market price is a valid float.
String? validateMaxTokenMarketPrice(String? price) {
  if (price == null || price.trim().isEmpty) {
    return 'El precio máximo del mercado del token no puede estar vacío.';
  }
  final parsedPrice = double.tryParse(price.trim());
  if (parsedPrice == null) {
    return 'El precio máximo del mercado del token debe ser un número válido.';
  }
  // Additional constraints can be added here if necessary.
  return null;
}

/// Validates that the provided string is a well-formed JSON.
String? validateJsonInstructions(String? jsonString) {
  if (jsonString == null || jsonString.trim().isEmpty) {
    return 'Las instrucciones JSON no pueden estar vacías.';
  }
  try {
    jsonDecode(jsonString.trim());
    return null;
  } catch (e) {
    return 'Las instrucciones JSON no son válidas.';
  }
}
String? validatePort(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  if (value.length <= 2 || value.length > 6) {
    return 'length must be between 3 and 6';
  }

  return null;
}

String? validateIpAddress(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  // Regular expression for IPv4
  final ipv4Regex = RegExp(
      r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.){3}(25[0-5]|(2[0-4]|1\d|[1-9]|)\d)$');
  // Regular expression for IPv6
  final ipv6Regex = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:))|'
      r'(([0-9a-fA-F]{1,4}:){1,7}:)|'
      r'(([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})|'
      r'(([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2})|'
      r'(([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3})|'
      r'(([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4})|'
      r'(([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5})|'
      r'([0-9a-fA-F]{1,4}:)((:[0-9a-fA-F]{1,4}){1,6})$');

  if (ipv4Regex.hasMatch(value)) {
    return null;
  } else if (ipv6Regex.hasMatch(value)) {
    return null;
  } else {
    return 'Enter a valid IPv4 or IPv6 address';
  }
}

String? validateUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }

  // Regular expression for IPv4
  final ipv4Regex = r'((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.){3}(25[0-5]|(2[0-4]|1\d|[1-9]|)\d)';

  // Regular expression for IPv6
  final ipv6Regex = r'\[([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}\]';

  // Combined IP regex (IPv4 or IPv6)
  final ipRegex = '($ipv4Regex|$ipv6Regex)';

  // Regular expression for URL format
  final urlRegex = RegExp(
      r'^(http|https):\/\/' + // Protocol
          ipRegex + // IP address
          r':\d{1,5}\/?$'); // Port and optional trailing slash

  if (urlRegex.hasMatch(value)) {
    return null; // Valid URL
  } else {
    return 'Enter a valid URL in the format http://ip_address:port/';
  }
}


// String? validateUsdAmount(String? value) {
//   if (value == null || value.isEmpty) {
//     return 'This field cannot be empty';
//   }
//   final usdRegex = RegExp(r'^\d+(\.\d{1})?$');
//   if (!usdRegex.hasMatch(value)) {
//     return 'Enter a valid USD amount (up to 1 decimal place)';
//   }
//   return null;
// }

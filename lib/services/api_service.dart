// lib/src/services/api_service.dart

import 'dart:convert';
import 'package:cltb_mobile_app/models/cex_order.dart';
import 'package:cltb_mobile_app/models/dex_order.dart';
import 'package:cltb_mobile_app/models/pending_launch.dart';
import 'package:cltb_mobile_app/models/quick_buy.dart';
import 'package:cltb_mobile_app/models/user_settings.dart';
import 'package:cltb_mobile_app/services/logger_service.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// TODO: fallback urls are not a "if it is null use this". The code should actually send a request to the url, and use the fallback to retry the request


/// A generic class to standardize API responses.
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  ApiResponse({
    required this.success,
    this.data,
    this.errorMessage,
  });
}

/// Service responsible for handling REST API interactions.
class ApiService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _logger = LoggerService();

  final String? _cexApiUrl;
  final String? _cexApiFallbackUrl;
  final String? _dexApiUrl;
  final String? _dexApiFallbackUrl;
  final String? _quickBuyApiUrl;
  final String? _quickBuyApiFallbackUrl;

  /// Initializes the API service by loading API endpoints from secure storage or user settings.
  ApiService({required UserSettings settings})
      : _cexApiUrl = settings.cexBuyOrderIp,
        _cexApiFallbackUrl = settings.cexBuyOrderFallbackIp,
        _dexApiUrl = settings.dexBuyOrderIp,
        _dexApiFallbackUrl = settings.dexBuyOrderFallbackIp,
        _quickBuyApiUrl = settings.quickBuyIp,
        _quickBuyApiFallbackUrl = settings.quickBuyFallbackIp;

  // /// Sets the API endpoints based on user settings.
  // Future<void> setApiEndpoints(UserSettings settings) async {
  //   _cexApiUrl = settings.cexBuyOrderIp;
  //   _cexApiFallbackUrl = settings.cexBuyOrderFallbackIp;
  //   _dexApiUrl = settings.dexBuyOrderIp;
  //   _dexApiFallbackUrl = settings.dexBuyOrderFallbackIp;
  //   _quickBuyApiUrl = settings.quickBuyIp;
  //   _quickBuyApiFallbackUrl = settings.quickBuyFallbackIp;
  // }

  /// Retrieves the authorization headers using stored credentials.
  Future<Map<String, String>> _getAuthHeaders() async {
    String? key = await _secureStorage.read(key: 'SECRET_KEY');
    String? secret = await _secureStorage.read(key: 'SECRET_SECRET');

    if (key == null || secret == null) {
      _logger.logError('Authorization credentials are missing.');
      throw Exception('Authorization credentials are missing.');
    }

    return {
      'Authorization': 'Bearer $key:$secret',
      'Content-Type': 'application/json',
    };
  }

  /// Sends a POST request to the CEX server with the provided order details.
  Future<ApiResponse> sendCEXOrder(CEXOrder order) async {
    final url = _cexApiUrl ?? _cexApiFallbackUrl;
    if (url == null) {
      _logger.logError('CEX API URL is not set.');
      return ApiResponse(
        success: false,
        errorMessage: 'CEX API URL is not configured.',
      );
    }

    try {
      final headers = await _getAuthHeaders();
      final body = jsonEncode(order.toJson());

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 202) {
        final responseData = jsonDecode(response.body);
        return ApiResponse(
          success: true,
          data: responseData,
        );
      } else {
        _logger.logError(
            'CEX Order Failed: ${response.statusCode} ${response.reasonPhrase}');
        return ApiResponse(
          success: false,
          errorMessage:
              'CEX Order Failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      _logger.logError('CEX Order Exception: $e');
      return ApiResponse(
        success: false,
        errorMessage: 'CEX Order Exception: $e',
      );
    }
  }

  /// Sends a POST request to the DEX server with the provided order details.
  Future<ApiResponse> sendDEXOrder(DEXOrder order) async {
    final url = _dexApiUrl ?? _dexApiFallbackUrl;
    if (url == null) {
      _logger.logError('DEX API URL is not set.');
      return ApiResponse(
        success: false,
        errorMessage: 'DEX API URL is not configured.',
      );
    }

    try {
      final headers = await _getAuthHeaders();
      final body = jsonEncode(order.toJson());

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ApiResponse(
          success: true,
          data: responseData,
        );
      } else {
        _logger.logError(
            'DEX Order Failed: ${response.statusCode} ${response.reasonPhrase}');
        return ApiResponse(
          success: false,
          errorMessage:
              'DEX Order Failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      _logger.logError('DEX Order Exception: $e');
      return ApiResponse(
        success: false,
        errorMessage: 'DEX Order Exception: $e',
      );
    }
  }

  /// Sends a GET request to retrieve the list of pending token launches.
  Future<ApiResponse<List<PendingLaunch>>> getPendingLaunches() async {
    final url = _cexApiUrl != null
        ? '$_cexApiUrl/pending_launches'
        : (_cexApiFallbackUrl != null
            ? '$_cexApiFallbackUrl/pending_launches'
            : null);

    if (url == null) {
      _logger.logError('Pending Launches API URL is not set.');
      return ApiResponse(
        success: false,
        errorMessage: 'Pending Launches API URL is not configured.',
      );
    }

    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final pendingLaunches = responseData
            .map((item) => PendingLaunch.fromJson(item))
            .toList();

        return ApiResponse(
          success: true,
          data: pendingLaunches,
        );
      } else {
        _logger.logError(
            'Get Pending Launches Failed: ${response.statusCode} ${response.reasonPhrase}');
        return ApiResponse(
          success: false,
          errorMessage:
              'Get Pending Launches Failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      _logger.logError('Get Pending Launches Exception: $e');
      return ApiResponse(
        success: false,
        errorMessage: 'Get Pending Launches Exception: $e',
      );
    }
  }

  // Removes a pending launch by taskId
  Future<ApiResponse<void>> removePendingLaunch(int taskId) async {
    final url = Uri.parse('$_cexApiUrl/remove_launch/$taskId'); // Adjust endpoint as needed
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer YOUR_TOKEN'};

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse<void>(success: true);
      } else {
        return ApiResponse<void>(success: false, errorMessage: 'Failed to remove pending launch.');
      }
    } catch (e) {
      return ApiResponse<void>(success: false, errorMessage: e.toString());
    }
  }


  /// Sends a quick buy POST request either via HTTP or WebSocket based on availability.
  Future<ApiResponse> quickBuy(QuickBuyOrder order) async {
    final url = _quickBuyApiUrl ?? _quickBuyApiFallbackUrl;
    if (url == null) {
      _logger.logError('Quick Buy API URL is not set.');
      return ApiResponse(
        success: false,
        errorMessage: 'Quick Buy API URL is not configured.',
      );
    }

    try {
      final headers = await _getAuthHeaders();
      final body = jsonEncode(order.toJson());

      // TODO: Implement ws functionality.
      // It shuold check whether there is an active websocket connection.
      // If there is, the order should be sent via that opened connection.
      // response = null;
      // if (ws_connection) {
      // response =
      // }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ApiResponse(
          success: true,
          data: responseData,
        );
      } else {
        _logger.logError(
            'Quick Buy Failed: ${response.statusCode} ${response.reasonPhrase}');
        return ApiResponse(
          success: false,
          errorMessage:
              'Quick Buy Failed: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      _logger.logError('Quick Buy Exception: $e');
      return ApiResponse(
        success: false,
        errorMessage: 'Quick Buy Exception: $e',
      );
    }
  }
}

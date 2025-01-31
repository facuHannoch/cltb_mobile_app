import 'package:cltb_mobile_app/models/cex_order_data.dart';

/// Enum for Orders Processing Mode
enum OrdersProcessingMode {
  BATCH,
  INDIVIDUAL,
  TIMED,
  WEBSOCKET_BATCH,
  WEBSOCKET_INDIVIDUAL
}

/// Extension to convert string to OrdersProcessingMode enum
extension OrdersProcessingModeExtension on OrdersProcessingMode {
  String get value {
    switch (this) {
      case OrdersProcessingMode.BATCH:
        return "BATCH";
      case OrdersProcessingMode.INDIVIDUAL:
        return "INDIVIDUAL";
      case OrdersProcessingMode.TIMED:
        return "TIMED";
      case OrdersProcessingMode.WEBSOCKET_BATCH:
        return "WEBSOCKET_BATCH";
      case OrdersProcessingMode.WEBSOCKET_INDIVIDUAL:
        return "WEBSOCKET_INDIVIDUAL";
    }
  }

  static OrdersProcessingMode fromString(String mode) {
    switch (mode.toUpperCase()) {
      case "BATCH":
        return OrdersProcessingMode.BATCH;
      case "INDIVIDUAL":
        return OrdersProcessingMode.INDIVIDUAL;
      case "TIMED":
        return OrdersProcessingMode.TIMED;
      case "WEBSOCKET_BATCH":
        return OrdersProcessingMode.WEBSOCKET_BATCH;
      case "WEBSOCKET_INDIVIDUAL":
        return OrdersProcessingMode.WEBSOCKET_INDIVIDUAL;
      default:
        throw ArgumentError("Invalid OrdersProcessingMode: $mode");
    }
  }
}

/// Enum for Logs Policy
enum LogsPolicy { FULL_LOGS, GENERAL_LOGS, NO_LOGS }

/// Extension to convert string to LogsPolicy enum
extension LogsPolicyExtension on LogsPolicy {
  String get value {
    switch (this) {
      case LogsPolicy.FULL_LOGS:
        return "FULL_LOGS";
      case LogsPolicy.GENERAL_LOGS:
        return "GENERAL_LOGS";
      case LogsPolicy.NO_LOGS:
        return "NO_LOGS";
    }
  }

  static LogsPolicy fromString(String policy) {
    switch (policy.toUpperCase()) {
      case "FULL_LOGS":
        return LogsPolicy.FULL_LOGS;
      case "GENERAL_LOGS":
        return LogsPolicy.GENERAL_LOGS;
      case "NO_LOGS":
        return LogsPolicy.NO_LOGS;
      default:
        throw ArgumentError("Invalid LogsPolicy: $policy");
    }
  }
}

class CEXOrder {
  final String ticker; // e.g., 'BTC'
  final String exchange; // e.g., 'Gateio'
  final DateTime? launchDate; // Launch date in UTC
  final DateTime launchTime; // Launch time in UTC
  final List<CEXOrderData> buyOrders; // List of buy orders
  final List<CEXOrderData>
      sellOrders; // List of sell orders (currently not used)
  final String? quoteToken; // Optional
  final double? profitsThreshold;
  final double? profitsTakePercent;
  final double? usdAllocation;
  final double? maxTokenMarketPrice;

  // New fields
  final OrdersProcessingMode ordersProcessingMode;
  final LogsPolicy logsPolicy;

  CEXOrder({
    required this.ticker,
    required this.exchange,
    this.launchDate,
    required this.launchTime,
    required this.buyOrders,
    this.sellOrders = const [],
    this.quoteToken,
    this.profitsThreshold,
    this.profitsTakePercent,
    this.usdAllocation,
    this.maxTokenMarketPrice,
    required this.ordersProcessingMode,
    required this.logsPolicy,
  });

  // Serialization and deserialization methods
  factory CEXOrder.fromJson(Map<String, dynamic> json) => CEXOrder(
        ticker: json['token'],
        exchange: json['exchange'],
        launchDate: json['launch_date'] != null
            ? DateTime.parse(json['launch_date'])
            : null,
        launchTime: json['launch_time'] != null
            ? _parseLaunchTime(json['launch_time'])
            : DateTime.now().toUtc(),
        buyOrders: (json['buy_orders'] as List)
            .map((e) => CEXOrderData.fromJson(e))
            .toList(),
        sellOrders: (json['sell_orders'] as List)
            .map((e) => CEXOrderData.fromJson(e))
            .toList(),
        quoteToken: (json['quote_token'] != null &&
                (json['quote_token'] as String).isNotEmpty)
            ? json['quote_token']
            : 'USDT',
        profitsThreshold: (json['profits_threshold'] as num?)?.toDouble(),
        profitsTakePercent: (json['profits_take_percent'] as num?)?.toDouble(),
        usdAllocation: (json['usd_allocation'] as num?)?.toDouble(),
        maxTokenMarketPrice:
            (json['max_token_market_price'] as num?)?.toDouble(),
        ordersProcessingMode: OrdersProcessingModeExtension.fromString(
            json['orders_processing_mode']),
        logsPolicy: LogsPolicyExtension.fromString(json['logs_policy']),
      );

  Map<String, dynamic> toJson() {
    final formattedLaunchTime =
        "${launchTime.hour.toString().padLeft(2, '0')}:${launchTime.minute.toString().padLeft(2, '0')}:${launchTime.second.toString().padLeft(2, '0')}.${(launchTime.millisecond / 10).floor().toString().padLeft(2, '0')}";
    final formattedLaunchDate =
        "${launchTime.year}-${launchTime.month.toString().padLeft(2, '0')}-${launchTime.day.toString().padLeft(2, '0')}";
    return {
      'token': ticker,
      'exchange': exchange,
      'launch_date': formattedLaunchDate,
      'launch_time': formattedLaunchTime,
      'buy_orders': buyOrders.map((e) => e.toJson()).toList(),
      'sell_orders': sellOrders.map((e) => e.toJson()).toList(),
      // 'quote_token': (quoteToken?.isNotEmpty ?? false) ? quoteToken : 'USDT',
      'quote_token': quoteToken,
      'profits_threshold': profitsThreshold,
      'profits_take_percent': profitsTakePercent,
      'usd_allocation': usdAllocation,
      'max_token_market_price': maxTokenMarketPrice,
      'orders_processing_mode': ordersProcessingMode.value,
      'logs_policy': logsPolicy.value,
    };
  }

  /// Helper method to parse launch_time string to DateTime
  static DateTime _parseLaunchTime(String timeStr) {
    // Assuming the timeStr is in "HH:mm:ss.SS" format
    final parts = timeStr.split(':');
    if (parts.length != 3) {
      throw FormatException("Invalid launch_time format: $timeStr");
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final secondParts = parts[2].split('.');
    final second = int.parse(secondParts[0]);
    final millisecond = secondParts.length > 1
        ? int.parse(("${secondParts[1]}0").substring(0, 2)) * 10
        : 0;
    return DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      hour,
      minute,
      second,
      millisecond,
    );
  }
}

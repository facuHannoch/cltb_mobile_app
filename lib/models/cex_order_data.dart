class CEXOrderData {
  final String? orderId; // Optional, no validation
  final String? token;
  final String? quoteToken;
  final String orderType; // 'market' or 'limit'
  final double? price; // Up to 8 decimal digits
  final double? quoteTokenTotal; // Up to 2 decimal digits
  final double? size; // Optional, up to 8 decimal digits
  final String side;
  final String? timeInForce;

  final DateTime? triggerTime;

  CEXOrderData({
    this.orderId,
    this.token,
    this.quoteToken,
    this.orderType = 'limit',
    this.price,
    this.quoteTokenTotal,
    this.size,
    required this.side,
    this.timeInForce = 'ioc',
    this.triggerTime,
  });

  factory CEXOrderData.fromJson(Map<String, dynamic> json) {
    // Parse the trigger_time string to DateTime
    DateTime parsedTriggerTime;
    try {
      parsedTriggerTime = DateTime.parse(json['triger_time']);
    } catch (e) {
      throw FormatException("Invalid date format for trigger_time: ${json['triger_time']}");
    }

    return CEXOrderData(
      orderId: json['order_id'],
      token: json['token'],
      quoteToken: json['quote_token'],
      orderType: json['type'] ?? 'limit',
      price: (json['price'] as num).toDouble(),
      quoteTokenTotal: (json['quote_token_total'] as num).toDouble(),
      size: json['size'] != null ? (json['size'] as num).toDouble() : null,
      side: json['side'],
      timeInForce: json['time_in_force'],
      triggerTime: parsedTriggerTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'token': token,
      'quote_token': quoteToken,
      'type': orderType,
      'price': price,
      'quote_token_total': quoteTokenTotal,
      'size': size,
      'side': side,
      'time_in_force': timeInForce,
      // Format DateTime to ISO 8601 string
      'triger_time': triggerTime?.toIso8601String(),
    };
  }
}

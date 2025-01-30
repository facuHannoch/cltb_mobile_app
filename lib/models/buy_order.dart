class BuyOrder {
  final double? price; // Up to 8 decimal digits
  final double? quoteTokenTotal; // Up to 2 decimal digits
  final String orderType; // 'market' or 'limit'
  final String? orderId; // Optional, no validation
  final double? size; // Optional, up to 8 decimal digits

  BuyOrder({
    required this.price,
    required this.quoteTokenTotal,
    this.orderType = 'limit',
    this.orderId,
    this.size,
  });

  factory BuyOrder.fromJson(Map<String, dynamic> json) => BuyOrder(
        price: json['price'].toDouble(),
        quoteTokenTotal: json['quote_token_total'].toDouble(),
        orderType: json['type'] ?? 'limit',
        orderId: json['order_id'],
        size: json['size']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'quote_token_total': quoteTokenTotal,
        'type': orderType,
        'order_id': orderId,
        'size': size,
      };
}

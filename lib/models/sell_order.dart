class SellOrder {
  final double price; // Up to 8 decimal digits
  final double quoteTokenTotal; // Up to 2 decimal digits

  SellOrder({
    required this.price,
    required this.quoteTokenTotal,
  });

  factory SellOrder.fromJson(Map<String, dynamic> json) => SellOrder(
        price: json['price'].toDouble(),
        quoteTokenTotal: json['quote_token_total'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'quote_token_total': quoteTokenTotal,
      };
}

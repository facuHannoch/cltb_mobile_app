class QuickBuyOrder {
  final String tokenAddress; // e.g., '0xdf4ee53f498ec863ab74c5ce7de56fd8ea306257'
  final double usdQuantity; // Up to 1 decimal digit

  QuickBuyOrder({
    required this.tokenAddress,
    required this.usdQuantity,
  });

  factory QuickBuyOrder.fromJson(Map<String, dynamic> json) => QuickBuyOrder(
        tokenAddress: json['address'],
        usdQuantity: json['usd_quantity'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'address': tokenAddress,
        'usd_quantity': usdQuantity,
      };
}

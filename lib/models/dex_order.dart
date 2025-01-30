class DEXOrder {
  final String tokenAddress; // e.g., '0xdf4ee53f498ec863ab74c5ce7de56fd8ea306257'
  final String network; // e.g., 'SOL'
  final String? dex; // Optional DEX name
  final double? quantity; // Optional quantity

  DEXOrder({
    required this.tokenAddress,
    required this.network,
    this.dex,
    this.quantity,
  });

  // Serialization and deserialization methods
  factory DEXOrder.fromJson(Map<String, dynamic> json) => DEXOrder(
        tokenAddress: json['address'],
        network: json['network'],
        dex: json['dex'],
        quantity: json['qty']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'address': tokenAddress,
        'network': network,
        'dex': dex,
        'qty': quantity,
      };
}
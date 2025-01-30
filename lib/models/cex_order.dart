import 'package:cltb_mobile_app/models/buy_order.dart';
import 'package:cltb_mobile_app/models/sell_order.dart';

class CEXOrder {
  final String ticker; // e.g., 'BTC'
  final String exchange; // e.g., 'Gateio'
  final DateTime? launchDate; // Launch date in UTC
  final DateTime launchTime; // Launch time in UTC
  final List<BuyOrder> buyOrders; // List of buy orders
  final List<SellOrder> sellOrders; // List of sell orders (currently not used)
  final String? quoteToken; // Optional
  final double? profitsThreshold;
  final double? profitsTakePercent;
  final double? usdAllocation;
  final double? maxTokenMarketPrice;

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
  });

  // Serialization and deserialization methods
  factory CEXOrder.fromJson(Map<String, dynamic> json) => CEXOrder(
        ticker: json['token'],
        exchange: json['exchange'],
        launchDate: DateTime.parse(json['launch_date']),
        launchTime: DateTime.parse(json['launch_time']),
        buyOrders: (json['buy_orders'] as List)
            .map((e) => BuyOrder.fromJson(e))
            .toList(),
        sellOrders: (json['sell_orders'] as List)
            .map((e) => SellOrder.fromJson(e))
            .toList(),
        quoteToken: json['quote_token'],
        profitsThreshold: json['profits_threshold']?.toDouble(),
        profitsTakePercent: json['profits_take_percent']?.toDouble(),
        usdAllocation: json['usd_allocation']?.toDouble(),
        maxTokenMarketPrice: json['max_token_market_price']?.toDouble(),
      );

  Map<String, dynamic> toJson() {
    final formattedLaunchTime =
        "${launchTime.hour.toString().padLeft(2, '0')}:${launchTime.minute.toString().padLeft(2, '0')}:${launchTime.second.toString().padLeft(2, '0')}.${(launchTime.millisecond / 10).floor().toString().padLeft(2, '0')}";
    final formattedLaunchDate =
        "${launchTime.year}-${launchTime.month.toString().padLeft(2, '0')}-${launchTime.day.toString().padLeft(2, '0')}";
    return {
      'token': ticker,
      'exchange': exchange,
      // 'launch_date': launchDate.toIso8601String(),
      // 'launch_time': launchTime.toIso8601String(),
      'launch_date': formattedLaunchDate,
      'launch_time': formattedLaunchTime,
      'buy_orders': buyOrders.map((e) => e.toJson()).toList(),
      'sell_orders': sellOrders.map((e) => e.toJson()).toList(),
      'quote_token': quoteToken?.isNotEmpty ?? false ? quoteToken : 'USDT',
      'profits_threshold': profitsThreshold,
      'profits_take_percent': profitsTakePercent,
      'usd_allocation': usdAllocation,
      'max_token_market_price': maxTokenMarketPrice,
    };
  }
}

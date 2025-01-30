class UserSettings {
  final String cexBuyOrderIp;
  final String? cexBuyOrderFallbackIp;
  final String dexBuyOrderIp;
  final String? dexBuyOrderFallbackIp;
  final String quickBuyIp;
  final String? quickBuyFallbackIp;
  final double defaultUsdQuantityQuickBuy;
  final WebSocketSettings webSocketSettings;

  UserSettings({
    required this.cexBuyOrderIp,
    this.cexBuyOrderFallbackIp,
    required this.dexBuyOrderIp,
    this.dexBuyOrderFallbackIp,
    required this.quickBuyIp,
    this.quickBuyFallbackIp,
    required this.defaultUsdQuantityQuickBuy,
    required this.webSocketSettings,
  });

  // /// Initializes UserSettings with default values.
  // factory UserSettings.initial() {
  //   return UserSettings(
  //       cexBuyOrderIp: 'http://default-cex-api.com',
  //       cexBuyOrderFallbackIp: 'http://fallback-cex-api.com',
  //       dexBuyOrderIp: 'http://default-dex-api.com',
  //       dexBuyOrderFallbackIp: 'http://fallback-dex-api.com',
  //       quickBuyIp: 'http://default-quickbuy-api.com',
  //       quickBuyFallbackIp: 'http://fallback-quickbuy-api.com',
  //       defaultUsdQuantityQuickBuy: 20.0,
  //       webSocketSettings: WebSocketSettings(
  //         primaryUrl: 'http://',
  //       ));
  // }

  /// Creates a copy of UserSettings with updated values.
  UserSettings copyWith({
    String? cexBuyOrderIp,
    String? cexBuyOrderFallbackIp,
    String? dexBuyOrderIp,
    String? dexBuyOrderFallbackIp,
    String? quickBuyIp,
    String? quickBuyFallbackIp,
    double? defaultUsdQuantityQuickBuy,
    WebSocketSettings? webSocketSettings,
  }) {
    return UserSettings(
      cexBuyOrderIp: cexBuyOrderIp ?? this.cexBuyOrderIp,
      cexBuyOrderFallbackIp:
          cexBuyOrderFallbackIp ?? this.cexBuyOrderFallbackIp,
      dexBuyOrderIp: dexBuyOrderIp ?? this.dexBuyOrderIp,
      dexBuyOrderFallbackIp:
          dexBuyOrderFallbackIp ?? this.dexBuyOrderFallbackIp,
      quickBuyIp: quickBuyIp ?? this.quickBuyIp,
      quickBuyFallbackIp: quickBuyFallbackIp ?? this.quickBuyFallbackIp,
      defaultUsdQuantityQuickBuy:
          defaultUsdQuantityQuickBuy ?? this.defaultUsdQuantityQuickBuy,
      webSocketSettings: webSocketSettings ?? this.webSocketSettings,
    );
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        cexBuyOrderIp: json['cex_buy_order_ip'],
        cexBuyOrderFallbackIp: json['cex_buy_order_fallback_ip'],
        dexBuyOrderIp: json['dex_buy_order_ip'],
        dexBuyOrderFallbackIp: json['dex_buy_order_fallback_ip'],
        quickBuyIp: json['quick_buy_ip'],
        quickBuyFallbackIp: json['quick_buy_fallback_ip'],
        defaultUsdQuantityQuickBuy:
            json['default_usd_quantity_quick_buy'].toDouble(),
        webSocketSettings: WebSocketSettings.fromJson(json['websocket']),
      );

  Map<String, dynamic> toJson() => {
        'cex_buy_order_ip': cexBuyOrderIp,
        'cex_buy_order_fallback_ip': cexBuyOrderFallbackIp,
        'dex_buy_order_ip': dexBuyOrderIp,
        'dex_buy_order_fallback_ip': dexBuyOrderFallbackIp,
        'quick_buy_ip': quickBuyIp,
        'quick_buy_fallback_ip': quickBuyFallbackIp,
        'default_usd_quantity_quick_buy': defaultUsdQuantityQuickBuy,
        'websocket': webSocketSettings.toJson(),
      };
}

// class WebSocketSettings {
//   final String primaryUrl;
//   final String? fallbackUrl;

//   WebSocketSettings({
//     required this.primaryUrl,
//     this.fallbackUrl,
//   });

//   factory WebSocketSettings.fromJson(Map<String, dynamic> json) =>
//       WebSocketSettings(
//         primaryUrl: json['primary_url'],
//         fallbackUrl: json['fallback_url'],
//       );

//   Map<String, dynamic> toJson() => {
//         'primary_url': primaryUrl,
//         'fallback_url': fallbackUrl,
//       };
// }

class WebSocketSettings {
  final String primaryUrl;
  final bool isConnected;

  WebSocketSettings({
    required this.primaryUrl,
    this.isConnected = false,
  });

  factory WebSocketSettings.fromJson(Map<String, dynamic> json) =>
      WebSocketSettings(
        primaryUrl: json['primary_url'],
        isConnected: json['is_connected']
      );
    
  Map<String, dynamic> toJson() => {
    'primary_url': primaryUrl,
    'is_connected': isConnected
  };

  WebSocketSettings copyWith({
    String? primaryUrl,
    bool? isConnected,
  }) {
    return WebSocketSettings(
      primaryUrl: primaryUrl ?? this.primaryUrl,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

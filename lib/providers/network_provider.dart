// src/providers/network_provider.dart

import 'package:cltb_mobile_app/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final settings = ref.watch(settingsProvider);

  return ApiService(settings: settings);
});

// Provider for WebSocketService
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

// StreamProvider for WebSocket connection status
final networkStatusProvider = StreamProvider<ConnectionStatus>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.connectionStatus;
});

// Function to connect to WebSocket
Future<void> connectWebSocketProvider(WidgetRef ref, String url) async {
  final webSocketService = ref.read(webSocketServiceProvider);
  await webSocketService.connect(url);
}

// Function to disconnect from WebSocket
void disconnectWebSocketProvider(WidgetRef ref) {
  final webSocketService = ref.read(webSocketServiceProvider);
  webSocketService.disconnect();
}

// Function to send a message via WebSocket
void sendWebSocketMessageProvider(WidgetRef ref, String message) {
  final webSocketService = ref.read(webSocketServiceProvider);
  webSocketService.sendMessage(message);
}

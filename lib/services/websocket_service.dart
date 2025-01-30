// lib/src/services/websocket_service.dart

import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

/// Enum representing the status of the WebSocket connection.
enum ConnectionStatus { connected, disconnected, connecting, error }

/// WebSocketService manages WebSocket connections and messaging.
class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<String> _messageController = StreamController.broadcast();
  final StreamController<ConnectionStatus> _statusController =
      StreamController.broadcast();
  Timer? _reconnectTimer;

  /// Stream of incoming messages from the WebSocket.
  Stream<String> get messages => _messageController.stream;

  /// Stream of connection status updates.
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

  /// Indicates whether the WebSocket is currently connected.
  bool get isConnected => _channel != null;

  bool _isValidWebSocketUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'ws' || uri.scheme == 'wss');
  }


  /// Connects to the WebSocket server at the given [url].
  ///
  /// Throws an exception if the connection fails.
  Future<void> connect(String url) async {
    if (_channel != null) {
      disconnect();
    }
    if (!_isValidWebSocketUrl(url)) {
      throw Exception('Invalid WebSocket URL: $url');
    }

    _statusController.add(ConnectionStatus.connecting);
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _statusController.add(ConnectionStatus.connected);

      _channel!.stream.listen(
        (message) {
          _messageController.add(message);
        },
        onDone: () {
          _statusController.add(ConnectionStatus.disconnected);
          _channel = null;
          _attemptReconnect(url);
        },
        onError: (error) {
          _statusController.add(ConnectionStatus.error);
          _channel = null;
          _attemptReconnect(url);
        },
      );
    } catch (e) {
      _statusController.add(ConnectionStatus.error);
      _channel = null;
      _attemptReconnect(url);
      throw Exception('Failed to connect to WebSocket: $e');
    }
  }

  /// Disconnects the current WebSocket connection gracefully.
  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close(status.goingAway);
    _channel = null;
    _statusController.add(ConnectionStatus.disconnected);
  }

  /// Sends a [message] over the WebSocket connection.
  ///
  /// Throws an exception if not connected.
  void sendMessage(String message) {
    // TODO: Sending a message could return a response
    if (_channel != null) {
      _channel!.sink.add(message);
    } else {
      throw Exception('WebSocket is not connected.');
    }
  }

  // TODO: Implement periodic pings to keep the connection alive

  /// Attempts to reconnect to the WebSocket server after a delay.
  void _attemptReconnect(String url) {
    if (_reconnectTimer != null) return;

    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_channel == null) {
        _statusController.add(ConnectionStatus.connecting);
        try {
          _channel = WebSocketChannel.connect(Uri.parse(url));
          print(_channel);
          _statusController.add(ConnectionStatus.connected);

          _channel!.stream.listen(
            (message) {
              _messageController.add(message);
            },
            onDone: () {
              _statusController.add(ConnectionStatus.disconnected);
              _channel = null;
              _attemptReconnect(url);
            },
            onError: (error) {
              _statusController.add(ConnectionStatus.error);
              _channel = null;
              _attemptReconnect(url);
            },
          );

          // If connection is successful, cancel the reconnect timer.
          _reconnectTimer?.cancel();
          _reconnectTimer = null;
        } catch (e) {
          _statusController.add(ConnectionStatus.error);
          _channel = null;
        }
      } else {
        // Connection has been re-established, cancel the timer.
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
      }
    });
  }

  /// Disposes the WebSocketService by closing streams and connections.
  void dispose() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close(status.goingAway);
    _channel = null;
    _messageController.close();
    _statusController.close();
  }
}



// // lib/src/services/websocket_service.dart

// import 'dart:async';
// import 'package:cltb_mobile_app/providers/settings_provider.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum ConnectionStatus { connected, disconnected, connecting, error }

// class WebSocketService {
//   WebSocketChannel? _channel;
//   StreamController<String> _messageController = StreamController.broadcast();
//   StreamController<ConnectionStatus> _statusController = StreamController.broadcast();

//   Stream<String> get messages => _messageController.stream;
//   Stream<ConnectionStatus> get connectionStatus => _statusController.stream;

//   final Ref ref;

//   WebSocketService(this.ref);

//   Future<void> connect(String url) async {
//     _statusController.add(ConnectionStatus.connecting);
//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(url));
//       _statusController.add(ConnectionStatus.connected);
//       ref.read(settingsProvider.notifier).updateWebSocketStatus(true);

//       _channel!.stream.listen((message) {
//         _messageController.add(message);
//       }, onError: (error) {
//         _statusController.add(ConnectionStatus.error);
//         ref.read(settingsProvider.notifier).updateWebSocketStatus(false);
//       }, onDone: () {
//         _statusController.add(ConnectionStatus.disconnected);
//         ref.read(settingsProvider.notifier).updateWebSocketStatus(false);
//       });
//     } catch (e) {
//       _statusController.add(ConnectionStatus.error);
//       ref.read(settingsProvider.notifier).updateWebSocketStatus(false);
//       rethrow;
//     }
//   }

//   Future<void> disconnect() async {
//     await _channel?.sink.close();
//     _statusController.add(ConnectionStatus.disconnected);
//     ref.read(settingsProvider.notifier).updateWebSocketStatus(false);
//   }

//   bool get isConnected => _channel != null;

//   void sendMessage(String message) {
//     if (_channel != null) {
//       _channel!.sink.add(message);
//     } else {
//       throw Exception('WebSocket is not connected');
//     }
//   }

//   void dispose() {
//     _channel?.sink.close();
//     _messageController.close();
//     _statusController.close();
//   }
// }

// final webSocketServiceProvider = Provider<WebSocketService>((ref) {
//   final service = WebSocketService(ref);
//   ref.onDispose(() => service.dispose());
//   return service;
// });

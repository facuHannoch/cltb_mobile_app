// File: src/providers/orders_provider.dart

import 'package:cltb_mobile_app/providers/network_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cex_order.dart';
import '../models/dex_order.dart';
import '../models/pending_launch.dart';
import '../services/api_service.dart';
import '../services/logger_service.dart';

// Provider for OrdersNotifier
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>(
  (ref) => OrdersNotifier(ref),
);

// Class representing the state of orders
class OrdersState {
  final List<PendingLaunch> pendingLaunches;
  final bool isLoading;
  final String? error;

  OrdersState({
    required this.pendingLaunches,
    this.isLoading = false,
    this.error,
  });

  // Initial state factory
  factory OrdersState.initial() {
    return OrdersState(
      pendingLaunches: [],
      isLoading: false,
      error: null,
    );
  }

  // CopyWith method for immutability
  OrdersState copyWith({
    List<PendingLaunch>? pendingLaunches,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      pendingLaunches: pendingLaunches ?? this.pendingLaunches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// StateNotifier managing the OrdersState
class OrdersNotifier extends StateNotifier<OrdersState> {
  final Ref _ref;

  OrdersNotifier(this._ref) : super(OrdersState.initial());

  // Fetch pending launches from the server
  Future<void> fetchPendingLaunches() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _ref.read(apiServiceProvider).getPendingLaunches();
      if (response.success && response.data != null) {
        state = state.copyWith(
          pendingLaunches: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Failed to fetch pending launches.',
        );
      }
    } catch (e, stackTrace) {
      _ref.read(loggerServiceProvider).logError('fetchPendingLaunches', e as Exception, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred while fetching pending launches.',
      );
    }
  }

  // Add a new CEX order
  Future<void> addCEXOrder(CEXOrder order) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _ref.read(apiServiceProvider).sendCEXOrder(order);
      if (response.success && response.data != null) {
        // Assuming response.data contains the taskId and other details
        PendingLaunch newLaunch = PendingLaunch.fromJson(response.data!);
        state = state.copyWith(
          pendingLaunches: [...state.pendingLaunches, newLaunch],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Failed to add CEX order.',
        );
      }
    } catch (e, stackTrace) {
      _ref.read(loggerServiceProvider).logError('addCEXOrder', e as Exception, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred while adding CEX order.',
      );
    }
  }

  // Add a new DEX order
  Future<void> addDEXOrder(DEXOrder order) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _ref.read(apiServiceProvider).sendDEXOrder(order);
      if (response.success && response.data != null) {
        // Assuming response.data contains the taskId and other details
        PendingLaunch newLaunch = PendingLaunch.fromJson(response.data!);
        state = state.copyWith(
          pendingLaunches: [...state.pendingLaunches, newLaunch],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Failed to add DEX order.',
        );
      }
    } catch (e, stackTrace) {
      _ref.read(loggerServiceProvider).logError('addDEXOrder', e as Exception, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred while adding DEX order.',
      );
    }
  }

  // Remove a pending launch by taskId
  Future<void> removePendingLaunch(int taskId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _ref.read(apiServiceProvider).removePendingLaunch(taskId);
      if (response.success) {
        state = state.copyWith(
          pendingLaunches: state.pendingLaunches.where((launch) => launch.taskId != taskId).toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.errorMessage ?? 'Failed to remove pending launch.',
        );
      }
    } catch (e, stackTrace) {
      _ref.read(loggerServiceProvider).logError('removePendingLaunch', e as Exception, stackTrace);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred while removing pending launch.',
      );
    }
  }

  // Clear any existing error messages
  void clearError() {
    state = state.copyWith(error: null);
  }
}

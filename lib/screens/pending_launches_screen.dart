// File: src/screens/pending_launches_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cltb_mobile_app/models/pending_launch.dart';
import 'package:cltb_mobile_app/providers/orders_provider.dart';
import 'package:cltb_mobile_app/utils/json_formatter.dart';
import 'package:cltb_mobile_app/utils/time_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// **PendingLaunchesScreen**
///
/// The main widget representing the Pending Launches screen.
/// It contains a tabbed interface separating CEX and DEX pending launches.
class PendingLaunchesScreen extends ConsumerStatefulWidget {
  const PendingLaunchesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PendingLaunchesScreen> createState() =>
      _PendingLaunchesScreenState();
}

class _PendingLaunchesScreenState
    extends ConsumerState<PendingLaunchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 2 tabs: CEX and DEX
    _tabController = TabController(length: 2, vsync: this);
    // Fetch pending launches when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).fetchPendingLaunches();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// **_refreshPendingLaunches**
  ///
  /// Triggers a refresh of pending launches by fetching data from the server.
  Future<void> _refreshPendingLaunches() async {
    await ref.read(ordersProvider.notifier).fetchPendingLaunches();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Launches'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'CEX'),
            Tab(text: 'DEX'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingLaunchesTabView(launchType: 'cex'),
          PendingLaunchesTabView(launchType: 'dex'),
        ],
      ),
    );
  }
}

/// **PendingLaunchesTabView**
///
/// A widget that displays a list of pending launches based on the provided type.
///
/// **Parameters:**
/// - `String launchType`: The type of launches to display ('cex' or 'dex').
class PendingLaunchesTabView extends ConsumerWidget {
  final String launchType;

  const PendingLaunchesTabView({Key? key, required this.launchType})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersProvider);

    // Filter pending launches based on launchType
    final filteredLaunches = ordersState.pendingLaunches
        .where((launch) => launch.type.toLowerCase() == launchType)
        .toList();

    if (ordersState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ordersState.error != null) {
      // Display error message using Fluttertoast
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Fluttertoast.showToast(
          msg: ordersState.error!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        // Clear the error after displaying
        ref.read(ordersProvider.notifier).clearError();
      });
      return const Center(child: Text('An error occurred.'));
    }

    if (filteredLaunches.isEmpty) {
      return const Center(child: Text('No pending launches.'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(ordersProvider.notifier).fetchPendingLaunches();
      },
      child: ListView.builder(
        itemCount: filteredLaunches.length,
        itemBuilder: (context, index) {
          final launch = filteredLaunches[index];
          return PendingLaunchItem(launch: launch);
        },
      ),
    );
  }
}

/// **PendingLaunchItem**
///
/// A widget that represents an individual pending launch item.
///
/// **Parameters:**
/// - `PendingLaunch launch`: The pending launch data to display.
class PendingLaunchItem extends StatelessWidget {
  final PendingLaunch launch;

  const PendingLaunchItem({Key? key, required this.launch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(launch.createdAt);
    final formattedTime = formatTime(launch.createdAt);
    final jsonInstructions = JsonFormatter.formatJson(launch.instructions.toString());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0,
      child: ListTile(
        title: Text(launch.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${launch.type.toUpperCase()}'),
            Text('Created At: $formattedDate $formattedTime UTC'),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Show JSON instructions in a dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Instructions JSON'),
                    content: SingleChildScrollView(
                      child: SelectableText(jsonInstructions),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'View Instructions',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

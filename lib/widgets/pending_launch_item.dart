// lib/src/widgets/pending_launch_item.dart

import 'package:flutter/material.dart';
import '../models/pending_launch.dart';
import '../utils/time_utils.dart';

/// A widget that displays the details of a single pending token launch.
/// 
/// It shows information such as the type of launch (CEX or DEX), task ID,
/// creation date, name, and additional instructions in a formatted card.
class PendingLaunchItem extends StatelessWidget {
  /// The pending launch data to display.
  final PendingLaunch pendingLaunch;

  /// Creates a [PendingLaunchItem] widget.
  ///
  /// The [pendingLaunch] parameter must not be null.
  const PendingLaunchItem({
    required this.pendingLaunch,
    Key? key,
  }) : super(key: key);

  /// Builds the UI for the pending launch item.
  ///
  /// Utilizes a [Card] widget to encapsulate the information,
  /// with a [ListTile] for primary details and additional
  /// information displayed below.
  @override
  Widget build(BuildContext context) {
    // Format the creation date using a utility function.
    String formattedDate = formatDateTime(pendingLaunch.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary details: Type and Task ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pendingLaunch.type.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: pendingLaunch.type == 'cex' ? Colors.blue : Colors.green,
                  ),
                ),
                Text(
                  'Task ID: ${pendingLaunch.taskId}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Name of the launch
            Text(
              pendingLaunch.name,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            // Creation date
            Text(
              'Created At: $formattedDate',
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            // Additional instructions (if any)
            if (pendingLaunch.instructions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Display the JSON instructions in a formatted manner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      _formatInstructions(pendingLaunch.instructions),
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Formats the instructions JSON into a readable string.
  ///
  /// This function assumes that the [instructions] map can be
  /// converted into a pretty-printed JSON string.
  String _formatInstructions(Map<String, dynamic> instructions) {
    try {
      return instructions.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    } catch (e) {
      return 'Invalid instructions format.';
    }
  }
}

/// Formats a [DateTime] object into a human-readable string.
///
/// Example format: "2025-01-30 14:00:00 UTC"
String formatDateTime(DateTime dateTime) {
  // Assuming UTC for simplicity; adjust if local time is needed.
  return '${dateTime.toUtc().toIso8601String().replaceFirst('T', ' ').split('.').first} UTC';
}

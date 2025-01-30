class PendingLaunch {
  final String type; // 'cex' or 'dex'
  final int taskId;
  final DateTime createdAt;
  final String name;
  final Map<String, dynamic> instructions;

  PendingLaunch({
    required this.type,
    required this.taskId,
    required this.createdAt,
    required this.name,
    required this.instructions,
  });

  factory PendingLaunch.fromJson(Map<String, dynamic> json) => PendingLaunch(
        type: json['type'],
        taskId: json['task_id'],
        createdAt: DateTime.parse(json['created_at']),
        name: json['name'],
        instructions: json['instructions'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'task_id': taskId,
        'created_at': createdAt.toIso8601String(),
        'name': name,
        'instructions': instructions,
      };
}

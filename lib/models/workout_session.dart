class WorkoutSession {
  final String id;
  final String userId;
  final String workoutType; // 'push', 'pull', 'legs'
  final int durationSeconds;
  final DateTime completedAt;
  final DateTime createdAt;

  WorkoutSession({
    required this.id,
    required this.userId,
    required this.workoutType,
    required this.durationSeconds,
    required this.completedAt,
    required this.createdAt,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workoutType: json['workout_type'] as String,
      durationSeconds: json['duration_seconds'] as int,
      completedAt: DateTime.parse(json['completed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'workout_type': workoutType,
      'duration_seconds': durationSeconds,
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsert() {
    return {
      'user_id': userId,
      'workout_type': workoutType,
      'duration_seconds': durationSeconds,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}

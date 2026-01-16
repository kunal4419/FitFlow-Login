class ExerciseLog {
  final String id;
  final String sessionId;
  final String userId;
  final String exerciseName;
  final int setNumber;
  final int reps;
  final double weight;
  final double? rpe; // Rate of Perceived Exertion (1-10)
  final DateTime createdAt;

  ExerciseLog({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.exerciseName,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.rpe,
    required this.createdAt,
  });

  factory ExerciseLog.fromJson(Map<String, dynamic> json) {
    return ExerciseLog(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      userId: json['user_id'] as String,
      exerciseName: json['exercise_name'] as String,
      setNumber: json['set_number'] as int,
      reps: json['reps'] as int,
      weight: (json['weight'] as num).toDouble(),
      rpe: json['rpe'] != null ? (json['rpe'] as num).toDouble() : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'user_id': userId,
      'exercise_name': exerciseName,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsert() {
    return {
      'session_id': sessionId,
      'user_id': userId,
      'exercise_name': exerciseName,
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'rpe': rpe,
    };
  }

  /// Calculate estimated 1RM using Epley formula: 1RM = weight * (1 + reps/30)
  double get estimatedOneRM {
    return weight * (1 + reps / 30.0);
  }

  /// Calculate volume for this set: weight * reps
  double get volume {
    return weight * reps;
  }
}

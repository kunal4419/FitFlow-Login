class BodyweightLog {
  final String id;
  final String userId;
  final double weight;
  final DateTime loggedAt;
  final DateTime createdAt;

  BodyweightLog({
    required this.id,
    required this.userId,
    required this.weight,
    required this.loggedAt,
    required this.createdAt,
  });

  factory BodyweightLog.fromJson(Map<String, dynamic> json) {
    return BodyweightLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'logged_at': loggedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsert() {
    return {
      'user_id': userId,
      'weight': weight,
      'logged_at': loggedAt.toIso8601String(),
    };
  }
}

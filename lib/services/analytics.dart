import '../models/workout_session.dart';
import '../models/exercise_log.dart';
import '../models/bodyweight_log.dart';

/// Analytics service for workout data calculations
class Analytics {
  /// Calculate estimated 1RM using Epley formula
  /// Formula: 1RM = weight * (1 + reps/30)
  static double calculateOneRM(double weight, int reps) {
    if (reps == 0) return 0;
    return weight * (1 + reps / 30.0);
  }

  /// Get personal records (PRs) by exercise
  /// Returns a map of exercise name to best 1RM with the log that achieved it
  static Map<String, PRRecord> getPersonalRecords(List<ExerciseLog> logs) {
    final Map<String, PRRecord> prs = {};

    for (final log in logs) {
      final oneRM = log.estimatedOneRM;
      final exerciseName = log.exerciseName;

      if (!prs.containsKey(exerciseName) ||
          oneRM > prs[exerciseName]!.estimatedOneRM) {
        prs[exerciseName] = PRRecord(
          exerciseName: exerciseName,
          estimatedOneRM: oneRM,
          weight: log.weight,
          reps: log.reps,
          achievedAt: log.createdAt,
        );
      }
    }

    return prs;
  }

  /// Calculate training streak (consecutive days with workouts)
  /// Returns number of consecutive days from today backwards
  static int calculateStreak(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;

    // Sort by completed_at descending (most recent first)
    final sortedSessions = List<WorkoutSession>.from(sessions)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    // Get unique dates (local dates only, ignoring time)
    final uniqueDates = <DateTime>{};
    for (final session in sortedSessions) {
      final localDate = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      uniqueDates.add(localDate);
    }

    final sortedDates = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

    // Check if the most recent workout was today or yesterday
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    if (sortedDates.isEmpty) return 0;
    
    final mostRecentDate = sortedDates.first;
    
    // Streak is broken if last workout was more than 1 day ago
    if (mostRecentDate != todayDate && mostRecentDate != yesterdayDate) {
      return 0;
    }

    // Count consecutive days
    int streak = 0;
    DateTime expectedDate = mostRecentDate;

    for (final date in sortedDates) {
      if (date == expectedDate) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get strength progression for a specific exercise
  /// Returns list of 1RM estimates over time
  static List<StrengthDataPoint> getStrengthProgression(
    List<ExerciseLog> logs,
    String exerciseName,
  ) {
    final exerciseLogs = logs
        .where((log) => log.exerciseName == exerciseName)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final Map<DateTime, double> dailyBest = {};

    for (final log in exerciseLogs) {
      final date = DateTime(
        log.createdAt.year,
        log.createdAt.month,
        log.createdAt.day,
      );
      final oneRM = log.estimatedOneRM;

      if (!dailyBest.containsKey(date) || oneRM > dailyBest[date]!) {
        dailyBest[date] = oneRM;
      }
    }

    return dailyBest.entries
        .map((entry) => StrengthDataPoint(
              date: entry.key,
              estimatedOneRM: entry.value,
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get bodyweight trend
  static List<BodyweightDataPoint> getBodyweightTrend(
    List<BodyweightLog> logs,
  ) {
    return logs
        .map((log) => BodyweightDataPoint(
              date: log.loggedAt,
              weight: log.weight,
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Helper: Get the start of the week (Monday) for a given date
  static DateTime getWeekStart(DateTime date) {
    final dayOfWeek = date.weekday; // Monday = 1, Sunday = 7
    final daysToSubtract = dayOfWeek - 1; // Days since Monday
    final weekStart = date.subtract(Duration(days: daysToSubtract));
    return DateTime(weekStart.year, weekStart.month, weekStart.day);
  }

  /// Get unique exercise names from logs
  static List<String> getUniqueExerciseNames(List<ExerciseLog> logs) {
    final names = logs.map((log) => log.exerciseName).toSet().toList();
    names.sort();
    return names;
  }
}

/// Personal record data structure
class PRRecord {
  final String exerciseName;
  final double estimatedOneRM;
  final double weight;
  final int reps;
  final DateTime achievedAt;

  PRRecord({
    required this.exerciseName,
    required this.estimatedOneRM,
    required this.weight,
    required this.reps,
    required this.achievedAt,
  });
}

/// Strength progression data point
class StrengthDataPoint {
  final DateTime date;
  final double estimatedOneRM;

  StrengthDataPoint({
    required this.date,
    required this.estimatedOneRM,
  });
}

/// Bodyweight trend data point
class BodyweightDataPoint {
  final DateTime date;
  final double weight;

  BodyweightDataPoint({
    required this.date,
    required this.weight,
  });
}

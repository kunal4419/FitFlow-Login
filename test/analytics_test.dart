import 'package:flutter_test/flutter_test.dart';
import 'package:fit_flow/services/analytics.dart';
import 'package:fit_flow/models/workout_session.dart';
import 'package:fit_flow/models/exercise_log.dart';

void main() {
  group('Analytics - 1RM Calculation', () {
    test('calculates 1RM correctly using Epley formula', () {
      // 1RM = weight * (1 + reps/30)
      expect(Analytics.calculateOneRM(100, 10), closeTo(133.33, 0.01));
      expect(Analytics.calculateOneRM(225, 5), closeTo(262.5, 0.01));
      expect(Analytics.calculateOneRM(315, 1), closeTo(325.5, 0.01));
    });

    test('handles zero reps', () {
      expect(Analytics.calculateOneRM(100, 0), 0);
    });

    test('handles 1 rep (should be slightly higher than weight)', () {
      expect(Analytics.calculateOneRM(225, 1), closeTo(232.5, 0.01));
    });
  });

  group('Analytics - Personal Records', () {
    test('finds best 1RM for each exercise', () {
      final logs = [
        _createExerciseLog('Squat', 1, 225, 5),
        _createExerciseLog('Squat', 2, 275, 3),
        _createExerciseLog('Bench', 1, 185, 8),
        _createExerciseLog('Bench', 2, 205, 5),
      ];

      final prs = Analytics.getPersonalRecords(logs);

      expect(prs.length, 2);
      expect(prs.containsKey('Squat'), true);
      expect(prs.containsKey('Bench'), true);

      // Squat: 275 * (1 + 3/30) = 302.5
      expect(prs['Squat']!.estimatedOneRM, closeTo(302.5, 0.01));
      expect(prs['Squat']!.weight, 275);
      expect(prs['Squat']!.reps, 3);

      // Bench: 205 * (1 + 5/30) = 239.17
      expect(prs['Bench']!.estimatedOneRM, closeTo(239.17, 0.01));
    });

    test('handles empty logs', () {
      final prs = Analytics.getPersonalRecords([]);
      expect(prs.isEmpty, true);
    });
  });

  group('Analytics - Streak Calculation', () {
    test('calculates consecutive training days correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final sessions = [
        _createSession(today),
        _createSession(today.subtract(const Duration(days: 1))),
        _createSession(today.subtract(const Duration(days: 2))),
        _createSession(today.subtract(const Duration(days: 3))),
      ];

      expect(Analytics.calculateStreak(sessions), 4);
    });

    test('handles streak with gap (broken streak)', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final sessions = [
        _createSession(today.subtract(const Duration(days: 5))),
        _createSession(today.subtract(const Duration(days: 6))),
        _createSession(today.subtract(const Duration(days: 7))),
      ];

      // Streak is 0 because last workout was more than 1 day ago
      expect(Analytics.calculateStreak(sessions), 0);
    });

    test('counts streak starting yesterday', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      
      final sessions = [
        _createSession(yesterday),
        _createSession(yesterday.subtract(const Duration(days: 1))),
        _createSession(yesterday.subtract(const Duration(days: 2))),
      ];

      expect(Analytics.calculateStreak(sessions), 3);
    });

    test('handles multiple sessions on same day', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final sessions = [
        _createSession(today),
        _createSession(today), // Second session same day
        _createSession(today.subtract(const Duration(days: 1))),
      ];

      // Should count as 2 days, not 3
      expect(Analytics.calculateStreak(sessions), 2);
    });

    test('returns 0 for empty sessions', () {
      expect(Analytics.calculateStreak([]), 0);
    });
  });

  group('Analytics - Strength Progression', () {
    test('tracks 1RM over time for specific exercise', () {
      final baseDate = DateTime(2024, 1, 1);
      
      final logs = [
        _createExerciseLogWithDate('Squat', 1, 225, 5, baseDate),
        _createExerciseLogWithDate('Squat', 1, 245, 5, baseDate.add(const Duration(days: 7))),
        _createExerciseLogWithDate('Squat', 1, 265, 5, baseDate.add(const Duration(days: 14))),
        _createExerciseLogWithDate('Bench', 1, 185, 5, baseDate),
      ];

      final progression = Analytics.getStrengthProgression(logs, 'Squat');
      
      expect(progression.length, 3);
      expect(progression[0].estimatedOneRM, closeTo(262.5, 0.01)); // 225 * (1 + 5/30)
      expect(progression[1].estimatedOneRM, closeTo(285.83, 0.01)); // 245 * (1 + 5/30)
      expect(progression[2].estimatedOneRM, closeTo(309.17, 0.01)); // 265 * (1 + 5/30)
    });

    test('handles multiple sets on same day (keeps best)', () {
      final date = DateTime(2024, 1, 1);
      
      final logs = [
        _createExerciseLogWithDate('Squat', 1, 225, 8, date),
        _createExerciseLogWithDate('Squat', 2, 225, 6, date),
        _createExerciseLogWithDate('Squat', 3, 225, 5, date),
      ];

      final progression = Analytics.getStrengthProgression(logs, 'Squat');
      
      expect(progression.length, 1);
      // Best is 8 reps: 225 * (1 + 8/30) = 285
      expect(progression[0].estimatedOneRM, closeTo(285, 0.01));
    });
  });
}

// Helper functions to create test data
ExerciseLog _createExerciseLog(
  String name,
  int setNumber,
  double weight,
  int reps,
) {
  return ExerciseLog(
    id: 'test-${name}-${setNumber}',
    sessionId: 'test-session',
    userId: 'test-user',
    exerciseName: name,
    setNumber: setNumber,
    reps: reps,
    weight: weight,
    createdAt: DateTime.now(),
  );
}

ExerciseLog _createExerciseLogWithDate(
  String name,
  int setNumber,
  double weight,
  int reps,
  DateTime date,
) {
  return ExerciseLog(
    id: 'test-${name}-${setNumber}',
    sessionId: 'test-session',
    userId: 'test-user',
    exerciseName: name,
    setNumber: setNumber,
    reps: reps,
    weight: weight,
    createdAt: date,
  );
}

WorkoutSession _createSession(DateTime date) {
  return WorkoutSession(
    id: 'test-${date.millisecondsSinceEpoch}',
    userId: 'test-user',
    workoutType: 'push',
    durationSeconds: 3600,
    completedAt: date,
    createdAt: date,
  );
}

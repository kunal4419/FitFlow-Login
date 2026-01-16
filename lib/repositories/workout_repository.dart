import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/workout_session.dart';
import '../models/exercise_log.dart';
import '../models/bodyweight_log.dart';

class WorkoutRepository {
  final SupabaseClient _supabase;

  WorkoutRepository(this._supabase);

  // ==================== WORKOUT SESSIONS ====================

  /// Create a new workout session
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session) async {
    final response = await _supabase
        .from('workout_sessions')
        .insert(session.toInsert())
        .select()
        .single();

    return WorkoutSession.fromJson(response);
  }

  /// Get user's workout sessions (latest first)
  Future<List<WorkoutSession>> getWorkoutSessions({int limit = 20}) async {
    final response = await _supabase
        .from('workout_sessions')
        .select()
        .order('completed_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => WorkoutSession.fromJson(json))
        .toList();
  }

  /// Get workout sessions within a date range
  Future<List<WorkoutSession>> getWorkoutSessionsInRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _supabase
        .from('workout_sessions')
        .select()
        .gte('completed_at', startDate.toIso8601String())
        .lte('completed_at', endDate.toIso8601String())
        .order('completed_at', ascending: false);

    return (response as List)
        .map((json) => WorkoutSession.fromJson(json))
        .toList();
  }

  /// Get a single workout session by ID
  Future<WorkoutSession?> getWorkoutSession(String sessionId) async {
    final response = await _supabase
        .from('workout_sessions')
        .select()
        .eq('id', sessionId)
        .maybeSingle();

    if (response == null) return null;
    return WorkoutSession.fromJson(response);
  }

  /// Update workout session
  Future<void> updateWorkoutSession(WorkoutSession session) async {
    await _supabase
        .from('workout_sessions')
        .update(session.toJson())
        .eq('id', session.id);
  }

  /// Delete workout session (cascade deletes exercise logs)
  Future<void> deleteWorkoutSession(String sessionId) async {
    await _supabase.from('workout_sessions').delete().eq('id', sessionId);
  }

  // ==================== EXERCISE LOGS ====================

  /// Create exercise logs (batch insert)
  Future<List<ExerciseLog>> createExerciseLogs(
      List<ExerciseLog> logs) async {
    if (logs.isEmpty) return [];

    final response = await _supabase
        .from('exercise_logs')
        .insert(logs.map((log) => log.toInsert()).toList())
        .select();

    return (response as List)
        .map((json) => ExerciseLog.fromJson(json))
        .toList();
  }

  /// Get exercise logs for a specific session
  Future<List<ExerciseLog>> getExerciseLogsForSession(
      String sessionId) async {
    final response = await _supabase
        .from('exercise_logs')
        .select()
        .eq('session_id', sessionId)
        .order('exercise_name')
        .order('set_number');

    return (response as List)
        .map((json) => ExerciseLog.fromJson(json))
        .toList();
  }

  /// Get all exercise logs for a specific exercise name
  Future<List<ExerciseLog>> getExerciseLogsByName(String exerciseName) async {
    final response = await _supabase
        .from('exercise_logs')
        .select()
        .eq('exercise_name', exerciseName)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ExerciseLog.fromJson(json))
        .toList();
  }

  /// Get all exercise logs within a date range
  Future<List<ExerciseLog>> getExerciseLogsInRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _supabase
        .from('exercise_logs')
        .select()
        .gte('created_at', startDate.toIso8601String())
        .lte('created_at', endDate.toIso8601String())
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ExerciseLog.fromJson(json))
        .toList();
  }

  // ==================== BODYWEIGHT LOGS ====================

  /// Create a bodyweight log entry
  Future<BodyweightLog> createBodyweightLog(BodyweightLog log) async {
    final response = await _supabase
        .from('bodyweight_logs')
        .insert(log.toInsert())
        .select()
        .single();

    return BodyweightLog.fromJson(response);
  }

  /// Get bodyweight logs (latest first)
  Future<List<BodyweightLog>> getBodyweightLogs({int limit = 100}) async {
    final response = await _supabase
        .from('bodyweight_logs')
        .select()
        .order('logged_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => BodyweightLog.fromJson(json))
        .toList();
  }

  /// Get bodyweight logs within a date range
  Future<List<BodyweightLog>> getBodyweightLogsInRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _supabase
        .from('bodyweight_logs')
        .select()
        .gte('logged_at', startDate.toIso8601String())
        .lte('logged_at', endDate.toIso8601String())
        .order('logged_at', ascending: false);

    return (response as List)
        .map((json) => BodyweightLog.fromJson(json))
        .toList();
  }

  /// Update bodyweight log
  Future<void> updateBodyweightLog(BodyweightLog log) async {
    await _supabase
        .from('bodyweight_logs')
        .update(log.toJson())
        .eq('id', log.id);
  }

  /// Delete bodyweight log
  Future<void> deleteBodyweightLog(String logId) async {
    await _supabase.from('bodyweight_logs').delete().eq('id', logId);
  }
}

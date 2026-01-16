import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/workout_session.dart';
import '../../models/exercise_log.dart';
import '../../repositories/workout_repository.dart';
import '../../services/analytics.dart';
import '../../widgets/auth_required.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late WorkoutRepository _workoutRepository;
  List<WorkoutSession> _sessions = [];
  Map<String, List<ExerciseLog>> _sessionLogs = {};
  Map<String, PRRecord> _personalRecords = {};
  int _currentStreak = 0;
  
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _workoutRepository = WorkoutRepository(Supabase.instance.client);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load workout sessions
      final sessions = await _workoutRepository.getWorkoutSessions(limit: 50);
      
      // Load all exercise logs for PR calculation
      final allLogs = <ExerciseLog>[];
      for (final session in sessions) {
        final logs = await _workoutRepository.getExerciseLogsForSession(session.id);
        _sessionLogs[session.id] = logs;
        allLogs.addAll(logs);
      }
      
      // Calculate analytics
      final prs = Analytics.getPersonalRecords(allLogs);
      final streak = Analytics.calculateStreak(sessions);

      if (mounted) {
        setState(() {
          _sessions = sessions;
          _personalRecords = prs;
          _currentStreak = streak;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Color _getWorkoutColor(String type) {
    switch (type.toLowerCase()) {
      case 'push':
        return Colors.blue;
      case 'pull':
        return Colors.green;
      case 'legs':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthRequired(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workout History'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $_error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: _sessions.isEmpty
                        ? const Center(
                            child: Text(
                              'No workouts yet!\nStart your first workout to see it here.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView(
                            children: [
                              // Stats cards
                              _buildStatsSection(),
                              
                              const Divider(height: 1),
                              
                              // PRs section
                              _buildPRsSection(),
                              
                              const Divider(height: 1),
                              
                              // Session list header
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Recent Workouts',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              // Workout sessions
                              ..._sessions.map((session) => _buildSessionCard(session)),
                            ],
                          ),
                  ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Streak',
              '$_currentStreak days',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Total',
              '${_sessions.length} workouts',
              Icons.fitness_center,
              Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPRsSection() {
    if (_personalRecords.isEmpty) {
      return const SizedBox.shrink();
    }

    return ExpansionTile(
      title: const Text(
        'Personal Records',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: const Icon(Icons.emoji_events, color: Colors.amber),
      children: _personalRecords.entries.map((entry) {
        final pr = entry.value;
        return ListTile(
          title: Text(pr.exerciseName),
          subtitle: Text(
            '${pr.weight.toStringAsFixed(1)} kg × ${pr.reps} reps',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${pr.estimatedOneRM.toStringAsFixed(0)} kg',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '1RM est.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSessionCard(WorkoutSession session) {
    final logs = _sessionLogs[session.id] ?? [];
    final exerciseCount = logs.map((log) => log.exerciseName).toSet().length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(bottom: 12),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getWorkoutColor(session.workoutType),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.workoutType.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(session.completedAt),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatDuration(session.durationSeconds)} • $exerciseCount exercises',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          
          // Exercise logs
          ...logs.fold<Map<String, List<ExerciseLog>>>({}, (map, log) {
            map.putIfAbsent(log.exerciseName, () => []).add(log);
            return map;
          }).entries.map((entry) {
            final exerciseName = entry.key;
            final exerciseSets = entry.value;
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...exerciseSets.map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${log.setNumber}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${log.weight.toStringAsFixed(1)} kg × ${log.reps} reps',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          if (log.rpe != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'RPE ${log.rpe!.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

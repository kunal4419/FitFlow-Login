import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/auth_controller.dart';
import '../../data/exercise_data.dart';
import '../../models/exercise.dart';
import '../../models/workout_session.dart';
import '../../models/exercise_log.dart';
import '../../repositories/workout_repository.dart';
import 'history_screen.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final String workoutType; // 'push', 'pull', 'legs'

  const ActiveWorkoutScreen({
    super.key,
    required this.workoutType,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late List<Exercise> exercises;
  late WorkoutRepository _workoutRepository;
  
  // Workout timer
  late Stopwatch _stopwatch;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  
  // Exercise data: Map<exerciseName, List<SetData>>
  final Map<String, List<SetData>> _exerciseSets = {};
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeExercises();
    _startWorkoutTimer();
    _workoutRepository = WorkoutRepository(Supabase.instance.client);
  }

  void _initializeExercises() {
    switch (widget.workoutType) {
      case 'push':
        exercises = ExerciseData.getPushExercises();
        break;
      case 'pull':
        exercises = ExerciseData.getPullExercises();
        break;
      case 'legs':
        exercises = ExerciseData.getLegExercises();
        break;
      default:
        exercises = [];
    }
    
    // Initialize with one empty set per exercise
    for (final exercise in exercises) {
      _exerciseSets[exercise.name] = [SetData()];
    }
  }

  void _startWorkoutTimer() {
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsedTime = _stopwatch.elapsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Future<void> _confirmAndSaveWorkout() async {
    // Check if any sets have data
    bool hasData = false;
    _exerciseSets.forEach((_, sets) {
      for (final set in sets) {
        if (set.weight != null && set.reps != null) {
          hasData = true;
        }
      }
    });

    if (!hasData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one set with weight and reps'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.save_outlined,
                color: _getWorkoutColor(widget.workoutType),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Save Workout?'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Duration: ${_formatDuration(_elapsedTime)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Type: ${widget.workoutType.toUpperCase()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'This will save your workout permanently.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getWorkoutColor(widget.workoutType),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _saveWorkout();
    }
  }

  Future<void> _saveWorkout() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = authController.currentUser?.id;
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Create workout session
      final session = WorkoutSession(
        id: '', // Will be generated by database
        userId: userId,
        workoutType: widget.workoutType,
        durationSeconds: _elapsedTime.inSeconds,
        completedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      final createdSession = await _workoutRepository.createWorkoutSession(session);

      // Create exercise logs
      final List<ExerciseLog> logs = [];
      _exerciseSets.forEach((exerciseName, sets) {
        for (int i = 0; i < sets.length; i++) {
          final set = sets[i];
          if (set.weight != null && set.reps != null) {
            logs.add(ExerciseLog(
              id: '', // Will be generated by database
              sessionId: createdSession.id,
              userId: userId,
              exerciseName: exerciseName,
              setNumber: i + 1,
              reps: set.reps!,
              weight: set.weight!,
              rpe: set.rpe,
              createdAt: DateTime.now(),
            ));
          }
        }
      });

      if (logs.isNotEmpty) {
        await _workoutRepository.createExerciseLogs(logs);
      }

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to history
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save workout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workoutType.toUpperCase()} Workout'),
        actions: [
          // Save button in app bar
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _isSaving
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _confirmAndSaveWorkout,
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Workout timer and stats
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Timer
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 32,
                          color: _getWorkoutColor(widget.workoutType),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _formatDuration(_elapsedTime),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Exercise count
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Exercises',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${exercises.length}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _getWorkoutColor(widget.workoutType),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final sets = _exerciseSets[exercise.name]!;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16),
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      leading: CircleAvatar(
                        backgroundColor: _getWorkoutColor(widget.workoutType).withOpacity(0.2),
                        child: Icon(
                          Icons.fitness_center,
                          color: _getWorkoutColor(widget.workoutType),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        exercise.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${sets.length} ${sets.length == 1 ? 'set' : 'sets'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      children: [
                      // Set rows
                      ...List.generate(sets.length, (setIndex) {
                        final set = sets[setIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 6.0,
                          ),
                          child: Row(
                            children: [
                              // Set number badge
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _getWorkoutColor(widget.workoutType),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${setIndex + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              // Weight
                              Flexible(
                                flex: 3,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Weight (kg)',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      set.weight = double.tryParse(value);
                                    });
                                  },
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Reps
                              Flexible(
                                flex: 2,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Reps',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      set.reps = int.tryParse(value);
                                    });
                                  },
                                ),
                              ),
                              
                              const SizedBox(width: 8),
                              
                              // Delete set button
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: sets.length > 1 ? Colors.red : Colors.grey,
                                ),
                                onPressed: sets.length > 1
                                    ? () {
                                        setState(() {
                                          sets.removeAt(setIndex);
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        );
                      }),
                      
                      // Add set button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                sets.add(SetData());
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: _getWorkoutColor(widget.workoutType),
                            ),
                            label: const Text('Add Set'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getWorkoutColor(String type) {
    switch (type.toLowerCase()) {
      case 'push':
        return Colors.orange;
      case 'pull':
        return Colors.blue;
      case 'legs':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Data class for tracking a single set
class SetData {
  double? weight;
  int? reps;
  double? rpe;
  bool completed = false;

  SetData({
    this.weight,
    this.reps,
    this.rpe,
    this.completed = false,
  });
}

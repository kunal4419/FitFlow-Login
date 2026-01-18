import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/auth_controller.dart';
import '../../controllers/workout_session_controller.dart';
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
  late WorkoutSessionController _sessionController;
  
  // Exercise data: Map<exerciseName, List<SetData>>
  Map<String, List<SetData>> _exerciseSets = {};
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _workoutRepository = WorkoutRepository(Supabase.instance.client);
    _sessionController = Provider.of<WorkoutSessionController>(context, listen: false);
    
    // Check if resuming existing session
    if (_sessionController.isSessionActive && 
        _sessionController.workoutType == widget.workoutType) {
      // Resume existing session - restore data from controller
      _exerciseSets = Map.from(_sessionController.exerciseSets);
      // Only get exercises list for display, DON'T reinitialize sets
      _initializeExercises();
    } else {
      // Start new session
      _initializeExercises();
      _initializeEmptySets();
      _sessionController.startSession(widget.workoutType, _exerciseSets);
    }
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
  }
  
  void _initializeEmptySets() {
    // Initialize with one empty set per exercise
    for (final exercise in exercises) {
      _exerciseSets[exercise.name] = [SetData()];
    }
  }



  @override
  void dispose() {
    // Don't cancel session on dispose - it persists
    super.dispose();
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
                'Duration: ${_sessionController.getFormattedDuration()}',
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
        durationSeconds: _sessionController.elapsedTime.inSeconds,
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
              createdAt: DateTime.now(),
            ));
          }
        }
      });

      if (logs.isNotEmpty) {
        await _workoutRepository.createExerciseLogs(logs);
      }

      if (mounted) {
        // Save successful - show success message and navigate
        // Cancel the session since workout is saved
        _sessionController.cancelSession();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to history screen
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
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.workoutType.toUpperCase()} Workout',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getWorkoutColor(widget.workoutType),
                          _getWorkoutColor(widget.workoutType).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: _confirmAndSaveWorkout,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Workout timer and stats
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFa1a1aa),
                              ),
                            ),
                            Consumer<WorkoutSessionController>(
                              builder: (context, controller, _) {
                                return Text(
                                  controller.getFormattedDuration(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Exercise count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Exercises',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFa1a1aa),
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
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final sets = _exerciseSets[exercise.name]!;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16),
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getWorkoutColor(widget.workoutType).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${sets.length} ${sets.length == 1 ? 'set' : 'sets'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFa1a1aa),
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
                                  key: ValueKey('weight_${exercise.name}_$setIndex'),
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: set.weight != null 
                                        ? (set.weight! % 1 == 0 
                                          ? set.weight!.toInt().toString() 
                                          : set.weight.toString())
                                        : '',
                                      selection: TextSelection.collapsed(
                                        offset: set.weight != null 
                                          ? (set.weight! % 1 == 0 
                                            ? set.weight!.toInt().toString().length 
                                            : set.weight.toString().length)
                                          : 0,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Weight (kg)',
                                    hintStyle: const TextStyle(color: Color(0xFFa1a1aa)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: _getWorkoutColor(widget.workoutType), width: 2),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (value) {
                                    setState(() {
                                      set.weight = double.tryParse(value);
                                    });
                                    _sessionController.updateSessionData(_exerciseSets);
                                  },
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Reps
                              Flexible(
                                flex: 2,
                                child: TextField(
                                  key: ValueKey('reps_${exercise.name}_$setIndex'),
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: set.reps?.toString() ?? '',
                                      selection: TextSelection.collapsed(
                                        offset: set.reps?.toString().length ?? 0,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Reps',
                                    hintStyle: const TextStyle(color: Color(0xFFa1a1aa)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: _getWorkoutColor(widget.workoutType), width: 2),
                                    ),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      set.reps = int.tryParse(value);
                                    });
                                    _sessionController.updateSessionData(_exerciseSets);
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
                                        _sessionController.updateSessionData(_exerciseSets);
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
                              _sessionController.updateSessionData(_exerciseSets);
                            },
                            icon: Icon(
                              Icons.add,
                              color: _getWorkoutColor(widget.workoutType),
                            ),
                            label: const Text(
                              'Add Set',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: _getWorkoutColor(widget.workoutType)),
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
        return const Color(0xFFf97316);
      case 'pull':
        return const Color(0xFF3b82f6);
      case 'legs':
        return const Color(0xFF10b981);
      default:
        return Colors.grey;
    }
  }
}


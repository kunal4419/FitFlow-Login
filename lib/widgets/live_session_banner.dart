import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/workout_session_controller.dart';
import '../screens/tracking/active_workout_screen.dart';

class LiveSessionBanner extends StatelessWidget {
  const LiveSessionBanner({super.key});

  Color _getWorkoutColor(String? workoutType) {
    switch (workoutType?.toLowerCase()) {
      case 'push':
        return const Color(0xFFf97316); // Orange
      case 'pull':
        return const Color(0xFF3b82f6); // Blue
      case 'legs':
        return const Color(0xFF10b981); // Green
      default:
        return const Color(0xFF6366F1); // Purple
    }
  }

  String _getWorkoutDisplayName(String? workoutType) {
    if (workoutType == null) return 'Workout';
    return '${workoutType[0].toUpperCase()}${workoutType.substring(1)} Day';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutSessionController>(
      builder: (context, sessionController, _) {
        if (!sessionController.isSessionActive) {
          return const SizedBox.shrink();
        }

        final workoutColor = _getWorkoutColor(sessionController.workoutType);
        final workoutName = _getWorkoutDisplayName(sessionController.workoutType);

        return Material(
          elevation: 8,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  workoutColor,
                  workoutColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: workoutColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Live indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Workout info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            workoutName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            sessionController.getFormattedDuration(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Resume button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ActiveWorkoutScreen(
                              workoutType: sessionController.workoutType!,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Resume',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Cancel button
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF18181b),
                            title: const Text(
                              'Cancel Workout?',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to cancel this workout session? All progress will be lost.',
                              style: TextStyle(color: Color(0xFFa1a1aa)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Keep Session',
                                  style: TextStyle(color: Color(0xFFa1a1aa)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFef4444), Color(0xFFdc2626)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: const Text(
                                    'Cancel Workout',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          sessionController.cancelSession();
                        }
                      },
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../data/exercise_data.dart';
import '../widgets/exercise_card.dart';
import '../auth/auth_controller.dart';
import 'tracking/active_workout_screen.dart';
import 'auth/login_screen.dart';

class PullDayPage extends StatelessWidget {
  const PullDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a0a0a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FitFlow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 92,
                  height: 92,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF3b82f6),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3b82f6).withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const FaIcon(FontAwesomeIcons.personSwimming, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Pull Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3b82f6),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Back, Biceps • 6 Exercises •\n45-60 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "45-60 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Intermediate"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "6 exercises"),
                  ],
                ),
                const SizedBox(height: 30),
                _StartWorkoutButton(workoutType: 'pull'),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.latPulldown),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.barbellRow),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.barbellBicepsCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.straightArmLatPulldown),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.ropeHammerCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.reversePecDeckFly),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF18181b),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFFa1a1aa), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Color(0xFFa1a1aa), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _StartWorkoutButton extends StatelessWidget {
  final String workoutType;
  
  const _StartWorkoutButton({required this.workoutType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          final authController = Provider.of<AuthController>(context, listen: false);
          
          if (authController.isAuthenticated) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ActiveWorkoutScreen(workoutType: workoutType),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text(
          'Start Workout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF3b82f6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

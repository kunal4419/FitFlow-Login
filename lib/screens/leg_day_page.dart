import 'package:flutter/material.dart';
import '../data/exercise_data.dart';
import '../widgets/exercise_card.dart';

class LegDayPage extends StatelessWidget {
  const LegDayPage({super.key});

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
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.directions_run, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Leg Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Quads, Hamstrings, Calves • 6 Exercises •\n60-75 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFa1a1aa), fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "60-75 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Advanced"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "6 exercises"),
                  ],
                ),
                const SizedBox(height: 30),
                ExerciseCard(exercise: ExerciseData.squat),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.hamstringLegCurl),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.legPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.dumbbellShoulderPress),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.legExtension),
                const SizedBox(height: 16),
                ExerciseCard(exercise: ExerciseData.calfRaises),
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

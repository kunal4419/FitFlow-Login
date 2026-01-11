import 'package:flutter/material.dart';
import '../widgets/workout_option_card.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  int? expandedIndex;

  void toggleExpansion(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                RichText(
                  text: const TextSpan(
                    text: "Choose your ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: "workout\nsplit",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      TextSpan(
                        text: ".",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Select from our scientifically designed\nworkout routines. Each split is optimized for\nmaximum muscle growth and recovery.",
                  style: TextStyle(color: Color(0xFFa1a1aa), height: 1.5, fontSize: 14),
                ),
                const SizedBox(height: 40),
                WorkoutOptionCard(
                  title: "Push Day",
                  description: "Chest, Shoulders, Triceps",
                  fullDescription: "Focus on pushing movements that target chest, shoulders, and triceps. Perfect for building upper body pressing strength and muscle mass.",
                  duration: "45-60\nmin",
                  difficulty: "Intermediate",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Incline Dumbbell Press",
                    "Flat Dumbbell Press",
                    "Skullcrushers",
                    "Dumbbell Lateral Raises",
                    "Standing Cable Decline Press",
                    "Triceps Pushdown",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.fitness_center,
                  isExpanded: expandedIndex == 0,
                  onTap: () => toggleExpansion(0),
                ),
                const SizedBox(height: 16),
                WorkoutOptionCard(
                  title: "Pull Day",
                  description: "Back, Biceps",
                  fullDescription: "Pulling movements that develop back width and thickness while building strong, defined biceps.",
                  duration: "45-60\nmin",
                  difficulty: "Intermediate",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Lat Pulldown",
                    "Barbell Row",
                    "Barbell Biceps Curl",
                    "Straight Arm Lat Pulldown",
                    "Rope Hammer Curl",
                    "Reverse Pec Deck Fly",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.accessibility_new,
                  isExpanded: expandedIndex == 1,
                  onTap: () => toggleExpansion(1),
                ),
                const SizedBox(height: 16),
                WorkoutOptionCard(
                  title: "Leg Day",
                  description: "Quads, Hamstrings, Calves",
                  fullDescription: "Complete lower body training targeting all major muscle groups for strength, power, and stability.",
                  duration: "60-75\nmin",
                  difficulty: "Advanced",
                  exercises: "6\nexercises",
                  exerciseList: [
                    "Squat",
                    "Hamstring Leg Curl",
                    "Leg Press",
                    "Dumbbell Shoulder Press",
                    "Leg Extension",
                    "Calf Raises",
                  ],
                  color: Color(0xFF6366F1),
                  icon: Icons.directions_run,
                  isExpanded: expandedIndex == 2,
                  onTap: () => toggleExpansion(2),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

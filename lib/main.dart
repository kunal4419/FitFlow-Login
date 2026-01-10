import 'package:flutter/material.dart';

void main() {
  runApp(const FitFlowApp());
}

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fitness_center, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Fit-Flow",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            DrawerMenuItem(
              icon: Icons.home,
              text: "Home",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            DrawerMenuItem(
              icon: Icons.fitness_center,
              text: "Workouts",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkoutsPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.arrow_upward,
              text: "Push",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PushDayPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.arrow_downward,
              text: "Pull",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PullDayPage()),
                );
              },
            ),
            DrawerMenuItem(
              icon: Icons.directions_run,
              text: "Legs",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LegDayPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Builder(
                builder: (context) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    Text(
                      "Fit-Flow",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // Spacer to center the title
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "⚡ The Ultimate Workout Split",
                style: TextStyle(color: Colors.purpleAccent),
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.purple, Colors.pink],
              ).createShader(bounds),
              child: Text(
                "Build faster with\n"
                "Precision",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "A structured push-pull-legs system crafted\n"
              "using proven methods and optimal recovery\n"
              "principles.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 20, 15, 20), Color.fromARGB(255, 22, 218, 38)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkoutsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text("Get Started →"),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatItem(title: "Workout Days", value: "3"),
                  StatItem(title: "Exercises", value: "20+"),
                  StatItem(title: "Results", value: "100%"),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Stack your ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "workout\nroutine",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        TextSpan(
                          text: ".",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Mix and match exercises to rapidly optimize\nyour training. Everything fits together\nperfectly out of the box.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  WorkoutCard(
                    title: "Push Day",
                    description: "Chest, shoulders, and triceps workouts\ndesigned for maximum growth.",
                    color: Colors.pinkAccent,
                    icon: Icons.fitness_center,
                  ),
                  const SizedBox(height: 16),
                  WorkoutCard(
                    title: "Pull Day",
                    description: "Back and biceps exercises to build a\npowerful upper body.",
                    color: Colors.blueAccent,
                    icon: Icons.accessibility_new,
                  ),
                  const SizedBox(height: 16),
                  WorkoutCard(
                    title: "Leg Day",
                    description: "Complete lower body routine for strength\nand muscle development.",
                    color: Colors.greenAccent,
                    icon: Icons.directions_run,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 60),
            // Footer Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Fit-Flow",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Scientifically designed workout routines for\noptimal muscle growth and recovery.",
                    style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  // Quick Links
                  const Text(
                    "Quick Links",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  FooterLink(text: "Home"),
                  FooterLink(text: "Workouts"),
                  FooterLink(text: "Push Day"),
                  FooterLink(text: "Pull Day"),
                  FooterLink(text: "Leg Day"),
                  const SizedBox(height: 24),
                  // Connect
                  const Text(
                    "Connect",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.code, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mail_outline, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                  // Copyright
                  const Center(
                    child: Text(
                      "© 2025 FitFlow by Kunal. All rights reserved.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Privacy and Terms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      const Text("•", style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Terms of Service",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fit-Flow",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
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
          color: Colors.purpleAccent,
        ),
      ),
      TextSpan(
        text: ".",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.purpleAccent,
        ),
      ),
    ],
  ),
),
              const SizedBox(height: 16),
              const Text(
                "Select from our scientifically designed\nworkout routines. Each split is optimized for\nmaximum muscle growth and recovery.",
                style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                          "Dumbbell Lat Raises",
                          "Standing Cable Decline Press",
                          "Triceps Pushdown",
                        ],
                        color: Colors.pinkAccent,
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
                          "Seated Row",
                          "Barbell Biceps Curl",
                          "Reverse Lat Pulldown",
                          "Rope Hammer Curl",
                          "Reverse Pec Deck Fly",
                        ],
                        color: Colors.blueAccent,
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
                          "Bulgarian Split Squat",
                          "Leg Extension",
                          "Calf Raises",
                        ],
                        color: Colors.greenAccent,
                        icon: Icons.directions_run,
                        isExpanded: expandedIndex == 2,
                        onTap: () => toggleExpansion(2),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const WorkoutCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}

class WorkoutOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String fullDescription;
  final String duration;
  final String difficulty;
  final String exercises;
  final List<String> exerciseList;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final bool isExpanded;

  const WorkoutOptionCard({
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.duration,
    required this.difficulty,
    required this.exercises,
    required this.exerciseList,
    required this.color,
    required this.icon,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      fullDescription,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatChip(Icons.access_time, duration),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatChip(Icons.bar_chart, difficulty),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatChip(Icons.fitness_center, exercises),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Exercise List:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...exerciseList.map((exercise) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: color, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            exercise,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (title == "Push Day") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PushDayPage()),
                            );
                          } else if (title == "Pull Day") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PullDayPage()),
                            );
                          } else if (title == "Leg Day") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LegDayPage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Start $title",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class PushDayPage extends StatelessWidget {
  const PushDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fit-Flow",
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.fitness_center, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Push Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Chest, Shoulders & Triceps • 6 Exercises •\n45-60 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.access_time, "45-60 min"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.bar_chart, "Intermediate"),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.fitness_center, "22 per each"),
                  ],
                ),
                const SizedBox(height: 30),
                ExerciseCard(
                  title: "Incline Dumbbell Press",
                  description: "Targets upper chest for maximum development.",
                  sets: "4 sets",
                  reps: "8-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Flat Dumbbell Press",
                  description: "Primary movement for overall chest development.",
                  sets: "4 sets",
                  reps: "8-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Skullcrushers",
                  description: "Isolates triceps for strength and size.",
                  sets: "3 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Dumbbell Lat Raises",
                  description: "Builds shoulder width and definition.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Standing Cable Decline Press",
                  description: "Targets lower chest with constant tension.",
                  sets: "3 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Triceps Pushdown",
                  description: "Finisher for triceps pump and definition.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start Push Day",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
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
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class PullDayPage extends StatelessWidget {
  const PullDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fit-Flow",
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.accessibility_new, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Pull Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Back, Biceps • 6 Exercises •\n45-60 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
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
                ExerciseCard(
                  title: "Lat Pulldown",
                  description: "Primary back width builder.",
                  sets: "4 sets",
                  reps: "8-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Seated Row",
                  description: "Builds back thickness and density.",
                  sets: "4 sets",
                  reps: "8-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Barbell Biceps Curl",
                  description: "Mass builder for biceps.",
                  sets: "3 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Reverse Lat Pulldown",
                  description: "Targets lower lats and biceps.",
                  sets: "3 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Rope Hammer Curl",
                  description: "Develops brachialis and forearms.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Reverse Pec Deck Fly",
                  description: "Isolates rear delts and upper back.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start Pull Day",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
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
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class LegDayPage extends StatelessWidget {
  const LegDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fit-Flow",
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
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.directions_run, color: Colors.black, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Leg Day",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Quads, Hamstrings, Calves • 6 Exercises •\n60-75 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
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
                ExerciseCard(
                  title: "Squat",
                  description: "King of all leg exercises.",
                  sets: "4 sets",
                  reps: "6-10 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Hamstring Leg Curl",
                  description: "Isolates hamstrings for growth.",
                  sets: "4 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Leg Press",
                  description: "High volume quad builder.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Bulgarian Split Squat",
                  description: "Unilateral leg strength and stability.",
                  sets: "3 sets",
                  reps: "10-12 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Leg Extension",
                  description: "Quad isolation and pump.",
                  sets: "3 sets",
                  reps: "12-15 reps",
                ),
                const SizedBox(height: 16),
                ExerciseCard(
                  title: "Calf Raises",
                  description: "Complete calf development.",
                  sets: "4 sets",
                  reps: "15-20 reps",
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Start Leg Day",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                ),
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
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String description;
  final String sets;
  final String reps;

  const ExerciseCard({
    required this.title,
    required this.description,
    required this.sets,
    required this.reps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sets,
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reps,
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

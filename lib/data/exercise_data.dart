import '../models/exercise.dart';

/// All exercise data with remote video URLs and local cache filenames
/// Replace these GitHub URLs with your actual video URLs
class ExerciseData {
  // PUSH DAY EXERCISES
  static const Exercise inclineDumbbellPress = Exercise(
    name: 'Incline Dumbbell Press',
    description: 'Target upper chest with this inclined pressing movement.',
    sets: '4 sets',
    reps: '8-12 reps',
    targetMuscles: ['Upper Chest', 'Triceps', 'Anterior Deltoids'],
    exerciseTips: [
      '45 degree incline',
      'Press dumbbells together at top',
      'Don\'t arch back excessively',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/InclineDumbbellPress.mp4',
    localFileName: 'incline_dumbbell_press.mp4',
  );

  static const Exercise flatDumbbellPress = Exercise(
    name: 'Flat Dumbbell Press',
    description: 'Primary movement for overall chest development.',
    sets: '4 sets',
    reps: '8-12 reps',
    targetMuscles: ['Chest', 'Triceps', 'Front Deltoids'],
    exerciseTips: [
      'Keep shoulder blades retracted',
      'Lower dumbbells to chest level',
      'Press with explosive power',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/FlatDumbbellPress.mp4',
    localFileName: 'flat_dumbbell_press.mp4',
  );

  static const Exercise cableFlies = Exercise(
    name: 'Cable Flies',
    description: 'Isolate and stretch the chest muscles effectively.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Chest', 'Anterior Deltoids'],
    exerciseTips: [
      'Maintain slight elbow bend',
      'Squeeze at the center',
      'Control the negative',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/cable_flies.mp4',
    localFileName: 'cable_flies.mp4',
  );

  static const Exercise lateralRaises = Exercise(
    name: 'Lateral Raises',
    description: 'Build width in your shoulders with this isolation exercise.',
    sets: '4 sets',
    reps: '12-15 reps',
    targetMuscles: ['Side Deltoids'],
    exerciseTips: [
      'Lead with elbows',
      'Don\'t swing the weight',
      'Pause at top',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/lateral_raises.mp4',
    localFileName: 'lateral_raises.mp4',
  );

  static const Exercise tricepPushdowns = Exercise(
    name: 'Tricep Pushdowns',
    description: 'Isolate triceps for arm development.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Triceps'],
    exerciseTips: [
      'Keep elbows tucked',
      'Full extension at bottom',
      'Squeeze triceps',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/tricep_pushdowns.mp4',
    localFileName: 'tricep_pushdowns.mp4',
  );

  static const Exercise overheadTricepExtension = Exercise(
    name: 'Overhead Tricep Extension',
    description: 'Target the long head of the triceps.',
    sets: '3 sets',
    reps: '10-12 reps',
    targetMuscles: ['Triceps (Long Head)'],
    exerciseTips: [
      'Keep elbows close to head',
      'Full stretch at bottom',
      'Control the weight',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/overhead_tricep_extension.mp4',
    localFileName: 'overhead_tricep_extension.mp4',
  );

  // PULL DAY EXERCISES
  static const Exercise pullUps = Exercise(
    name: 'Pull-Ups',
    description: 'Compound exercise for back and arm development.',
    sets: '4 sets',
    reps: '8-12 reps',
    targetMuscles: ['Lats', 'Biceps', 'Rear Deltoids'],
    exerciseTips: [
      'Full range of motion',
      'Pull with elbows',
      'Squeeze shoulder blades together',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/pull_ups.mp4',
    localFileName: 'pull_ups.mp4',
  );

  static const Exercise barbellRows = Exercise(
    name: 'Barbell Rows',
    description: 'Build thickness in your back with heavy rows.',
    sets: '4 sets',
    reps: '8-10 reps',
    targetMuscles: ['Lats', 'Rhomboids', 'Traps'],
    exerciseTips: [
      'Hinge at the hips',
      'Pull to lower chest',
      'Keep core tight',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/barbell_rows.mp4',
    localFileName: 'barbell_rows.mp4',
  );

  static const Exercise seatedCableRows = Exercise(
    name: 'Seated Cable Rows',
    description: 'Build back thickness with controlled rowing.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Mid Back', 'Lats', 'Biceps'],
    exerciseTips: [
      'Keep chest up',
      'Pull to lower chest',
      'Squeeze shoulder blades',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/seated_cable_rows.mp4',
    localFileName: 'seated_cable_rows.mp4',
  );

  static const Exercise facePulls = Exercise(
    name: 'Face Pulls',
    description: 'Excellent for rear delts and posture.',
    sets: '3 sets',
    reps: '15-20 reps',
    targetMuscles: ['Rear Deltoids', 'Traps', 'Rhomboids'],
    exerciseTips: [
      'Pull to face level',
      'Externally rotate shoulders',
      'High rep range',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/face_pulls.mp4',
    localFileName: 'face_pulls.mp4',
  );

  static const Exercise bicepCurls = Exercise(
    name: 'Bicep Curls',
    description: 'Classic arm builder for bicep development.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Biceps'],
    exerciseTips: [
      'Don\'t swing',
      'Full range of motion',
      'Squeeze at top',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/bicep_curls.mp4',
    localFileName: 'bicep_curls.mp4',
  );

  static const Exercise hammerCurls = Exercise(
    name: 'Hammer Curls',
    description: 'Target brachialis and brachioradialis.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Brachialis', 'Brachioradialis', 'Biceps'],
    exerciseTips: [
      'Neutral grip throughout',
      'Control the negative',
      'Keep elbows stationary',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/hammer_curls.mp4',
    localFileName: 'hammer_curls.mp4',
  );

  // LEG DAY EXERCISES
  static const Exercise squats = Exercise(
    name: 'Squats',
    description: 'The king of leg exercises for overall development.',
    sets: '4 sets',
    reps: '8-10 reps',
    targetMuscles: ['Quads', 'Glutes', 'Hamstrings'],
    exerciseTips: [
      'Depth to parallel',
      'Keep chest up',
      'Drive through heels',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/squats.mp4',
    localFileName: 'squats.mp4',
  );

  static const Exercise romanianDeadlifts = Exercise(
    name: 'Romanian Deadlifts',
    description: 'Target hamstrings and glutes with this hip hinge movement.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Hamstrings', 'Glutes', 'Lower Back'],
    exerciseTips: [
      'Slight knee bend',
      'Push hips back',
      'Feel the stretch',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/romanian_deadlifts.mp4',
    localFileName: 'romanian_deadlifts.mp4',
  );

  static const Exercise legPress = Exercise(
    name: 'Leg Press',
    description: 'Safely load heavy weight for leg development.',
    sets: '4 sets',
    reps: '12-15 reps',
    targetMuscles: ['Quads', 'Glutes'],
    exerciseTips: [
      'Full range of motion',
      'Don\'t lock knees',
      'Keep lower back pressed',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/leg_press.mp4',
    localFileName: 'leg_press.mp4',
  );

  static const Exercise walkingLunges = Exercise(
    name: 'Walking Lunges',
    description: 'Unilateral leg exercise for balance and strength.',
    sets: '3 sets',
    reps: '12 reps/leg',
    targetMuscles: ['Quads', 'Glutes', 'Hamstrings'],
    exerciseTips: [
      'Long stride',
      'Knee to 90 degrees',
      'Keep torso upright',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/walking_lunges.mp4',
    localFileName: 'walking_lunges.mp4',
  );

  static const Exercise legCurls = Exercise(
    name: 'Leg Curls',
    description: 'Isolate hamstrings for complete leg development.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Hamstrings'],
    exerciseTips: [
      'Full range of motion',
      'Squeeze at top',
      'Control the negative',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/leg_curls.mp4',
    localFileName: 'leg_curls.mp4',
  );

  static const Exercise calfRaises = Exercise(
    name: 'Calf Raises',
    description: 'Build strong, defined calves.',
    sets: '4 sets',
    reps: '15-20 reps',
    targetMuscles: ['Calves (Gastrocnemius)', 'Soleus'],
    exerciseTips: [
      'Full stretch at bottom',
      'Pause at top',
      'Slow and controlled',
    ],
    videoUrl: 'https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/videos/calf_raises.mp4',
    localFileName: 'calf_raises.mp4',
  );

  // Helper method to get all exercises by workout type
  static List<Exercise> getPushExercises() => [
        inclineDumbbellPress,
        flatDumbbellPress,
        cableFlies,
        lateralRaises,
        tricepPushdowns,
        overheadTricepExtension,
      ];

  static List<Exercise> getPullExercises() => [
        pullUps,
        barbellRows,
        seatedCableRows,
        facePulls,
        bicepCurls,
        hammerCurls,
      ];

  static List<Exercise> getLegExercises() => [
        squats,
        romanianDeadlifts,
        legPress,
        walkingLunges,
        legCurls,
        calfRaises,
      ];
}

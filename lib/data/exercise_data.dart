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

  static const Exercise skullcrushers = Exercise(
    name: 'Skullcrushers',
    description: 'Isolation exercise targeting the triceps.',
    sets: '3 sets',
    reps: '10-12 reps',
    targetMuscles: ['Triceps'],
    exerciseTips: [
      'Keep elbows stationary',
      'Lower weight to forehead',
      'Control the movement',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/Skullcrushers.mp4',
    localFileName: 'skullcrushers.mp4',
  );

  static const Exercise dumbbellLateralRaises = Exercise(
    name: 'Dumbbell Lateral Raises',
    description: 'Build width in your shoulders with this isolation exercise.',
    sets: '4 sets',
    reps: '12-15 reps',
    targetMuscles: ['Side Deltoids'],
    exerciseTips: [
      'Lead with elbows',
      'Don\'t swing the weight',
      'Pause at top',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/DumbbellLateralRaises.mp4',
    localFileName: 'dumbbell_lateral_raises.mp4',
  );

  static const Exercise standingCableDeclinePress = Exercise(
    name: 'Standing Cable Decline Press',
    description: 'Cable press variation for lower chest development.',
    sets: '3 sets',
    reps: '10-12 reps',
    targetMuscles: ['Lower Chest', 'Triceps'],
    exerciseTips: [
      'Press downward at an angle',
      'Keep core engaged',
      'Squeeze chest at the bottom',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/StandingCableDeclinePress.mp4',
    localFileName: 'standing_cable_decline_press.mp4',
  );

  static const Exercise tricepsPushdown = Exercise(
    name: 'Triceps Pushdown',
    description: 'Isolate triceps for arm development.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Triceps'],
    exerciseTips: [
      'Keep elbows tucked',
      'Full extension at bottom',
      'Squeeze triceps',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/TricepsPushdown.mp4',
    localFileName: 'triceps_pushdown.mp4',
  );

  // PULL DAY EXERCISES
  static const Exercise latPulldown = Exercise(
    name: 'Lat Pulldown',
    description: 'Build width in your lats with this pulling movement.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Lats', 'Biceps', 'Rear Deltoids'],
    exerciseTips: [
      'Pull bar to upper chest',
      'Lean back slightly',
      'Squeeze shoulder blades together',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/lat-pulldown.mp4',
    localFileName: 'lat_pulldown.mp4',
  );

  static const Exercise barbellRow = Exercise(
    name: 'Barbell Row',
    description: 'Build thickness in your back with heavy rows.',
    sets: '4 sets',
    reps: '8-10 reps',
    targetMuscles: ['Lats', 'Rhomboids', 'Traps'],
    exerciseTips: [
      'Hinge at the hips',
      'Pull to lower chest',
      'Keep core tight',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/barbell-row.mp4',
    localFileName: 'barbell_row.mp4',
  );

  static const Exercise barbellBicepsCurl = Exercise(
    name: 'Barbell Biceps Curl',
    description: 'Classic barbell curl for bicep development.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Biceps'],
    exerciseTips: [
      'Keep elbows stationary',
      'Don\'t swing the weight',
      'Full range of motion',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/barbell-biceps-curl.mp4',
    localFileName: 'barbell_biceps_curl.mp4',
  );

  static const Exercise straightArmLatPulldown = Exercise(
    name: 'Straight Arm Lat Pulldown',
    description: 'Isolate the lats with this straight arm movement.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Lats'],
    exerciseTips: [
      'Keep arms straight',
      'Pull down to thighs',
      'Feel the lat stretch',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/straight-arm-lat-pulldown.mp4',
    localFileName: 'straight_arm_lat_pulldown.mp4',
  );

  static const Exercise ropeHammerCurl = Exercise(
    name: 'Rope Hammer Curl',
    description: 'Cable variation of hammer curls for forearm and bicep development.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Brachialis', 'Brachioradialis', 'Biceps'],
    exerciseTips: [
      'Use rope attachment',
      'Neutral grip throughout',
      'Control the negative',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/rope-hammer-curl.mp4',
    localFileName: 'rope_hammer_curl.mp4',
  );

  static const Exercise reversePecDeckFly = Exercise(
    name: 'Reverse Pec Deck Fly',
    description: 'Isolate rear deltoids for shoulder development.',
    sets: '3 sets',
    reps: '15-20 reps',
    targetMuscles: ['Rear Deltoids', 'Traps', 'Rhomboids'],
    exerciseTips: [
      'Keep chest against pad',
      'Focus on rear delts',
      'Squeeze at the back',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/reverse-pec-deck-fly.mp4',
    localFileName: 'reverse_pec_deck_fly.mp4',
  );

  // LEG DAY EXERCISES
  static const Exercise squat = Exercise(
    name: 'Squat',
    description: 'The king of leg exercises for overall development.',
    sets: '4 sets',
    reps: '8-10 reps',
    targetMuscles: ['Quads', 'Glutes', 'Hamstrings'],
    exerciseTips: [
      'Depth to parallel',
      'Keep chest up',
      'Drive through heels',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/squat.mp4',
    localFileName: 'squats.mp4',
  );

  static const Exercise hamstringLegCurl = Exercise(
    name: 'Hamstring Leg Curl',
    description: 'Isolate hamstrings with this leg curl variation.',
    sets: '4 sets',
    reps: '12-15 reps',
    targetMuscles: ['Hamstrings'],
    exerciseTips: [
      'Full range of motion',
      'Squeeze at the top',
      'Control the negative',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/hamstring-leg-curl.mp4',
    localFileName: 'hamstring_leg_curl.mp4',
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
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/leg-press.mp4',
    localFileName: 'leg_press.mp4',
  );

  static const Exercise dumbbellShoulderPress = Exercise(
    name: 'Dumbbell Shoulder Press',
    description: 'Build shoulder strength and mass with dumbbells.',
    sets: '4 sets',
    reps: '10-12 reps',
    targetMuscles: ['Shoulders', 'Triceps'],
    exerciseTips: [
      'Press overhead fully',
      'Keep core engaged',
      'Control the descent',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/DumbbellShoulderPress.mp4',
    localFileName: 'dumbbell_shoulder_press.mp4',
  );

  static const Exercise legExtension = Exercise(
    name: 'Leg Extension',
    description: 'Isolate quadriceps for complete leg development.',
    sets: '3 sets',
    reps: '12-15 reps',
    targetMuscles: ['Quadriceps'],
    exerciseTips: [
      'Full extension at top',
      'Control the weight',
      'Don\'t lock knees',
    ],
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/leg-extension.mp4',
    localFileName: 'leg_extension.mp4',
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
    videoUrl: 'https://github.com/kunal4419/Fit-Flow-Videos/raw/refs/heads/main/calf-raise.mp4',
    localFileName: 'calf_raises.mp4',
  );

  // Helper method to get all exercises by workout type
  static List<Exercise> getPushExercises() => [
        inclineDumbbellPress,
        flatDumbbellPress,
        skullcrushers,
        dumbbellLateralRaises,
        standingCableDeclinePress,
        tricepsPushdown,
      ];

  static List<Exercise> getPullExercises() => [
        latPulldown,
        barbellRow,
        barbellBicepsCurl,
        straightArmLatPulldown,
        ropeHammerCurl,
        reversePecDeckFly,
      ];

  static List<Exercise> getLegExercises() => [
        squat,
        hamstringLegCurl,
        legPress,
        dumbbellShoulderPress,
        legExtension,
        calfRaises,
      ];
}

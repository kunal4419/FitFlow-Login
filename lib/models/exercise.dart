/// Exercise data model containing name, video URL, and local cache information
class Exercise {
  final String name;
  final String description;
  final String sets;
  final String reps;
  final List<String> targetMuscles;
  final List<String> exerciseTips;
  final String videoUrl; // Remote GitHub URL
  final String localFileName; // Local cache filename (e.g., 'bench_press.mp4')

  const Exercise({
    required this.name,
    required this.description,
    required this.sets,
    required this.reps,
    required this.targetMuscles,
    required this.exerciseTips,
    required this.videoUrl,
    required this.localFileName,
  });

  /// Creates a copy of this exercise with updated fields
  Exercise copyWith({
    String? name,
    String? description,
    String? sets,
    String? reps,
    List<String>? targetMuscles,
    List<String>? exerciseTips,
    String? videoUrl,
    String? localFileName,
  }) {
    return Exercise(
      name: name ?? this.name,
      description: description ?? this.description,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      exerciseTips: exerciseTips ?? this.exerciseTips,
      videoUrl: videoUrl ?? this.videoUrl,
      localFileName: localFileName ?? this.localFileName,
    );
  }

  @override
  String toString() {
    return 'Exercise(name: $name, videoUrl: $videoUrl, localFileName: $localFileName)';
  }
}

class WorkoutModel {
  const WorkoutModel({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.duration,
    required this.difficulty,
    required this.calories,
    required this.exercises,
  });

  final String name;
  final String description;
  final String imagePath;
  final String duration;
  final String difficulty;
  final String calories;
  final List<(String name, String sets)> exercises;
}

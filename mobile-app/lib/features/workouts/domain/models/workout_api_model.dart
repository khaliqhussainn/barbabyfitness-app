class ExerciseModel {
  final int id;
  final String name;
  final int sets;
  final String reps;
  final int restSeconds;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json['id'] as int,
        name: json['name'] as String,
        sets: json['sets'] as int,
        reps: json['reps'] as String,
        restSeconds: json['rest_seconds'] as int,
      );
}

class WorkoutApiModel {
  final int id;
  final String title;
  final String description;
  final int durationMinutes;
  final String difficulty;
  final String? category;
  final String? imageUrl;
  final List<ExerciseModel> exercises;
  final bool isSaved;

  const WorkoutApiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.difficulty,
    this.category,
    this.imageUrl,
    this.exercises = const [],
    this.isSaved = false,
  });

  factory WorkoutApiModel.fromJson(Map<String, dynamic> json) => WorkoutApiModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        durationMinutes: json['duration_minutes'] as int,
        difficulty: json['difficulty'] as String,
        category: json['category'] as String?,
        imageUrl: json['image_url'] as String?,
        exercises: (json['exercises'] as List<dynamic>?)
                ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        isSaved: json['isSaved'] as bool? ?? false,
      );

  WorkoutApiModel copyWith({bool? isSaved}) => WorkoutApiModel(
        id: id,
        title: title,
        description: description,
        durationMinutes: durationMinutes,
        difficulty: difficulty,
        category: category,
        imageUrl: imageUrl,
        exercises: exercises,
        isSaved: isSaved ?? this.isSaved,
      );
}

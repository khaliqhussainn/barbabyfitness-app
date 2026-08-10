enum FitnessLevelId { beginner, intermediate, advanced }

class FitnessLevelModel {
  const FitnessLevelModel({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final FitnessLevelId id;
  final String title;
  final String subtitle;
}

const List<FitnessLevelModel> fitnessLevels = [
  FitnessLevelModel(
    id: FitnessLevelId.beginner,
    title: 'Beginner',
    subtitle: 'Just starting out.',
  ),
  FitnessLevelModel(
    id: FitnessLevelId.intermediate,
    title: 'Intermediate',
    subtitle: 'Train regularly.',
  ),
  FitnessLevelModel(
    id: FitnessLevelId.advanced,
    title: 'Advanced',
    subtitle: 'Very active.',
  ),
];

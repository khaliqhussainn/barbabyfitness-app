enum MainGoalId { loseWeight, buildEndurance, consistency }

class MainGoalModel {
  const MainGoalModel({required this.id, required this.title, required this.subtitle});

  final MainGoalId id;
  final String title;
  final String subtitle;
}

const List<MainGoalModel> mainGoals = [
  MainGoalModel(id: MainGoalId.loseWeight, title: 'Lose Weight', subtitle: 'Focus on fat loss.'),
  MainGoalModel(id: MainGoalId.buildEndurance, title: 'Build Endurance', subtitle: 'Improve stamina.'),
  MainGoalModel(id: MainGoalId.consistency, title: 'Consistency', subtitle: 'Form sustainable habits.'),
];

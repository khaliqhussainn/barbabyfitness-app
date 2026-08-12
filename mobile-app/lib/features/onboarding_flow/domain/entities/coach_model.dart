enum CoachId { encourager, challenger, balance }

class CoachModel {
  const CoachModel({
    required this.id,
    required this.title,
    required this.name,
    required this.description,
  });

  final CoachId id;
  final String title;
  final String name;
  final String description;
}

const List<CoachModel> coaches = [
  CoachModel(
    id: CoachId.encourager,
    title: 'The Encourager',
    name: 'Alex',
    description:
        'Uplifting and supportive. Alex keeps you motivated with positivity and celebrates every win.',
  ),
  CoachModel(
    id: CoachId.challenger,
    title: 'The Challenger',
    name: 'Kyra',
    description:
        'Intense and driven. Kyra pushes your limits and holds you accountable to your highest potential.',
  ),
  CoachModel(
    id: CoachId.balance,
    title: 'The Balance Coach',
    name: 'Elsa',
    description:
        'Calm and holistic. Elsa blends fitness with mindfulness for sustainable, long-term results.',
  ),
];

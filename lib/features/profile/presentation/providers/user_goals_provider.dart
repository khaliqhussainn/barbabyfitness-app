import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FitnessGoal { increaseStrength, buildMuscle }

enum CoachingFocus { energy, consistency, recovery, performance }

class UserGoalsState {
  const UserGoalsState({
    required this.fitnessGoal,
    required this.coachingFocus,
  });

  final FitnessGoal fitnessGoal;
  final CoachingFocus coachingFocus;

  UserGoalsState copyWith({
    FitnessGoal? fitnessGoal,
    CoachingFocus? coachingFocus,
  }) =>
      UserGoalsState(
        fitnessGoal: fitnessGoal ?? this.fitnessGoal,
        coachingFocus: coachingFocus ?? this.coachingFocus,
      );
}

class UserGoalsNotifier extends StateNotifier<UserGoalsState> {
  UserGoalsNotifier()
      : super(const UserGoalsState(
          fitnessGoal: FitnessGoal.buildMuscle,
          coachingFocus: CoachingFocus.performance,
        ));

  void setFitnessGoal(FitnessGoal goal) =>
      state = state.copyWith(fitnessGoal: goal);

  void setCoachingFocus(CoachingFocus focus) =>
      state = state.copyWith(coachingFocus: focus);
}

final userGoalsProvider =
    StateNotifierProvider<UserGoalsNotifier, UserGoalsState>(
  (_) => UserGoalsNotifier(),
);

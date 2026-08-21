import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_service.dart';

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
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await AuthService.getPreferences();
    if (prefs != null) {
      final rawGoal = prefs['fitness_goal'] as String? ?? 'buildMuscle';
      final rawFocus = prefs['coaching_focus'] as String? ?? 'performance';
      state = UserGoalsState(
        fitnessGoal: FitnessGoal.values.firstWhere((v) => v.name == rawGoal, orElse: () => FitnessGoal.buildMuscle),
        coachingFocus: CoachingFocus.values.firstWhere((v) => v.name == rawFocus, orElse: () => CoachingFocus.performance),
      );
    }
  }

  void setFitnessGoal(FitnessGoal goal) =>
      state = state.copyWith(fitnessGoal: goal);

  void setCoachingFocus(CoachingFocus focus) =>
      state = state.copyWith(coachingFocus: focus);

  Future<bool> save() async {
    return AuthService.updatePreferences(
      fitnessGoal: state.fitnessGoal.name,
      coachingFocus: state.coachingFocus.name,
    );
  }
}

final userGoalsProvider =
    StateNotifierProvider<UserGoalsNotifier, UserGoalsState>(
  (_) => UserGoalsNotifier(),
);

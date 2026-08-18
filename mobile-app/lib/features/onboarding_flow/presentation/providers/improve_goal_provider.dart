import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ImproveGoal { energy, consistency, strength, endurance }

extension ImproveGoalX on ImproveGoal {
  String get title {
    switch (this) {
      case ImproveGoal.energy:      return 'Energy';
      case ImproveGoal.consistency: return 'Consistency';
      case ImproveGoal.strength:    return 'Strength';
      case ImproveGoal.endurance:   return 'Endurance';
    }
  }

  String get subtitle {
    switch (this) {
      case ImproveGoal.energy:      return 'Feel more energised day to day';
      case ImproveGoal.consistency: return 'Build a reliable workout habit';
      case ImproveGoal.strength:    return 'Get stronger and more powerful';
      case ImproveGoal.endurance:   return 'Last longer and push further';
    }
  }

  IconData get icon {
    switch (this) {
      case ImproveGoal.energy:      return Icons.bolt_rounded;
      case ImproveGoal.consistency: return Icons.track_changes_rounded;
      case ImproveGoal.strength:    return Icons.fitness_center_rounded;
      case ImproveGoal.endurance:   return Icons.directions_run_rounded;
    }
  }
}

final improveGoalProvider =
    StateProvider<ImproveGoal?>((ref) => null);

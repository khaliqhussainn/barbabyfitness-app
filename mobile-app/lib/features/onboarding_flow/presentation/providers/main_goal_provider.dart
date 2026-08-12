import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/main_goal_model.dart';

final mainGoalProvider =
    StateProvider<MainGoalId>((ref) => MainGoalId.buildEndurance);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/fitness_level_model.dart';

final fitnessLevelProvider =
    StateProvider<FitnessLevelId>((ref) => FitnessLevelId.intermediate);

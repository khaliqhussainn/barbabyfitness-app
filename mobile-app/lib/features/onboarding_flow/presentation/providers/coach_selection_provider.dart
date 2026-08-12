import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/coach_model.dart';

final coachSelectionProvider = StateProvider<CoachId>((ref) => CoachId.challenger);

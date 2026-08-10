import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/voice_model.dart';

final voiceSelectionProvider = StateProvider<VoiceId>((ref) => VoiceId.direct);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_service.dart';
import '../../domain/entities/voice_model.dart';

class VoiceSelectionNotifier extends StateNotifier<VoiceId> {
  VoiceSelectionNotifier() : super(VoiceId.direct) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await AuthService.getPreferences();
    if (prefs != null) {
      final raw = prefs['coach_voice'] as String? ?? 'direct';
      state = VoiceId.values.firstWhere((v) => v.name == raw, orElse: () => VoiceId.direct);
    }
  }

  Future<bool> save() async {
    return AuthService.updatePreferences(coachVoice: state.name);
  }
}

final voiceSelectionProvider = StateNotifierProvider<VoiceSelectionNotifier, VoiceId>(
  (ref) => VoiceSelectionNotifier(),
);

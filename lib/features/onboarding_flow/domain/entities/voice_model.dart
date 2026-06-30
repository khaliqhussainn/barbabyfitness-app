enum VoiceId { motivating, direct, calm }

class VoiceModel {
  const VoiceModel({required this.id, required this.label});

  final VoiceId id;
  final String label;
}

const List<VoiceModel> voices = [
  VoiceModel(id: VoiceId.motivating, label: 'Motivating and High Energy'),
  VoiceModel(id: VoiceId.direct, label: 'Direct and Challenging'),
  VoiceModel(id: VoiceId.calm, label: 'Calm and Supportive'),
];

import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorkoutZone { rest, easy, steady, push, max }

extension WorkoutZoneLabel on WorkoutZone {
  String get label {
    switch (this) {
      case WorkoutZone.rest:   return 'REST';
      case WorkoutZone.easy:   return 'EASY';
      case WorkoutZone.steady: return 'STEADY';
      case WorkoutZone.push:   return 'PUSH';
      case WorkoutZone.max:    return 'MAX';
    }
  }
}

class WorkoutSessionState {
  const WorkoutSessionState({
    required this.elapsedSeconds,
    required this.bpm,
    required this.isPaused,
    required this.isMuted,
  });

  final int elapsedSeconds;
  final int bpm;
  final bool isPaused;
  final bool isMuted;

  String get timerDisplay {
    final m = elapsedSeconds ~/ 60;
    final s = elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}';
  }

  WorkoutZone get zone {
    if (bpm < 100) return WorkoutZone.rest;
    if (bpm < 120) return WorkoutZone.easy;
    if (bpm < 135) return WorkoutZone.steady;
    if (bpm < 155) return WorkoutZone.push;
    return WorkoutZone.max;
  }

  WorkoutSessionState copyWith({
    int? elapsedSeconds,
    int? bpm,
    bool? isPaused,
    bool? isMuted,
  }) =>
      WorkoutSessionState(
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        bpm: bpm ?? this.bpm,
        isPaused: isPaused ?? this.isPaused,
        isMuted: isMuted ?? this.isMuted,
      );
}

class WorkoutSessionNotifier extends StateNotifier<WorkoutSessionState> {
  WorkoutSessionNotifier()
      : super(const WorkoutSessionState(
          elapsedSeconds: 0,
          bpm: 142,
          isPaused: false,
          isMuted: false,
        )) {
    _start();
  }

  Timer? _timer;
  final _rng = Random();

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isPaused) return;
      final delta = _rng.nextInt(5) - 2; // ±2 BPM drift
      final newBpm = (state.bpm + delta).clamp(100, 170);
      state = state.copyWith(
        elapsedSeconds: state.elapsedSeconds + 1,
        bpm: newBpm,
      );
    });
  }

  void togglePause() => state = state.copyWith(isPaused: !state.isPaused);
  void toggleMute()  => state = state.copyWith(isMuted: !state.isMuted);

  void reset() {
    state = const WorkoutSessionState(
      elapsedSeconds: 0,
      bpm: 142,
      isPaused: false,
      isMuted: false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final workoutSessionProvider =
    StateNotifierProvider.autoDispose<WorkoutSessionNotifier, WorkoutSessionState>(
  (_) => WorkoutSessionNotifier(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProgressTab { weekly, monthly }

class DayProgress {
  const DayProgress({required this.label, required this.value});
  final String label;
  // 0.0 – 1.0 fraction of the bar filled (orange portion)
  final double value;
}

class ProgressState {
  const ProgressState({
    required this.tab,
    required this.weeklyData,
    required this.monthlyData,
    required this.workouts,
    required this.calories,
    required this.coachInsight,
  });

  final ProgressTab tab;
  final List<DayProgress> weeklyData;
  final List<DayProgress> monthlyData;
  final int workouts;
  final int calories;
  final String coachInsight;

  List<DayProgress> get currentData =>
      tab == ProgressTab.weekly ? weeklyData : monthlyData;

  ProgressState copyWith({ProgressTab? tab}) =>
      ProgressState(
        tab: tab ?? this.tab,
        weeklyData: weeklyData,
        monthlyData: monthlyData,
        workouts: workouts,
        calories: calories,
        coachInsight: coachInsight,
      );
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier()
      : super(const ProgressState(
          tab: ProgressTab.weekly,
          weeklyData: [
            DayProgress(label: 'Mon', value: 0.85),
            DayProgress(label: 'Tue', value: 0.35),
            DayProgress(label: 'Wed', value: 0.60),
            DayProgress(label: 'Thu', value: 0.25),
            DayProgress(label: 'Fri', value: 0.70),
            DayProgress(label: 'Sat', value: 0.0),
            DayProgress(label: 'Sun', value: 0.0),
          ],
          monthlyData: [
            DayProgress(label: 'W1', value: 0.75),
            DayProgress(label: 'W2', value: 0.55),
            DayProgress(label: 'W3', value: 0.90),
            DayProgress(label: 'W4', value: 0.40),
          ],
          workouts: 4,
          calories: 1250,
          coachInsight:
              'Great consistency this week. You hit your endurance targets perfectly. Keep this momentum going.',
        ));

  void setTab(ProgressTab tab) => state = state.copyWith(tab: tab);
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, ProgressState>(
  (_) => ProgressNotifier(),
);

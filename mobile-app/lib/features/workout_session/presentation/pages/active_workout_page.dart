import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  int _elapsedSeconds = 0;
  late Timer _timer;
  bool _isPaused = false;
  int _selectedRpe = 1; // 0=Easy, 1=Push, 2=Hold
  int _caloriesBurned = 0;

  // seconds spent at each RPE level: [easy, push, hold]
  final List<int> _rpeSeconds = [0, 0, 0];

  static const _totalExercises = 10;

  final List<Map<String, String>> _exercises = [
    {'name': 'High Knees', 'sets': '3 × 20', 'unit': 'Reps'},
    {'name': 'Burpees', 'sets': '3 × 10', 'unit': 'Reps'},
    {'name': 'Jump Squats', 'sets': '3 × 15', 'unit': 'Reps'},
    {'name': 'Mountain Climbers', 'sets': '45 Seconds', 'unit': 'Seconds'},
    {'name': 'Plank Hold', 'sets': '60 Seconds', 'unit': 'Seconds'},
    {'name': 'Jump Lunges', 'sets': '3 × 12', 'unit': 'Reps'},
  ];

  final int _currentIndex = 3; // Exercise 4 of 10

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) {
        setState(() {
          _elapsedSeconds++;
          _rpeSeconds[_selectedRpe]++;
          // ~0.75 kcal/sec rough estimate
          if (_elapsedSeconds % 2 == 0) _caloriesBurned++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerDisplay {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showPauseModal() {
    setState(() => _isPaused = true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) => _PauseModal(
        onResume: () {
          Navigator.pop(context);
          setState(() => _isPaused = false);
        },
        onEnd: () {
          Navigator.pop(context);
          context.go(RouteNames.workoutComplete);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _exercises[_currentIndex % _exercises.length];
    final next = _exercises[(_currentIndex + 1) % _exercises.length];
    final int exerciseNumber = _currentIndex + 1;
    final double progress = exerciseNumber / _totalExercises;
    final int pct = (progress * 100).round();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showPauseModal();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Workout',
                            style: GoogleFonts.outfit(
                              color: AppColors.textPrimary,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'HIIT Endurance · Set 1',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _showPauseModal,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.pause_rounded,
                            color: AppColors.textPrimary, size: 22.w),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Progress bar ─────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    backgroundColor: AppColors.surface,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Exercise $exerciseNumber of $_totalExercises',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '$pct% Complete',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // ── Exercise name ────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current['name']!,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      current['sets']!,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // ── Exercise image ───────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: double.infinity,
                  height: 190.h,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.asset(
                      'assets/images/homeimg.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.fitness_center_rounded,
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                          size: 48.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // ── Coach Tip ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        child: Icon(Icons.person_rounded,
                            color: AppColors.primary, size: 22.w),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coach Tip',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Focus on maintaining proper form before increasing speed. Consistency always beats intensity.',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // ── RPE Buttons ──────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: List.generate(3, (i) {
                    final labels = ['Easy', 'Push', 'Hold'];
                    final isSelected = _selectedRpe == i;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 2 ? 10.w : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedRpe = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.18)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(14.r),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.primary, width: 1.8)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              labels[i],
                              style: GoogleFonts.outfit(
                                color: AppColors.textPrimary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 12.h),

              // ── Up Next ──────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Up Next',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              next['name']!,
                              style: GoogleFonts.outfit(
                                color: AppColors.textPrimary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              next['sets']!,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          width: 56.w,
                          height: 56.w,
                          color: AppColors.background,
                          child: Image.asset(
                            'assets/images/homeimg.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.fitness_center_rounded,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.4),
                              size: 24.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // ── Stats row ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        _StatCell(
                            label: 'Elapsed Time', value: _timerDisplay),
                        _VertDivider(),
                        _StatCell(
                            label: 'Calories',
                            value: '$_caloriesBurned',
                            unit: 'kcal'),
                        _VertDivider(),
                        _StatCell(
                            label: 'Complete',
                            value: '$pct%',
                            isHighlight: true),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // ── RPE Time Breakdown ────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _RpeTimeBar(rpeSeconds: _rpeSeconds),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    this.unit,
    this.isHighlight = false,
  });
  final String label;
  final String value;
  final String? unit;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.outfit(
                    color: isHighlight
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── RPE Time Breakdown bar ────────────────────────────────
class _RpeTimeBar extends StatelessWidget {
  const _RpeTimeBar({required this.rpeSeconds});
  final List<int> rpeSeconds;

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return m > 0 ? '${m}m ${sec}s' : '${sec}s';
  }

  @override
  Widget build(BuildContext context) {
    const labels = ['Easy', 'Push', 'Hold'];
    const colors = [
      Color(0xFF3B82F6), // blue
      AppColors.primary, // orange
      Color(0xFFEF4444), // red
    ];
    final total = rpeSeconds.fold(0, (a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time at Effort Level',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          // Segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: SizedBox(
              height: 8.h,
              child: Row(
                children: List.generate(3, (i) {
                  final fraction =
                      total == 0 ? (i == 1 ? 1.0 : 0.0) : rpeSeconds[i] / total;
                  return Flexible(
                    flex: (fraction * 1000).round().clamp(1, 1000),
                    child: Container(color: colors[i]),
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Labels row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              return Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: colors[i],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${labels[i]}  ${_fmt(rpeSeconds[i])}',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: AppColors.background,
    );
  }
}

class _PauseModal extends StatelessWidget {
  const _PauseModal({required this.onResume, required this.onEnd});

  final VoidCallback onResume;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 28.h),
          Text(
            'Workout Paused',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onResume,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Resume Workout',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onEnd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'End Workout',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFEF4444),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

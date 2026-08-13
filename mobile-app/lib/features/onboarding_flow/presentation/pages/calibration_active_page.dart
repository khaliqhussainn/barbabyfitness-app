import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';

class CalibrationActivePage extends StatefulWidget {
  const CalibrationActivePage({super.key});

  @override
  State<CalibrationActivePage> createState() => _CalibrationActivePageState();
}

class _CalibrationActivePageState extends State<CalibrationActivePage> {
  int _elapsedSeconds = 0;
  late Timer _timer;
  bool _isPaused = false;
  int _selectedRpe = 1;
  int _currentIndex = 3;

  final List<Map<String, String>> _exercises = [
    {'name': 'High Knees', 'sets': '3 × 20'},
    {'name': 'Burpees', 'sets': '3 × 10'},
    {'name': 'Box Steps', 'sets': '3 × 12'},
    {'name': 'Jump Squats', 'sets': '3 × 15'},
    {'name': 'Mountain Climbers', 'reps': '45', 'unit': 'Seconds'},
    {'name': 'Plank Hold', 'reps': '60', 'unit': 'Seconds'},
    {'name': 'Jump Lunges', 'sets': '3 × 12'},
    {'name': 'Push Ups', 'sets': '3 × 15'},
    {'name': 'Squat Hold', 'reps': '45', 'unit': 'Seconds'},
    {'name': 'Cool Down Stretch', 'reps': '120', 'unit': 'Seconds'},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) setState(() => _elapsedSeconds++);
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
    final current = _exercises[_currentIndex];
    final next = _exercises[_currentIndex + 1];
    final double progress = (_currentIndex + 1) / _exercises.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(progress),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExerciseCard(current),
                    SizedBox(height: 12.h),
                    _buildCoachTip(),
                    SizedBox(height: 16.h),
                    _buildRpeRow(),
                    SizedBox(height: 16.h),
                    _buildUpNext(next),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            _buildBottomStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Workout',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: _showPauseModal,
                child: Icon(
                  Icons.pause_rounded,
                  color: AppColors.textPrimary,
                  size: 26.w,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.h,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise ${_currentIndex + 1} of ${_exercises.length}',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                '${(progress * 100).round()}% Complete',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(Map<String, String> exercise) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise['name']!,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            exercise['sets'] ??
                '${exercise['reps']!} ${exercise['unit'] ?? 'Reps'}',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              size: 48.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachTip() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded,
                color: AppColors.primary, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coach Tip',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Focus on maintaining proper form before increasing speed. Consistency always beats intensity.',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRpeRow() {
    final labels = ['Easy', 'Push', 'Hold'];
    return Row(
      children: List.generate(3, (i) {
        final isSelected = _selectedRpe == i;
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 10.w : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedRpe = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUpNext(Map<String, String> next) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Up Next',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          next['name']!,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          next['sets'] ?? '${next['reps']!} ${next['unit'] ?? 'Reps'}',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomStats() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCell(label: 'Elapsed Time', value: _timerDisplay),
          _Divider(),
          _StatCell(label: 'Calories Burned', value: '${(_elapsedSeconds * 0.75).round()} kcal'),
          _Divider(),
          _StatCell(label: 'Heart Rate', value: '-- BPM'),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30.h,
      color: AppColors.textSecondary.withValues(alpha: 0.2),
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

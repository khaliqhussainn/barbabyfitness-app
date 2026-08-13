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

  final List<Map<String, String>> _exercises = [
    {'name': 'High Knees', 'sets': '3 × 20'},
    {'name': 'Burpees', 'sets': '3 × 10'},
    {'name': 'Jump Squats', 'reps': '15', 'sets': '3 × 15'},
    {'name': 'Mountain Climbers', 'reps': '45', 'unit': 'Seconds'},
    {'name': 'Plank Hold', 'reps': '60', 'unit': 'Seconds'},
    {'name': 'Jump Lunges', 'sets': '3 × 12'},
  ];

  final int _currentIndex = 2; // Jump Squats

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            _buildProgressBar(progress),
            SizedBox(height: 16.h),
            // Coach icon top-right
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.go(RouteNames.realTimeCoaching),
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.headset_mic_rounded,
                      color: AppColors.primary,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Now',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    current['name']!,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    current['reps'] ?? current['sets']!.split(' × ').last,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 68.sp,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  Text(
                    current['unit'] ?? 'Reps',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Effort',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildRpeButtons(),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    next['name']!,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    next['sets'] ??
                        '${next['reps']!} ${next['unit'] ?? 'Reps'}',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _buildBottomControls(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      children: [
        ClipRRect(
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5.h,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}% Complete',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Exercise ${_currentIndex + 1} / ${_exercises.length}',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRpeButtons() {
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showPauseModal,
            child: Column(
              children: [
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.pause_rounded,
                      color: Colors.white, size: 30.w),
                ),
                SizedBox(height: 6.h),
                Text('Pause',
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go(RouteNames.workoutComplete),
            child: Column(
              children: [
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.stop_rounded,
                      color: AppColors.textPrimary, size: 30.w),
                ),
                SizedBox(height: 6.h),
                Text('End',
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
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

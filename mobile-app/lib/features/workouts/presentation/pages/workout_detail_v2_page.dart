import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/models/workout_model.dart';

class WorkoutDetailV2Page extends StatelessWidget {
  const WorkoutDetailV2Page({super.key, required this.workout});

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildTitle(),
                        SizedBox(height: 20.h),
                        _buildStatsRow(),
                        SizedBox(height: 24.h),
                        _buildExerciseList(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 20.w),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              'Workout Details',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          workout.name,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          workout.description,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatItem(label: 'Duration', value: workout.duration, unit: 'min'),
            _Divider(),
            _StatItem(label: 'Difficulty', value: workout.difficulty, unit: ''),
            _Divider(),
            _StatItem(
                label: 'Estimated Calories',
                value: workout.calories,
                unit: 'kcal'),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercises',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        ...workout.exercises.map((e) => _ExerciseRow(name: e.$1, sets: e.$2)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 12.h, 25.w, 32.h),
      child: GestureDetector(
        onTap: () => context.go(RouteNames.activeWorkout),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Start Workout',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem(
      {required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Text(
            unit.isEmpty ? value : '$value $unit',
            style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        color: AppColors.background);
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({required this.name, required this.sets});

  final String name;
  final String sets;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600)),
          Text(sets,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

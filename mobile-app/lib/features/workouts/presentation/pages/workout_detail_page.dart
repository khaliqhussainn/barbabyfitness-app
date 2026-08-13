import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../domain/models/workout_model.dart';

class WorkoutDetailPage extends StatefulWidget {
  const WorkoutDetailPage({super.key, required this.workout});

  final WorkoutModel workout;

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  bool _isSaved = false;

  WorkoutModel get workout => widget.workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context, workout),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsRow(workout),
                        SizedBox(height: 20.h),
                        _buildDescription(workout),
                        SizedBox(height: 20.h),
                        _buildCoachTip(),
                        SizedBox(height: 20.h),
                        _buildExerciseGrid(workout),
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

  Widget _buildHeroSection(BuildContext context, WorkoutModel w) {
    return Stack(
      children: [
        // Hero image
        SizedBox(
          width: double.infinity,
          height: 280.h,
          child: Image.asset(
            w.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: Icon(Icons.fitness_center_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 64.w),
            ),
          ),
        ),
        // Gradient overlay at bottom of image
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),
        // Workout name at bottom of image
        Positioned(
          left: 25.w,
          bottom: 12.h,
          child: Text(
            w.name,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // Top bar
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.chevron_left_rounded,
                        color: AppColors.textPrimary, size: 26.w),
                  ),
                ),
                Text(
                  w.name,
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isSaved = !_isSaved),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: _isSaved ? AppColors.primary : AppColors.textPrimary,
                      size: 22.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(WorkoutModel w) {
    return Row(
      children: [
        Expanded(child: _StatCard(label: 'Duration', value: w.duration, unit: 'Minutes')),
        SizedBox(width: 10.w),
        Expanded(child: _DifficultyCard(label: w.difficulty)),
        SizedBox(width: 10.w),
        Expanded(child: _CaloriesCard(label: 'Estimated Calories', value: w.calories, unit: 'Kcal')),
      ],
    );
  }

  Widget _buildDescription(WorkoutModel w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details OR Description',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          w.description,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildCoachTip() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person_rounded,
                color: AppColors.primary, size: 24.w),
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Focus on maintaining proper form before increasing speed. Consistency always beats intensity.',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
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

  Widget _buildExerciseGrid(WorkoutModel w) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.6,
      ),
      itemCount: w.exercises.length,
      itemBuilder: (_, i) => _ExerciseTile(
        name: w.exercises[i].$1,
        sets: w.exercises[i].$2,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(25.w, 12.h, 25.w, 28.h),
      child: AppPrimaryButton(
        label: 'Start Workout',
        onPressed: () => context.go(RouteNames.workoutDetailV2, extra: workout),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Text(value,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          Text(unit,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diffculty',
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard(
      {required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(value,
                  style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      height: 1)),
              SizedBox(width: 4.w),
              Icon(Icons.local_fire_department_rounded,
                  color: AppColors.primary, size: 20.w),
            ],
          ),
          Text(unit,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.name, required this.sets});

  final String name;
  final String sets;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name,
                    style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700)),
                Text(sets,
                    style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.fitness_center_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 16.w),
          ),
        ],
      ),
    );
  }
}

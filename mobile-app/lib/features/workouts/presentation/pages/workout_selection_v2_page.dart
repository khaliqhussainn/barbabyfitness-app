import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../domain/models/workout_model.dart';

class WorkoutSelectionV2Page extends StatelessWidget {
  const WorkoutSelectionV2Page({super.key});

  static final _workouts = [
    WorkoutModel(
      imagePath: 'assets/images/homeimg.png',
      name: 'Full Body Strength',
      description: 'A comprehensive routine for total body conditioning. Improve cardiovascular endurance, build explosive strength and maximum calorie burn with this high-intensity full-body workout.',
      duration: '20',
      difficulty: 'Intermediate',
      calories: '320',
      exercises: [
        ('High Knees', '3 × 20'),
        ('Burpees', '3 × 10'),
        ('Jump Squats', '3 × 15'),
        ('Plank Hold', '60 Seconds'),
      ],
    ),
    WorkoutModel(
      imagePath: 'assets/images/homeimg.png',
      name: 'Metabolic burn HIIT',
      description: 'Torch fat and boost endurance with short intervals. A high-energy cardio workout that spikes your metabolism and burns maximum calories in minimum time.',
      duration: '20',
      difficulty: 'Intermediate',
      calories: '280',
      exercises: [
        ('Mountain Climbers', '3 × 20'),
        ('Jump Lunges', '3 × 12'),
        ('Box Jumps', '3 × 10'),
        ('Burpees', '3 × 10'),
      ],
    ),
    WorkoutModel(
      imagePath: 'assets/images/homeimg.png',
      name: 'Upper Body Power',
      description: 'Build strength and definition in your upper body. Target chest, shoulders, back and arms for a complete upper-body transformation.',
      duration: '25',
      difficulty: 'Advanced',
      calories: '310',
      exercises: [
        ('Push-Ups', '4 × 15'),
        ('Pike Push-Ups', '3 × 12'),
        ('Diamond Push-Ups', '3 × 10'),
        ('Tricep Dips', '3 × 15'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: _buildHeader(),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 25.w)
                    .copyWith(bottom: 24.h),
                itemCount: _workouts.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) => _WorkoutCard(
                  workout: _workouts[index],
                  onViewDetails: () => context.go(
                    RouteNames.workoutDetail,
                    extra: _workouts[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Workout Selection',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Choose a workout designed for today\'s training goals.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout, required this.onViewDetails});

  final WorkoutModel workout;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 190.h,
            child: Image.asset(
              workout.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.background,
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 48.w,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  workout.description,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 14.h),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _StatColumn(
                        label: 'Duration',
                        value: workout.duration,
                        unit: 'Minutes',
                      ),
                      _VertDivider(),
                      _DifficultyColumn(label: workout.difficulty),
                      _VertDivider(),
                      _CaloriesColumn(
                        label: 'Estimated Calories',
                        value: workout.calories,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onViewDetails,
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'View Details',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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

class _StatColumn extends StatelessWidget {
  const _StatColumn(
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
          Text(value,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 26.sp,
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

class _DifficultyColumn extends StatelessWidget {
  const _DifficultyColumn({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diffculty',
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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

class _CaloriesColumn extends StatelessWidget {
  const _CaloriesColumn({required this.label, required this.value});

  final String label;
  final String value;

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
          Row(
            children: [
              Text(value,
                  style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      height: 1)),
              SizedBox(width: 4.w),
              Icon(Icons.local_fire_department_rounded,
                  color: AppColors.primary, size: 20.w),
            ],
          ),
          Text('Kcal',
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
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
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.background,
    );
  }
}

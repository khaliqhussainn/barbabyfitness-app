import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';

class WorkoutSelectionPage extends StatefulWidget {
  const WorkoutSelectionPage({super.key});

  @override
  State<WorkoutSelectionPage> createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  int _selectedFilter = 2; // Performance selected by default (matches Figma)
  int _selectedWorkout = 1; // Build Muscle selected by default

  final _filters = ['All', 'Energy', 'Performance', 'Cardio'];

  final _workouts = [
    _WorkoutItem(
      icon: Icons.fitness_center_rounded,
      name: 'Bicep Builder',
      duration: '15 Min',
      level: 'Intermediate',
    ),
    _WorkoutItem(
      icon: Icons.sports_gymnastics,
      name: 'Build Muscle',
      duration: '12 Min',
      level: 'Advanced',
    ),
    _WorkoutItem(
      icon: Icons.directions_run_rounded,
      name: 'Cardio',
      duration: '18 Min',
      level: 'Intermediate',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildFilterRow(),
                SizedBox(height: 28.h),
                _buildRecommendedLabel(),
                SizedBox(height: 16.h),
                _buildWorkoutList(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Selection',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 21.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Plans tailored for build Muscle &\nPerformance',
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

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isActive = index == _selectedFilter;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 45.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _filters[index],
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecommendedLabel() {
    return Text(
      'Recommended Plans',
      style: GoogleFonts.inter(
        color: AppColors.primary,
        fontSize: 29.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildWorkoutList() {
    return Column(
      children: List.generate(_workouts.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _WorkoutCard(
            item: _workouts[index],
            isSelected: index == _selectedWorkout,
            onTap: () => setState(() => _selectedWorkout = index),
          ),
        );
      }),
    );
  }
}

class _WorkoutItem {
  const _WorkoutItem({
    required this.icon,
    required this.name,
    required this.duration,
    required this.level,
  });

  final IconData icon;
  final String name;
  final String duration;
  final String level;
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _WorkoutItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 117.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                item.icon,
                color: AppColors.textPrimary,
                size: 32.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.duration,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    item.level,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            _RadioDot(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.inputBorder,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.onPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

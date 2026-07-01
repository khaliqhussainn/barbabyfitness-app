import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
                SizedBox(height: 24.h),
                _buildGreetingRow(),
                SizedBox(height: 24.h),
                _buildFeaturedCard(),
                SizedBox(height: 16.h),
                _buildStatsRow(),
                SizedBox(height: 24.h),
                _buildSuggestedHeader(),
                SizedBox(height: 12.h),
                _buildSuggestedScroll(),
                SizedBox(height: 24.h),
                _buildTodaysPlanHeader(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Maryam 👋',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          width: 42.w,
          height: 42.w,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 21.w,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      height: 249.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          // Gradient overlay from bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGlassBadge('30 MIN'),
                const Spacer(),
                Text(
                  'Featured Workout',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'HIIT Endurance',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildStartButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassBadge(String label) {
    return Container(
      width: 51.w,
      height: 21.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Start Workout',
              style: GoogleFonts.inter(
                color: AppColors.onPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 45.h,
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textPrimary,
              size: 14.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Calories', '320', 'kcal'),
        SizedBox(width: 8.w),
        _buildStatCard('Workouts', '5', 'this week'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Expanded(
      child: Container(
        height: 125.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 33.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  unit,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Suggested for you',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'See All',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedScroll() {
    const workouts = [
      ('Upper Body', 'Beginner', '30 MIN'),
      ('Core Blast', 'Intermediate', '20 MIN'),
      ('Cardio Run', 'Advanced', '45 MIN'),
      ('Yoga Flow', 'Beginner', '25 MIN'),
    ];

    return SizedBox(
      height: 166.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: workouts.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final (name, level, duration) = workouts[index];
          return _buildWorkoutCard(name, level, duration);
        },
      ),
    );
  }

  Widget _buildWorkoutCard(String name, String level, String duration) {
    return Container(
      width: 109.w,
      height: 166.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.textSecondary,
              size: 18.w,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 10.w),
              SizedBox(width: 3.w),
              Text(
                duration,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            name,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                level,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 4.w),
              ...List.generate(
                3,
                (_) => Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysPlanHeader() {
    return Text(
      "Today's Plan",
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.fitness_center_rounded, 'Workouts'),
      (Icons.bar_chart_rounded, 'Progress'),
      (Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final (icon, label) = items[index];
              final isActive = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                      size: 29.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';

class WorkoutCompletePage extends StatelessWidget {
  const WorkoutCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 48.h),
                    _buildTrophy(),
                    SizedBox(height: 24.h),
                    _buildTitle(),
                    SizedBox(height: 32.h),
                    _buildStatsGrid(),
                    SizedBox(height: 24.h),
                    _buildCoachFeedback(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophy() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.emoji_events_rounded,
        color: AppColors.primary,
        size: 52.w,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Workout Complete!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Adaptive Strength Training',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(label: 'Time', value: '45:12', sub: 'Duration'),
            SizedBox(width: 12.w),
            _StatCard(label: 'Exercises', value: '12 / 12', sub: 'Completed'),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _StatCard(label: 'Completion Rate', value: '100%', sub: '', isOrange: true),
            SizedBox(width: 12.w),
            _StatCard(label: 'Intensity Score', value: '92 / 100', sub: ''),
          ],
        ),
      ],
    );
  }

  Widget _buildCoachFeedback() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coach Feedback',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Great effort today. You maintained a strong pace throughout the session. Your consistency is showing!',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 12.h, 25.w, 32.h),
      child: GestureDetector(
        onTap: () => context.go(RouteNames.dailyRecap),
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
                'Continue',
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    this.isOrange = false,
  });

  final String label;
  final String value;
  final String sub;
  final bool isOrange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: isOrange ? AppColors.primary : AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

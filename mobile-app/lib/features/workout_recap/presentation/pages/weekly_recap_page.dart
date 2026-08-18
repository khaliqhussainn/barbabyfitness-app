import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';

class WeeklyRecapPage extends StatelessWidget {
  const WeeklyRecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, top: 12.h),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 18.w,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    const AppLogo(),
                    SizedBox(height: 24.h),
                    _buildHeader(),
                    SizedBox(height: 20.h),
                    _buildStatCards(),
                    SizedBox(height: 16.h),
                    _buildDayBar(),
                    SizedBox(height: 16.h),
                    _buildSection(
                      icon: Icons.thumb_up_rounded,
                      label: 'What Went Well',
                      body:
                          'You hit 4 out of 5 planned sessions — solid consistency. Your push efforts on Tuesday and Thursday were noticeably stronger than last week.',
                    ),
                    SizedBox(height: 12.h),
                    _buildSection(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Effort Feedback',
                      body:
                          'Average effort rated at Zone 3–4. You\'re pushing hard enough to build fitness without overreaching. Great balance this week.',
                    ),
                    SizedBox(height: 12.h),
                    _buildSection(
                      icon: Icons.lightbulb_rounded,
                      label: 'Suggestion',
                      body:
                          'Try adding one extra mobility session next week. Your recovery windows look tight — 10 minutes of stretching will make a difference.',
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.w, 12.h, 25.w, 36.h),
              child: GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Container(
                  height: 54.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Back To Home',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Weekly Recap',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Here\'s how your week looked',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _StatCard(value: '4 / 5', label: 'Sessions', isOrange: false),
        SizedBox(width: 8.w),
        _StatCard(value: '1h 45m', label: 'Total Time', isOrange: false),
        SizedBox(width: 8.w),
        _StatCard(value: '7 Days', label: 'Streak', isOrange: true),
      ],
    );
  }

  Widget _buildDayBar() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    const done = [true, true, false, true, true, false, false];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          return Column(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done[i]
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  done[i] ? Icons.check_rounded : Icons.remove_rounded,
                  color: done[i]
                      ? Colors.white
                      : AppColors.textSecondary,
                  size: 16.w,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                days[i],
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String label,
    required String body,
  }) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18.w),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.isOrange,
  });

  final String value;
  final String label;
  final bool isOrange;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: isOrange ? AppColors.primary : AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

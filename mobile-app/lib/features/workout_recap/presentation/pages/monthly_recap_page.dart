import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';

class MonthlyRecapPage extends StatelessWidget {
  const MonthlyRecapPage({super.key});

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
                    _buildWeekGrid(),
                    SizedBox(height: 16.h),
                    _buildSection(
                      icon: Icons.thumb_up_rounded,
                      label: 'What Went Well',
                      body:
                          'You completed 14 sessions this month — your best month yet. Consistency in the first two weeks was outstanding, and you never skipped a Monday.',
                    ),
                    SizedBox(height: 12.h),
                    _buildSection(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Effort Feedback',
                      body:
                          'Average effort held at Zone 3 across the month. Week 3 dipped slightly — likely fatigue. Smart to ease off. Your body responds well to that pattern.',
                    ),
                    SizedBox(height: 12.h),
                    _buildSection(
                      icon: Icons.lightbulb_rounded,
                      label: 'Suggestion',
                      body:
                          'Next month, aim for 16 sessions. You\'re close to building a fully automated habit — just two extra workouts over the month will get you there.',
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
          'Monthly Recap',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Your month at a glance',
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
        _StatCard(value: '14 / 20', label: 'Sessions', isOrange: false),
        SizedBox(width: 8.w),
        _StatCard(value: '6h 10m', label: 'Total Time', isOrange: false),
        SizedBox(width: 8.w),
        _StatCard(value: '14 Days', label: 'Best Streak', isOrange: true),
      ],
    );
  }

  Widget _buildWeekGrid() {
    // weeks × days — true = worked out, false = rest
    const weeks = [
      [true, true, false, true, true, false, false],
      [true, false, true, true, true, false, true],
      [false, true, false, true, false, false, false],
      [true, true, true, false, true, false, false],
    ];
    const weekLabels = ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'];
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day headers
          Row(
            children: [
              SizedBox(width: 36.w),
              ...List.generate(7, (i) => Expanded(
                    child: Center(
                      child: Text(
                        dayLabels[i],
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10.h),
          ...List.generate(4, (w) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 36.w,
                    child: Text(
                      weekLabels[w],
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ...List.generate(7, (d) {
                    final active = weeks[w][d];
                    return Expanded(
                      child: Center(
                        child: Container(
                          width: 26.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.08),
                          ),
                          child: active
                              ? Icon(Icons.check_rounded,
                                  color: Colors.white, size: 13.w)
                              : null,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
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

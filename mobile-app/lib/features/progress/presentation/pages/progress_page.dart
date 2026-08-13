import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../providers/progress_provider.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressProvider);
    final notifier = ref.read(progressProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 28.h),
              _buildHeader(context),
              SizedBox(height: 24.h),
              _buildTabBar(state, notifier),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChartCard(state),
                    SizedBox(height: 16.h),
                    _buildStatsGrid(state),
                    SizedBox(height: 16.h),
                    _buildStreakCard(state),
                    SizedBox(height: 16.h),
                    _buildCoachInsightCard(state),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Track your fitness journey',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ProgressState state, ProgressNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            _TabPill(
              label: 'Weekly',
              isActive: state.tab == ProgressTab.weekly,
              onTap: () => notifier.setTab(ProgressTab.weekly),
            ),
            _TabPill(
              label: 'Monthly',
              isActive: state.tab == ProgressTab.monthly,
              onTap: () => notifier.setTab(ProgressTab.monthly),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(ProgressState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.tab == ProgressTab.weekly ? 'This Week' : 'This Month',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  '${state.workouts} Workouts',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 180.h,
            child: _BarChart(data: state.currentData),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ProgressState state) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFFFF6B35),
            value: '${state.calories}',
            label: 'Calories',
            unit: 'kcal',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.fitness_center_rounded,
            iconColor: AppColors.primary,
            value: '${state.workouts}',
            label: 'Workouts',
            unit: 'total',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            iconColor: const Color(0xFF3B82F6),
            value: '2h',
            label: 'Active Time',
            unit: 'this week',
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(ProgressState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.85),
            AppColors.primary.withValues(alpha: 0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('🔥', style: TextStyle(fontSize: 24.sp)),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3-Day Streak',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Keep it up! You\'re on a roll.',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoachInsightCard(ProgressState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 20.w),
              ),
              SizedBox(width: 10.w),
              Text(
                'Coach Insight',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            state.coachInsight,
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

// ── Tab Pill ─────────────────────────────────────────────
class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.unit,
  });
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 18.w),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 9.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bar Chart ─────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  const _BarChart({required this.data});

  final List<DayProgress> data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const maxBarHeight = 130.0;
        final barWidth = 27.0.w;
        final totalBars = data.length;
        final totalBarWidth = barWidth * totalBars;
        final totalGap = constraints.maxWidth - totalBarWidth;
        final gap = totalGap / (totalBars + 1);

        return Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(totalBars, (i) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (i == 0) SizedBox(width: gap),
                      _AnimatedBar(
                        fraction: data[i].value,
                        maxHeight: maxBarHeight,
                        width: barWidth,
                      ),
                      SizedBox(width: gap),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: List.generate(totalBars, (i) {
                return Row(
                  children: [
                    if (i == 0) SizedBox(width: gap),
                    SizedBox(
                      width: barWidth,
                      child: Text(
                        data[i].label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: gap),
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedBar extends StatelessWidget {
  const _AnimatedBar({
    required this.fraction,
    required this.maxHeight,
    required this.width,
  });

  final double fraction;
  final double maxHeight;
  final double width;

  @override
  Widget build(BuildContext context) {
    final orangeHeight = (fraction * maxHeight).h;
    final grayHeight = ((1 - fraction) * maxHeight).h;
    const radius = Radius.circular(6);

    return SizedBox(
      width: width,
      height: maxHeight.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            width: width,
            height: fraction == 0 ? maxHeight.h : grayHeight,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
          ),
          if (fraction > 0)
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              width: width,
              height: orangeHeight,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: radius,
                  bottomRight: radius,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

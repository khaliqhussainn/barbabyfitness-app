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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                _buildTitle(),
                SizedBox(height: 20.h),
                _buildTabBar(state, notifier),
                SizedBox(height: 20.h),
                _buildChartCard(state),
                SizedBox(height: 12.h),
                _buildStatsRow(),
                SizedBox(height: 12.h),
                _buildCoachInsightCard(state),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Your Progress',
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 45.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTabBar(ProgressState state, ProgressNotifier notifier) {
    return Column(
      children: [
        Row(
          children: [
            _TabItem(
              label: 'Weekly',
              isActive: state.tab == ProgressTab.weekly,
              onTap: () => notifier.setTab(ProgressTab.weekly),
            ),
            SizedBox(width: 32.w),
            _TabItem(
              label: 'Monthly',
              isActive: state.tab == ProgressTab.monthly,
              onTap: () => notifier.setTab(ProgressTab.monthly),
            ),
          ],
        ),
        Container(
          height: 1,
          color: AppColors.surface,
        ),
      ],
    );
  }

  Widget _buildChartCard(ProgressState state) {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: _BarChart(data: state.currentData),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('4', 'Workouts'),
        SizedBox(width: 8.w),
        _buildStatCard('1250', 'Calories'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        height: 122.h,
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
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 33.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
          Text(
            'Coach Insight',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
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

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontSize: 21.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4.h,
            width: _textWidth(label, 21),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  double _textWidth(String text, double fontSize) {
    // approximate width based on character count — actual underline matches text
    return text.length * fontSize * 0.55;
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.data});

  final List<DayProgress> data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const maxBarHeight = 158.0;
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
    const radius = Radius.circular(4);

    return SizedBox(
      width: width,
      height: maxHeight.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Gray portion on top
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            width: width,
            height: fraction == 0 ? maxHeight.h : grayHeight,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.35),
              borderRadius: const BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
          ),
          // Orange portion on bottom
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

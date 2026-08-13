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
        child: Stack(
          children: [
            Positioned(
              top: 16.h,
              right: 20.w,
              child: GestureDetector(
                onTap: () => context.go(RouteNames.home),
                child: Icon(Icons.close_rounded,
                    color: AppColors.textSecondary, size: 24.w),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 52.h),
                        _buildTrophyIcon(),
                        SizedBox(height: 20.h),
                        _buildTitle(),
                        SizedBox(height: 24.h),
                        _buildStatsGrid(),
                        SizedBox(height: 16.h),
                        _buildCoachFeedback(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
                _buildContinueButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrophyIcon() {
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: CustomPaint(
        painter: _TrophyGlowPainter(),
        child: Center(
          child: Icon(
            Icons.emoji_events_rounded,
            color: AppColors.primary,
            size: 52.w,
          ),
        ),
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
        SizedBox(height: 4.h),
        Text(
          'Adaptive Strength Training',
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

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _StatCard(label: 'Time', value: 'Duration: 45:12'),
            SizedBox(width: 12.w),
            _StatCard(label: 'Exercises', value: '12 / 12 Exercises'),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _StatCard(label: 'Completion Rate', value: '100%', highlight: true),
            SizedBox(width: 12.w),
            _StatCard(label: 'Intensity Score', value: '92 / 100'),
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
          Row(
            children: [
              Icon(Icons.smart_toy_rounded,
                  color: AppColors.primary, size: 20.w),
              SizedBox(width: 8.w),
              Text(
                'Coach Feedback',
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
            'Great effort today. You maintained a strong pace.',
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

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 12.h, 25.w, 36.h),
      child: GestureDetector(
        onTap: () => context.go(RouteNames.dailyRecap),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.center,
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
              SizedBox(width: 8.w),
              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18.w),
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
    this.highlight = false,
  });
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
                color: highlight ? AppColors.primary : AppColors.textPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrophyGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(
      center,
      radius + 10,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    canvas.drawCircle(center, radius, Paint()..color = AppColors.background);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
    );
  }

  @override
  bool shouldRepaint(_TrophyGlowPainter old) => false;
}

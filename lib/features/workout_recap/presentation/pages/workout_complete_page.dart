import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';

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
            _buildCloseButton(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    _buildCheckCircle(),
                    SizedBox(height: 28.h),
                    _buildTitle(),
                    SizedBox(height: 36.h),
                    _buildTimer(),
                    SizedBox(height: 36.h),
                    _buildStatsRow(),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: 'View Recap',
                onPressed: () {},
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(top: 16.h, right: 20.w),
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(
            Icons.close_rounded,
            color: AppColors.textSecondary,
            size: 24.w,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckCircle() {
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: CustomPaint(
        painter: _GlowCirclePainter(),
        child: Center(
          child: Icon(
            Icons.check_rounded,
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
          'Workout Complete',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Great Effort today Username',
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

  Widget _buildTimer() {
    return Text(
      '14 : 30',
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 69.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 4,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatCard(value: '320', label: 'Calories'),
        SizedBox(width: 12.w),
        _StatCard(value: '145 BPM', label: 'Avg Heart Rate'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Outer glow
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 6, glowPaint);

    // Dark fill
    final fillPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    // Orange stroke ring
    final ringPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, ringPaint);

    // Subtle inner dark ring (gray border just inside orange)
    final innerRingPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 5, innerRingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

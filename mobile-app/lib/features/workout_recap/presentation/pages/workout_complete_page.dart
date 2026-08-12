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
            // X close button top-right
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
                        SizedBox(height: 56.h),
                        _buildCheckCircle(),
                        SizedBox(height: 24.h),
                        _buildTitle(),
                        SizedBox(height: 28.h),
                        _buildTimer(),
                        SizedBox(height: 24.h),
                        _buildStatCards(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckCircle() {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: CustomPaint(
        painter: _GlowCheckPainter(),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: AppColors.primary,
            size: 48.w,
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
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Great Effort today Username',
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

  Widget _buildTimer() {
    return Text(
      '14 : 30',
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 56.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _StatCard(value: '320', label: 'Calories'),
        SizedBox(width: 12.w),
        _StatCard(value: '145 BPM', label: 'Avg Heart Rate'),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
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
          child: Text(
            'View Recap',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
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
        height: 88.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
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

class _GlowCheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // outer glow
    canvas.drawCircle(
      center,
      radius + 10,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // dark fill
    canvas.drawCircle(center, radius, Paint()..color = AppColors.background);

    // orange ring
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
  bool shouldRepaint(_GlowCheckPainter old) => false;
}

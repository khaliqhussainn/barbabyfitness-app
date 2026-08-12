import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../providers/workout_session_provider.dart';

class RealTimeCoachingPage extends ConsumerStatefulWidget {
  const RealTimeCoachingPage({super.key});

  @override
  ConsumerState<RealTimeCoachingPage> createState() =>
      _RealTimeCoachingPageState();
}

class _RealTimeCoachingPageState extends ConsumerState<RealTimeCoachingPage>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _endWorkout() {
    ref.read(workoutSessionProvider.notifier).reset();
    context.go(RouteNames.workoutComplete);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(workoutSessionProvider);
    final notifier = ref.read(workoutSessionProvider.notifier);

    // Pause waveform when session is paused
    if (session.isPaused) {
      _waveController.stop();
    } else if (!_waveController.isAnimating) {
      _waveController.repeat();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildTopBar(session, notifier),
            SizedBox(height: 32.h),
            _buildTimer(session),
            SizedBox(height: 8.h),
            _buildBpmRow(session),
            const Spacer(),
            _buildGlowCircle(session),
            const Spacer(),
            _buildWaveform(session),
            SizedBox(height: 28.h),
            _buildEndButton(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(WorkoutSessionState session, WorkoutSessionNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconBtn(
            icon: session.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            onTap: notifier.togglePause,
          ),
          _IconBtn(
            icon: session.isMuted
                ? Icons.volume_off_rounded
                : Icons.volume_up_outlined,
            onTap: notifier.toggleMute,
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(WorkoutSessionState session) {
    return Text(
      session.timerDisplay,
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 69.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildBpmRow(WorkoutSessionState session) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${session.bpm} BPM',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 6.w),
        AnimatedBuilder(
          animation: _glowController,
          builder: (_, __) => Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF22C55E),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF22C55E)
                      .withValues(alpha: 0.4 + 0.3 * _glowController.value),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowCircle(WorkoutSessionState session) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (_, __) {
        return SizedBox(
          width: 220.w,
          height: 220.w,
          child: CustomPaint(
            painter: _GlowRingPainter(
              glowIntensity: 0.6 + 0.4 * _glowController.value,
            ),
            child: Center(
              child: Text(
                session.zone.label,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 29.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveform(WorkoutSessionState session) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (_, __) => CustomPaint(
          size: Size(double.infinity, 58.h),
          painter: _WaveformPainter(
            animValue: _waveController.value,
            isActive: !session.isPaused && !session.isMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildEndButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: _endWorkout,
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(100.r),
          ),
          alignment: Alignment.center,
          child: Text(
            'End Workout',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.textPrimary, size: 24.w),
    );
  }
}

// ── Painters ─────────────────────────────────────────────────────────────────

class _GlowRingPainter extends CustomPainter {
  const _GlowRingPainter({required this.glowIntensity});
  final double glowIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Outer ambient glow
    canvas.drawCircle(
      center,
      radius + 12,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.25 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    // Inner glow just outside ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.45 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Dark fill
    canvas.drawCircle(
      center,
      radius - 5,
      Paint()
        ..color = AppColors.background
        ..style = PaintingStyle.fill,
    );

    // Orange ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );
  }

  @override
  bool shouldRepaint(_GlowRingPainter old) =>
      old.glowIntensity != glowIntensity;
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({required this.animValue, required this.isActive});
  final double animValue;
  final bool isActive;

  static const _barCount = 30;
  static const _barWidth = 5.0;
  static const _barGap = 4.0;

  // Pre-computed per-bar phase offsets so each bar animates independently
  static final _phases = List.generate(
    _barCount,
    (i) => i * (2 * pi / _barCount),
  );

  // Envelope: taller in the middle, shorter at edges
  static final _envelope = List.generate(
    _barCount,
    (i) {
      final t = i / (_barCount - 1); // 0 → 1
      return 0.3 + 0.7 * sin(t * pi);
    },
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _barWidth;

    final totalWidth = _barCount * _barWidth + (_barCount - 1) * _barGap;
    final startX = (size.width - totalWidth) / 2;
    final midY = size.height / 2;
    final maxHalfH = size.height / 2;

    for (int i = 0; i < _barCount; i++) {
      final wave = isActive
          ? sin(animValue * 2 * pi + _phases[i])
          : 0.15;
      final halfH = maxHalfH * _envelope[i] * ((wave + 1) / 2 * 0.8 + 0.2);
      final x = startX + i * (_barWidth + _barGap) + _barWidth / 2;
      canvas.drawLine(
        Offset(x, midY - halfH),
        Offset(x, midY + halfH),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.animValue != animValue || old.isActive != isActive;
}

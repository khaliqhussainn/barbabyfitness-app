import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) context.go(RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 80.w,
          height: 80.w,
          child: const CustomPaint(
            painter: _RingLogoPainter(),
          ),
        ),
      ),
    );
  }
}

class _RingLogoPainter extends CustomPainter {
  const _RingLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round;

    // Outer arc — open ring with gap at bottom-left (~300°)
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.04,
        size.width * 0.92,
        size.height * 0.92,
      ),
      _rad(120),
      _rad(300),
      false,
      outerPaint,
    );

    // Inner arc — smaller concentric ring (thinner)
    final innerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.24,
        size.height * 0.24,
        size.width * 0.52,
        size.height * 0.52,
      ),
      _rad(130),
      _rad(290),
      false,
      innerPaint,
    );
  }

  double _rad(double degrees) => degrees * pi / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

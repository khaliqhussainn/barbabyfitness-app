import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';

enum _Plan { monthly, annual }

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  _Plan _selected = _Plan.annual;

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
                    SizedBox(height: 16.h),
                    _buildCrownIcon(),
                    SizedBox(height: 24.h),
                    _buildTitle(),
                    SizedBox(height: 32.h),
                    _buildFeatureList(),
                    SizedBox(height: 36.h),
                    _buildPricingRow(),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: 'Upgrade Now',
                onPressed: () {},
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Restore Purchases',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 28.h),
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

  Widget _buildCrownIcon() {
    return SizedBox(
      width: 72.w,
      height: 60.h,
      child: CustomPaint(
        painter: _CrownPainter(),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Unlock Full\nCoaching',
      textAlign: TextAlign.center,
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 33.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
    );
  }

  Widget _buildFeatureList() {
    const features = [
      'Full Adaptive Coaching',
      'Premium Coach Identities',
      'Advanced Performance Recaps',
    ];

    return Column(
      children: features
          .map((f) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.onPrimary,
                        size: 15.w,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Text(
                      f,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildPricingRow() {
    return Row(
      children: [
        _PricingCard(
          plan: 'Monthly',
          price: '\$19',
          period: 'per month',
          isSelected: _selected == _Plan.monthly,
          onTap: () => setState(() => _selected = _Plan.monthly),
        ),
        SizedBox(width: 12.w),
        _PricingCard(
          plan: 'Annual',
          price: '\$9',
          period: 'per month',
          isSelected: _selected == _Plan.annual,
          onTap: () => setState(() => _selected = _Plan.annual),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.plan,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  final String plan;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 136.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                plan,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'at ',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: price,
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimary,
                        fontSize: 33.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                period,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final strokePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final path = _crownPath(size);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, strokePaint);
  }

  Path _crownPath(Size size) {
    final w = size.width;
    final h = size.height;

    // base bar bottom
    const baseTop = 0.72;
    const baseBottom = 0.85;
    const gap = 0.05;

    final path = Path();

    // Crown outline: left bottom → left spike → inner dip → center spike → inner dip → right spike → right bottom
    path.moveTo(w * 0.08, h * baseTop);

    // left spike
    path.lineTo(w * 0.08, h * 0.05);
    path.lineTo(w * 0.30, h * 0.45);

    // center spike
    path.lineTo(w * 0.50, h * 0.0);
    path.lineTo(w * 0.70, h * 0.45);

    // right spike
    path.lineTo(w * 0.92, h * 0.05);
    path.lineTo(w * 0.92, h * baseTop);

    path.close();

    // base rectangle (two horizontal lines with a gap treated as separate path)
    final basePath = Path();
    basePath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.08, h * baseTop + gap * h, w * 0.92, h * baseBottom),
      const Radius.circular(2),
    ));

    return Path.combine(PathOperation.union, path, basePath);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

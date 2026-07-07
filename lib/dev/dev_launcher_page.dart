import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/routes/route_names.dart';
import '../config/theme/app_colors.dart';

class DevLauncherPage extends StatelessWidget {
  const DevLauncherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🛠 Dev Launcher',
                    style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Debug only — not visible in release builds',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.surface),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                children: [
                  _SectionHeader('Auth'),
                  _RouteRow(label: 'Splash', route: RouteNames.splash),
                  _RouteRow(label: 'Onboarding', route: RouteNames.onboarding),
                  _RouteRow(label: 'Login', route: RouteNames.login),
                  _RouteRow(label: 'Sign Up', route: RouteNames.signup),
                  _RouteRow(label: 'Forgot Password', route: RouteNames.forgotPassword),

                  _SectionHeader('Onboarding Flow'),
                  _RouteRow(label: 'Coach Selection', route: RouteNames.coachSelection),
                  _RouteRow(label: 'Voice Selection', route: RouteNames.voiceSelection),
                  _RouteRow(label: 'Fitness Level', route: RouteNames.fitnessLevel),
                  _RouteRow(label: 'Main Goal', route: RouteNames.mainGoal),
                  _RouteRow(label: 'Personal Details', route: RouteNames.personalDetails),
                  _RouteRow(label: 'Device Permissions', route: RouteNames.devicePermissions),
                  _RouteRow(label: 'Calibration Workout', route: RouteNames.calibrationWorkout),

                  _SectionHeader('Main App'),
                  _RouteRow(label: 'Home', route: RouteNames.home),
                  _RouteRow(label: 'Workout Selection', route: RouteNames.workoutSelection),
                  _RouteRow(label: 'Progress', route: RouteNames.progress),
                  _RouteRow(label: 'Profile', route: RouteNames.profile),

                  _SectionHeader('Workout Flow'),
                  _RouteRow(label: 'Workout Complete', route: RouteNames.workoutComplete),
                  _RouteRow(label: 'Daily Recap', route: RouteNames.dailyRecap),

                  _SectionHeader('Misc'),
                  _RouteRow(label: 'Paywall', route: RouteNames.paywall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          color: AppColors.primary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.label, required this.route});
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: 48.h,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                Text(
                  route,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 12.w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

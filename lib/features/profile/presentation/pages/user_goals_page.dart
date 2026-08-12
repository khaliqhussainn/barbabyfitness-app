import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../providers/user_goals_provider.dart';

class UserGoalsPage extends ConsumerWidget {
  const UserGoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userGoalsProvider);
    final notifier = ref.read(userGoalsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            _buildBackButton(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildHeader(),
                    SizedBox(height: 32.h),
                    _buildSectionLabel('Main Fitness Goal'),
                    SizedBox(height: 16.h),
                    _buildGoalCards(state, notifier),
                    SizedBox(height: 32.h),
                    _buildSectionLabel('Daily Coaching Focus'),
                    SizedBox(height: 16.h),
                    _buildFocusPills(state, notifier),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: 'Save Preferences',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textPrimary,
            size: 28.w,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User's Goals",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Adjust your priorities anytime',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: AppColors.primary,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildGoalCards(UserGoalsState state, UserGoalsNotifier notifier) {
    return Row(
      children: [
        _GoalCard(
          icon: Icons.bolt_rounded,
          label: 'Increase\nStrength',
          isSelected: state.fitnessGoal == FitnessGoal.increaseStrength,
          onTap: () => notifier.setFitnessGoal(FitnessGoal.increaseStrength),
        ),
        SizedBox(width: 12.w),
        _GoalCard(
          icon: Icons.sports_gymnastics,
          label: 'Build\nMuscle',
          isSelected: state.fitnessGoal == FitnessGoal.buildMuscle,
          onTap: () => notifier.setFitnessGoal(FitnessGoal.buildMuscle),
        ),
      ],
    );
  }

  Widget _buildFocusPills(UserGoalsState state, UserGoalsNotifier notifier) {
    final focuses = [
      (CoachingFocus.energy, 'Energy'),
      (CoachingFocus.consistency, 'Consistency'),
      (CoachingFocus.recovery, 'Recovery'),
      (CoachingFocus.performance, 'Performance'),
    ];

    return Column(
      children: [
        Row(
          children: [
            _FocusPill(
              label: focuses[0].$2,
              isSelected: state.coachingFocus == focuses[0].$1,
              onTap: () => notifier.setCoachingFocus(focuses[0].$1),
            ),
            SizedBox(width: 12.w),
            _FocusPill(
              label: focuses[1].$2,
              isSelected: state.coachingFocus == focuses[1].$1,
              onTap: () => notifier.setCoachingFocus(focuses[1].$1),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _FocusPill(
              label: focuses[2].$2,
              isSelected: state.coachingFocus == focuses[2].$1,
              onTap: () => notifier.setCoachingFocus(focuses[2].$1),
            ),
            SizedBox(width: 12.w),
            _FocusPill(
              label: focuses[3].$2,
              isSelected: state.coachingFocus == focuses[3].$1,
              onTap: () => notifier.setCoachingFocus(focuses[3].$1),
            ),
          ],
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 155.h,
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
              Icon(
                icon,
                color: AppColors.textPrimary,
                size: 44.w,
              ),
              SizedBox(height: 14.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusPill extends StatelessWidget {
  const _FocusPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

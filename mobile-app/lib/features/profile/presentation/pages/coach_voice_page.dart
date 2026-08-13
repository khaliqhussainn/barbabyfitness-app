import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../onboarding_flow/domain/entities/voice_model.dart';
import '../../../onboarding_flow/presentation/providers/voice_selection_provider.dart';

class CoachVoicePage extends ConsumerWidget {
  const CoachVoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(voiceSelectionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _buildHeader(),
                    SizedBox(height: 28.h),
                    ...voices.map((voice) {
                      final isSelected = voice.id == selectedId;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _VoiceCard(
                          voice: voice,
                          isSelected: isSelected,
                          onTap: () => ref
                              .read(voiceSelectionProvider.notifier)
                              .state = voice.id,
                        ),
                      );
                    }),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: 'Save Voice',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Coach voice updated',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                  context.pop();
                },
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.chevron_left_rounded,
                  color: AppColors.textPrimary, size: 28.w),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'Coach Voice',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Voice Tone',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Choose the vocal style for your AI coach',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _VoiceCard extends StatelessWidget {
  const _VoiceCard({
    required this.voice,
    required this.isSelected,
    required this.onTap,
  });

  final VoiceModel voice;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 72.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 22.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                voice.label,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.inputBorder,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.circle, color: Colors.white, size: 9.w)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

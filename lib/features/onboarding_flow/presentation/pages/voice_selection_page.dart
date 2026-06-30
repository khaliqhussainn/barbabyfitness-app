import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../domain/entities/voice_model.dart';
import '../providers/voice_selection_provider.dart';

class VoiceSelectionPage extends ConsumerWidget {
  const VoiceSelectionPage({super.key});

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
            SizedBox(height: 48.h),
            _buildHeader(),
            SizedBox(height: 32.h),
            _buildVoiceOptions(ref, selectedId),
            const Spacer(),
            _buildPaginationDots(),
            SizedBox(height: 24.h),
            _buildConfirmButton(context),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => context.go(RouteNames.coachSelection),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 18.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Text(
            'Select Voice Tone',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Choose the vocal style for your guide',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceOptions(WidgetRef ref, VoiceId selectedId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: voices.map((voice) {
          final isSelected = voice.id == selectedId;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _VoiceOptionRow(
              voice: voice,
              isSelected: isSelected,
              onTap: () =>
                  ref.read(voiceSelectionProvider.notifier).state = voice.id,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        final isActive = index == 1;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 52.w : 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AppPrimaryButton(
        label: 'Confirm Voice',
        onPressed: () => context.go(RouteNames.home),
      ),
    );
  }
}

class _VoiceOptionRow extends StatelessWidget {
  const _VoiceOptionRow({
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
        width: 354.w,
        height: 120.h,
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
            Icon(
              Icons.play_arrow_rounded,
              color: const Color(0xFFD9D9D9),
              size: 36.w,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                voice.label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _RadioCircle(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFF262626),
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.circle, color: AppColors.onPrimary, size: 10.w)
          : null,
    );
  }
}

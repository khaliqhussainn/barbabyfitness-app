import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../providers/device_permissions_provider.dart';

class DevicePermissionsPage extends ConsumerWidget {
  const DevicePermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(devicePermissionsProvider);
    final notifier = ref.read(devicePermissionsProvider.notifier);

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _PermissionCard(
                    icon: Icons.favorite_border_rounded,
                    title: 'Apple Health / Google Fit',
                    subtitle: 'Access heart rate and save workouts',
                    value: permissions.healthEnabled,
                    onToggle: notifier.toggleHealth,
                  ),
                  SizedBox(height: 12.h),
                  _PermissionCard(
                    icon: Icons.volume_up_outlined,
                    title: 'Background Coaching',
                    subtitle: 'Allow audio prompts while phone is locked',
                    value: permissions.backgroundCoachingEnabled,
                    onToggle: notifier.toggleBackgroundCoaching,
                  ),
                ],
              ),
            ),
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
          onTap: () => context.go(RouteNames.personalDetails),
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
            'Device Permissions',
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
            'To track your effort and provide live coaching,\nplease enable following.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (index) {
        final isActive = index == 5;
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
        label: 'Allow & Continue',
        onPressed: () => context.go(RouteNames.home),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onToggle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354.w,
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 36.w,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _CustomToggle(value: value, onToggle: onToggle),
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  const _CustomToggle({required this.value, required this.onToggle});

  final bool value;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: value ? AppColors.primary : AppColors.inputBorder,
            width: 1.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: AppColors.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

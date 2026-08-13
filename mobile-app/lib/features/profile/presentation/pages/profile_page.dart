import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../onboarding_flow/domain/entities/voice_model.dart';
import '../../../onboarding_flow/presentation/providers/voice_selection_provider.dart';
import '../providers/profile_provider.dart';

final _notificationsProvider = StateProvider<bool>((ref) => true);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsOn = ref.watch(_notificationsProvider);
    final profile = ref.watch(profileProvider);
    final voiceId = ref.watch(voiceSelectionProvider);
    final voiceLabel = voices
        .firstWhere((v) => v.id == voiceId, orElse: () => voices.first)
        .label
        .split(' ')
        .first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              _buildTitle(),
              SizedBox(height: 24.h),
              _buildUserRow(context, profile),
              SizedBox(height: 20.h),
              _buildPremiumCard(context),
              SizedBox(height: 28.h),
              _buildSectionLabel('Connected Devices'),
              SizedBox(height: 12.h),
              _buildDeviceCard(
                label: 'Apple Health',
                connected: true,
                onTap: () => _showAppleHealthSheet(context),
              ),
              SizedBox(height: 8.h),
              _buildDeviceCard(
                label: 'SmartWatch',
                connected: false,
                onTap: () => _showSmartWatchSheet(context),
              ),
              SizedBox(height: 28.h),
              _buildSectionLabel('Preferences'),
              SizedBox(height: 12.h),
              _buildValueRow(
                label: 'Coach Voice',
                value: voiceLabel,
                onTap: () => context.push(RouteNames.coachVoice),
              ),
              SizedBox(height: 8.h),
              _buildValueRow(
                label: 'Main Goal',
                value: 'Build Muscle',
                onTap: () => context.push(RouteNames.userGoals),
              ),
              SizedBox(height: 8.h),
              _buildToggleRow(
                label: 'Notifications',
                value: notificationsOn,
                onToggle: () => ref
                    .read(_notificationsProvider.notifier)
                    .state = !notificationsOn,
              ),
              SizedBox(height: 28.h),
              _buildSectionLabel('Account'),
              SizedBox(height: 12.h),
              _buildActionRow(
                label: 'Logout',
                icon: Icons.logout_rounded,
                color: AppColors.textPrimary,
                onTap: () => _showLogoutDialog(context),
              ),
              SizedBox(height: 8.h),
              _buildActionRow(
                label: 'Delete Account',
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444),
                onTap: () => _showDeleteDialog(context),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Profile',
      style: GoogleFonts.outfit(
        color: AppColors.textPrimary,
        fontSize: 37.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, ProfileState profile) {
    return Row(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.antiAlias,
          child: profile.imagePath != null
              ? Image.file(File(profile.imagePath!), fit: BoxFit.cover)
              : Icon(Icons.person_outline_rounded,
                  color: AppColors.textSecondary, size: 32.w),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.username,
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                profile.email,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push(RouteNames.editProfile),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              'Edit',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.paywall),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.85),
              const Color(0xFFFF8C00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Unlock full coaching & advanced recaps',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 22.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: AppColors.primary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _showAppleHealthSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _AppleHealthSheet(),
    );
  }

  void _showSmartWatchSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SmartWatchSheet(),
    );
  }

  Widget _buildDeviceCard({required String label, required bool connected, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      height: 61.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: connected
                      ? const Color(0xFF22C55E)
                      : AppColors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                connected ? 'Connected' : 'Not Connected',
                style: GoogleFonts.inter(
                  color: connected
                      ? const Color(0xFF22C55E)
                      : AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildValueRow({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 61.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (onTap != null) ...[
                  SizedBox(width: 6.w),
                  Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary, size: 18.w),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required VoidCallback onToggle,
  }) {
    return Container(
      width: double.infinity,
      height: 61.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
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
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
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
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 61.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.w),
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: color,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.login);
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Delete Account',
          style: GoogleFonts.outfit(
            color: const Color(0xFFEF4444),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.login);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: const Color(0xFFEF4444),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Apple Health Bottom Sheet ─────────────────────────────
class _AppleHealthSheet extends StatefulWidget {
  const _AppleHealthSheet();

  @override
  State<_AppleHealthSheet> createState() => _AppleHealthSheetState();
}

class _AppleHealthSheetState extends State<_AppleHealthSheet> {
  bool _steps = true;
  bool _heartRate = true;
  bool _calories = false;
  bool _sleep = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.favorite_rounded, color: const Color(0xFFFF2D55), size: 24.w),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apple Health',
                      style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700)),
                  Text('Choose what data to sync',
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 12.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _ToggleRow(label: 'Steps', icon: Icons.directions_walk_rounded, value: _steps, onChanged: (v) => setState(() => _steps = v)),
          _ToggleRow(label: 'Heart Rate', icon: Icons.monitor_heart_rounded, value: _heartRate, onChanged: (v) => setState(() => _heartRate = v)),
          _ToggleRow(label: 'Active Calories', icon: Icons.local_fire_department_rounded, value: _calories, onChanged: (v) => setState(() => _calories = v)),
          _ToggleRow(label: 'Sleep', icon: Icons.bedtime_rounded, value: _sleep, onChanged: (v) => setState(() => _sleep = v)),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFF2D55),
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text('Connect Apple Health',
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Smart Watch Bottom Sheet ──────────────────────────────
class _SmartWatchSheet extends StatefulWidget {
  const _SmartWatchSheet();

  @override
  State<_SmartWatchSheet> createState() => _SmartWatchSheetState();
}

class _SmartWatchSheetState extends State<_SmartWatchSheet> {
  int _selectedWatch = -1;

  static const _watches = [
    ('Apple Watch', 'Series 8 / Ultra'),
    ('Garmin', 'Forerunner / Fenix'),
    ('Samsung Galaxy Watch', 'Watch 5 / 6'),
    ('Fitbit', 'Sense / Versa'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.watch_rounded, color: const Color(0xFF3B82F6), size: 24.w),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Smart Watch',
                      style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700)),
                  Text('Select your watch brand',
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 12.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...List.generate(_watches.length, (i) {
            final (name, subtitle) = _watches[i];
            final selected = _selectedWatch == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedWatch = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: selected ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600)),
                          Text(subtitle,
                              style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 11.sp)),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 20.w),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: _selectedWatch >= 0 ? () => Navigator.of(context).pop() : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                color: _selectedWatch >= 0
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Connect Watch',
                style: GoogleFonts.outfit(
                  color: _selectedWatch >= 0
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle Row ────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow(
      {required this.label,
      required this.icon,
      required this.value,
      required this.onChanged});
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.textSecondary, size: 18.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(label,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../auth/data/auth_service.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _usernameController = TextEditingController(text: profile.username);
    _emailController = TextEditingController(text: profile.email);
    _ageController = TextEditingController(text: profile.age);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    ref.read(profileProvider.notifier).setImage(picked.path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Uploading photo...', style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: AppColors.surface,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 10),
    ));
    final url = await AuthService.uploadAvatar(picked.path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (url != null) {
      ref.read(profileProvider.notifier).setAvatarUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Photo uploaded successfully', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Photo upload failed — check server connection', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _save() async {
    final newPass = _passwordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();
    if (newPass.isNotEmpty && newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _saving = true);
    final result = await AuthService.updateProfile(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      age: _ageController.text.trim(),
      currentPassword: newPass.isNotEmpty ? _currentPasswordController.text.trim() : null,
      newPassword: newPass.isNotEmpty ? newPass : null,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (result.success) {
      ref.read(profileProvider.notifier).update(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        age: _ageController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully', style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ));
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.message, style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

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
                    _buildAvatar(profile),
                    SizedBox(height: 32.h),
                    _buildSectionLabel('Personal Info'),
                    SizedBox(height: 14.h),
                    _buildField(
                      label: 'Username',
                      controller: _usernameController,
                      icon: Icons.person_outline_rounded,
                    ),
                    SizedBox(height: 12.h),
                    _buildField(
                      label: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12.h),
                    _buildField(
                      label: 'Age',
                      controller: _ageController,
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 28.h),
                    _buildSectionLabel('Change Password'),
                    SizedBox(height: 14.h),
                    _buildPasswordField(
                      label: 'Current Password',
                      controller: _currentPasswordController,
                      obscure: _obscureCurrent,
                      onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    SizedBox(height: 12.h),
                    _buildPasswordField(
                      label: 'New Password',
                      controller: _passwordController,
                      obscure: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    SizedBox(height: 12.h),
                    _buildPasswordField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      obscure: _obscureConfirm,
                      onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: _saving ? 'Saving...' : 'Save Changes',
                onPressed: _saving ? () {} : _save,
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
            'Edit Profile',
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

  Widget _buildAvatar(ProfileState profile) {
    final baseUrl = 'http://192.168.100.25:3000';
    Widget avatarChild;
    if (profile.imagePath != null) {
      avatarChild = Image.file(File(profile.imagePath!), fit: BoxFit.cover);
    } else if (profile.avatarUrl != null) {
      avatarChild = Image.network('$baseUrl${profile.avatarUrl}', fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 44.w));
    } else {
      avatarChild = Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 44.w);
    }

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: avatarChild,
            ),
            Container(
              width: 30.w,
              height: 30.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 16.w),
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
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 58.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      height: 58.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded,
              color: AppColors.textSecondary, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }
}

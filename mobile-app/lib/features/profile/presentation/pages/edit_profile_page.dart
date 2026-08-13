import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController(text: 'User');
  final _emailController = TextEditingController(text: 'username@hosting.com');
  final _ageController = TextEditingController(text: '25');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildAvatar(),
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
                      label: 'New Password',
                      controller: _passwordController,
                      obscure: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    SizedBox(height: 12.h),
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: AppPrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Profile updated successfully',
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
            child: Icon(Icons.chevron_left_rounded,
                color: AppColors.textPrimary, size: 28.w),
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

  Widget _buildAvatar() {
    return Center(
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
            child: Icon(Icons.person_outline_rounded,
                color: AppColors.textSecondary, size: 44.w),
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

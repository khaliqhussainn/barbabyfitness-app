import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/auth_field.dart';
import '../../data/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _success = false;
  String? _passwordError;
  String? _confirmError;
  String? _serverError;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validateConfirm(String v) {
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    final passErr = _validatePassword(_passwordController.text);
    final confErr = _validateConfirm(_confirmController.text);
    setState(() {
      _passwordError = passErr;
      _confirmError = confErr;
      _serverError = null;
    });
    if (passErr != null || confErr != null) return;

    setState(() => _isLoading = true);
    final result = await AuthService.resetPassword(
      token: widget.token,
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      setState(() => _success = true);
    } else {
      setState(() => _serverError = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 64.h),
              const AppLogo(),
              SizedBox(height: 40.h),
              Text(
                'Reset Password',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8.h),
              if (!_success) ...[
                Text(
                  'Enter your new password below.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                AuthField(
                  hintText: 'New Password',
                  prefixIcon: Icons.key_outlined,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20.w,
                      ),
                    ),
                  ),
                  hasError: _passwordError != null,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = _validatePassword(_passwordController.text));
                    }
                  },
                ),
                if (_passwordError != null) _buildError(_passwordError!),
                SizedBox(height: 14.h),
                AuthField(
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.key_outlined,
                  controller: _confirmController,
                  obscureText: _obscureConfirm,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20.w,
                      ),
                    ),
                  ),
                  hasError: _confirmError != null,
                  onChanged: (_) {
                    if (_confirmError != null) {
                      setState(() => _confirmError = _validateConfirm(_confirmController.text));
                    }
                  },
                ),
                if (_confirmError != null) _buildError(_confirmError!),
                SizedBox(height: 24.h),
                if (_serverError != null) ...[
                  _buildError(_serverError!),
                  SizedBox(height: 12.h),
                ],
                AppPrimaryButton(
                  label: _isLoading ? 'Updating…' : 'Update Password',
                  onPressed: _isLoading ? null : _submit,
                ),
              ] else ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 52.w),
                      SizedBox(height: 16.h),
                      Text(
                        'Password Updated!',
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You can now sign in with your new password.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                AppPrimaryButton(
                  label: 'Back to Sign In',
                  onPressed: () => context.go(RouteNames.login),
                ),
              ],
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 4.w),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.error, size: 13.w),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(color: AppColors.error, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

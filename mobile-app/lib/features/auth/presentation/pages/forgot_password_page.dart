import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/auth_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\-.+]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email address';
    return null;
  }

  void _submit() {
    final err = _validateEmail(_emailController.text);
    setState(() => _emailError = err);
    if (err != null) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _submitted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80.h),
              const AppLogo(),
              SizedBox(height: 56.h),
              _buildTitle(),
              SizedBox(height: 24.h),
              _submitted ? _buildSuccessCard(context) : _buildCard(context),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        'Forgot Password',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 32.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your registered email address to receive password reset instructions.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.55,
              ),
            ),
            SizedBox(height: 20.h),
            AuthField(
              hintText: 'Email',
              prefixIcon: Icons.alternate_email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              hasError: _emailError != null,
              onChanged: (_) {
                if (_emailError != null) {
                  setState(() =>
                      _emailError = _validateEmail(_emailController.text));
                }
              },
            ),
            if (_emailError != null)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 16.w),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppColors.error, size: 13.w),
                    SizedBox(width: 4.w),
                    Text(
                      _emailError!,
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20.h),
            AppPrimaryButton(
              label: _isLoading ? 'Sending…' : 'Reset Password',
              onPressed: _isLoading ? null : _submit,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => context.go(RouteNames.login),
              child: Text(
                'Back to Sign In',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.mark_email_read_outlined,
                  color: const Color(0xFF22C55E), size: 32.w),
            ),
            SizedBox(height: 20.h),
            Text(
              'Check your inbox',
              style: GoogleFonts.outfit(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'We sent a password reset link to\n${_emailController.text.trim()}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),
            AppPrimaryButton(
              label: 'Back to Sign In',
              onPressed: () => context.go(RouteNames.login),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => setState(() => _submitted = false),
              child: Text(
                'Resend email',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

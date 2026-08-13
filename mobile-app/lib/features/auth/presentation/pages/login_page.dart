import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/or_divider.dart';
import '../../../../shared/widgets/social_login_row.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\-.+]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _submit() {
    final emailErr = _validateEmail(_emailController.text);
    final passErr = _validatePassword(_passwordController.text);
    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });
    if (emailErr != null || passErr != null) return;

    setState(() => _isLoading = true);
    // Simulate a brief loading state before navigating
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go(RouteNames.home);
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
              SizedBox(height: 64.h),
              const AppLogo(),
              SizedBox(height: 40.h),
              _buildTitle(),
              SizedBox(height: 28.h),
              _buildCard(context),
              SizedBox(height: 28.h),
              _buildContinueWithoutLogin(context),
              SizedBox(height: 16.h),
              _buildFooter(context),
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
        'Sign In to your Profile',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          color: AppColors.textPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmailField(),
              SizedBox(height: 14.h),
              _buildPasswordField(),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.go(RouteNames.forgotPassword),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              AppPrimaryButton(
                label: _isLoading ? 'Signing In…' : 'Sign In',
                onPressed: _isLoading ? null : _submit,
              ),
              SizedBox(height: 24.h),
              const OrDivider(),
              SizedBox(height: 24.h),
              const SocialLoginRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthField(
          hintText: 'Email',
          prefixIcon: Icons.alternate_email,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hasError: _emailError != null,
          onChanged: (_) {
            if (_emailError != null) {
              setState(() => _emailError = _validateEmail(_emailController.text));
            }
          },
        ),
        if (_emailError != null) _buildError(_emailError!),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthField(
          hintText: 'Password',
          prefixIcon: Icons.key_outlined,
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          hasError: _passwordError != null,
          onChanged: (_) {
            if (_passwordError != null) {
              setState(() =>
                  _passwordError = _validatePassword(_passwordController.text));
            }
          },
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
          ),
        ),
        if (_passwordError != null) _buildError(_passwordError!),
      ],
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 16.w),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.error, size: 13.w),
          SizedBox(width: 4.w),
          Text(
            message,
            style: GoogleFonts.inter(
              color: AppColors.error,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWithoutLogin(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.home),
      child: Text(
        'Continue without login',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.signup),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.inter(fontSize: 14.sp),
          children: const [
            TextSpan(
              text: "Don't have any account? ",
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: 'Create Account',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared styled text field used on both auth pages
// ---------------------------------------------------------------------------
class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
    this.hasError = false,
    this.onChanged,
  });

  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final errorColor = AppColors.error;
    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.r),
      borderSide: BorderSide(
        color: hasError ? errorColor : AppColors.inputBorder,
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100.r),
      borderSide: BorderSide(
        color: hasError ? errorColor : AppColors.primary,
        width: 1.5,
      ),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: AppColors.inputHint,
          fontSize: 14.sp,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: hasError ? errorColor : AppColors.inputHint,
          size: 18.sp,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: hasError
            ? AppColors.error.withValues(alpha: 0.05)
            : Colors.transparent,
        border: normalBorder,
        enabledBorder: normalBorder,
        focusedBorder: focusedBorder,
        contentPadding:
            EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      ),
    );
  }
}

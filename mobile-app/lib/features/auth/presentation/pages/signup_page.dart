import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/auth_field.dart';
import '../../../../shared/widgets/or_divider.dart';
import '../../../../shared/widgets/social_login_row.dart';
import '../../data/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Validators ---
  String? _validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Name is required';
    if (trimmed.length < 2) return 'Name must be at least 2 characters';
    return null;
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
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number';
    }
    return null;
  }

  String? _validateConfirm(String value) {
    if (value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _serverError;

  Future<void> _submit() async {
    final nameErr = _validateName(_nameController.text);
    final emailErr = _validateEmail(_emailController.text);
    final passErr = _validatePassword(_passwordController.text);
    final confirmErr = _validateConfirm(_confirmPasswordController.text);
    final termsErr = _agreedToTerms ? null : 'You must agree to the Terms';

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passwordError = passErr;
      _confirmError = confirmErr;
      _termsError = termsErr;
      _serverError = null;
    });

    if (nameErr != null ||
        emailErr != null ||
        passErr != null ||
        confirmErr != null ||
        termsErr != null) return;

    setState(() => _isLoading = true);
    final result = await AuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      context.go(RouteNames.coachSelection);
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
          child: Column(
            children: [
              SizedBox(height: 48.h),
              const AppLogo(),
              SizedBox(height: 32.h),
              _buildTitle(),
              SizedBox(height: 24.h),
              _buildCard(context),
              SizedBox(height: 20.h),
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
        'Create Account',
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
            _buildNameField(),
            SizedBox(height: 14.h),
            _buildEmailField(),
            SizedBox(height: 14.h),
            _buildPasswordField(),
            SizedBox(height: 14.h),
            _buildConfirmField(),
            SizedBox(height: 16.h),
            _buildTermsRow(),
            if (_termsError != null) _buildError(_termsError!),
            SizedBox(height: 24.h),
            if (_serverError != null) ...[
              _buildError(_serverError!),
              SizedBox(height: 12.h),
            ],
            AppPrimaryButton(
              label: _isLoading ? 'Creating Account…' : 'Sign Up',
              onPressed: _isLoading ? null : _submit,
            ),
            SizedBox(height: 24.h),
            const OrDivider(),
            SizedBox(height: 24.h),
            const SocialLoginRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(
          hintText: 'Full Name',
          prefixIcon: Icons.person_outline_rounded,
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          hasError: _nameError != null,
          onChanged: (_) {
            if (_nameError != null) {
              setState(() => _nameError = _validateName(_nameController.text));
            }
          },
        ),
        if (_nameError != null) _buildError(_nameError!),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(
          hintText: 'Email',
          prefixIcon: Icons.alternate_email,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hasError: _emailError != null,
          onChanged: (_) {
            if (_emailError != null) {
              setState(
                  () => _emailError = _validateEmail(_emailController.text));
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
        AuthField(
          hintText: 'Password',
          prefixIcon: Icons.key_outlined,
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          hasError: _passwordError != null,
          onChanged: (_) {
            if (_passwordError != null) {
              setState(() =>
                  _passwordError = _validatePassword(_passwordController.text));
            }
            // Re-validate confirm if it already has an error
            if (_confirmError != null) {
              setState(() => _confirmError =
                  _validateConfirm(_confirmPasswordController.text));
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
        if (_passwordError == null) _buildPasswordStrength(),
      ],
    );
  }

  Widget _buildConfirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthField(
          hintText: 'Confirm Password',
          prefixIcon: Icons.key_outlined,
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          hasError: _confirmError != null,
          onChanged: (_) {
            if (_confirmError != null) {
              setState(() => _confirmError =
                  _validateConfirm(_confirmPasswordController.text));
            }
          },
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            child: Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
            ),
          ),
        ),
        if (_confirmError != null) _buildError(_confirmError!),
        if (_confirmError == null &&
            _confirmPasswordController.text.isNotEmpty &&
            _confirmPasswordController.text == _passwordController.text)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 16.w),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    color: const Color(0xFF22C55E), size: 13.w),
                SizedBox(width: 4.w),
                Text(
                  'Passwords match',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF22C55E),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return const SizedBox.shrink();

    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    final labels = ['Weak', 'Fair', 'Good', 'Strong'];
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
    ];
    final idx = (strength - 1).clamp(0, 3);
    final label = strength == 0 ? '' : labels[idx];
    final color = colors[idx];

    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: i < strength ? color : AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }),
          ),
          if (label.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              'Password strength: $label',
              style: GoogleFonts.inter(
                color: color,
                fontSize: 11.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTermsRow() {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) => setState(() {
              _agreedToTerms = value ?? false;
              if (_agreedToTerms) _termsError = null;
            }),
            activeColor: AppColors.primary,
            side: BorderSide(
              color: _termsError != null ? AppColors.error : AppColors.inputBorder,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: 8.w),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(fontSize: 13.sp),
            children: [
              const TextSpan(
                text: 'I Agree to ',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Terms and Conditions',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                color: AppColors.error,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.login),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.inter(fontSize: 14.sp),
          children: const [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: 'Sign In',
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

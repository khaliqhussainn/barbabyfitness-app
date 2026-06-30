import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/or_divider.dart';
import '../../../../shared/widgets/social_login_row.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Blank space above — matches Figma layout
              SizedBox(height: 160.h),
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
        style: TextStyle(
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
            AppTextField(
              hintText: 'Name',
              prefixIcon: Icons.person_outline,
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 14.h),
            AppTextField(
              hintText: 'Email',
              prefixIcon: Icons.alternate_email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 14.h),
            AppTextField(
              hintText: 'Password',
              prefixIcon: Icons.key_outlined,
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 14.h),
            AppTextField(
              hintText: 'Confirm Password',
              prefixIcon: Icons.key_outlined,
              controller: _confirmPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 16.h),
            _buildTermsRow(),
            SizedBox(height: 24.h),
            AppPrimaryButton(
              label: 'Sign Up',
              onPressed: _agreedToTerms
                  ? () => context.go(RouteNames.coachSelection)
                  : null,
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

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.w,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) =>
                setState(() => _agreedToTerms = value ?? false),
            activeColor: AppColors.primary,
            side: const BorderSide(color: AppColors.inputBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        SizedBox(width: 8.w),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 13.sp),
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
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
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

  Widget _buildFooter(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.login),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 14.sp),
          children: [
            const TextSpan(
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

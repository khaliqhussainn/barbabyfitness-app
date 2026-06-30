import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/or_divider.dart';
import '../../../../shared/widgets/social_login_row.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              SizedBox(height: 240.h),
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
        style: TextStyle(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => context.go(RouteNames.forgotPassword),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            AppPrimaryButton(
              label: 'Sign In',
              onPressed: () {},
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

  Widget _buildContinueWithoutLogin(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.home),
      child: Text(
        'Continue without login',
        textAlign: TextAlign.center,
        style: TextStyle(
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
          style: TextStyle(fontSize: 14.sp),
          children: [
            TextSpan(
              text: "Don't have any account? ",
              style: const TextStyle(color: AppColors.textSecondary),
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

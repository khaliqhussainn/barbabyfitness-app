import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme/app_colors.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    required this.hintText,
    required this.prefixIcon,
    super.key,
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

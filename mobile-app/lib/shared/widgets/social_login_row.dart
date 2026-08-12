import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(
          assetPath: 'assets/images/google.svg',
          semanticLabel: 'Sign in with Google',
          onTap: () {},
        ),
        SizedBox(width: 16.w),
        _SocialButton(
          assetPath: 'assets/images/apple.svg',
          semanticLabel: 'Sign in with Apple',
          onTap: () {},
        ),
        SizedBox(width: 16.w),
        _SocialButton(
          assetPath: 'assets/images/meta.svg',
          semanticLabel: 'Sign in with Meta',
          onTap: () {},
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.assetPath,
    required this.semanticLabel,
    required this.onTap,
  });

  final String assetPath;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        assetPath,
        width: 48.w,
        height: 48.w,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}

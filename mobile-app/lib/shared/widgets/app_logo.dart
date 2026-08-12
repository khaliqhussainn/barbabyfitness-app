import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/Mask group.png',
      width: width ?? 120.w,
      height: height ?? 60.h,
      fit: BoxFit.contain,
    );
  }
}

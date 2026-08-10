import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/routes/route_names.dart';
import '../../config/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  static const _routes = [
    RouteNames.home,
    RouteNames.workoutSelection,
    RouteNames.progress,
    RouteNames.profile,
  ];

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.fitness_center_rounded, 'Workouts'),
    (Icons.bar_chart_rounded, 'Progress'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (index) {
              final (icon, label) = _items[index];
              final isActive = index == currentIndex;
              return GestureDetector(
                onTap: () {
                  if (index < _routes.length && index != currentIndex) {
                    context.go(_routes[index]);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                      size: 29.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

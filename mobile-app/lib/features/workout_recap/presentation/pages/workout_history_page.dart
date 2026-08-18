import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 12.h, right: 25.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 18.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Workout History',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                itemCount: _mockHistory.length,
                itemBuilder: (context, index) {
                  final group = _mockHistory[index];
                  return _WorkoutGroup(group: group);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mock data ─────────────────────────────────────────────

class _WorkoutEntry {
  const _WorkoutEntry({
    required this.name,
    required this.date,
    required this.duration,
    required this.exercises,
    required this.intensity,
  });
  final String name;
  final String date;
  final String duration;
  final int exercises;
  final String intensity;
}

class _WorkoutGroupData {
  const _WorkoutGroupData({required this.label, required this.entries});
  final String label;
  final List<_WorkoutEntry> entries;
}

const _mockHistory = [
  _WorkoutGroupData(label: 'This Week', entries: [
    _WorkoutEntry(
      name: 'Adaptive Strength Training',
      date: 'Today',
      duration: '45 min',
      exercises: 12,
      intensity: 'Push',
    ),
    _WorkoutEntry(
      name: 'Upper Body Blast',
      date: 'Yesterday',
      duration: '32 min',
      exercises: 9,
      intensity: 'Base',
    ),
    _WorkoutEntry(
      name: 'Core & Stability',
      date: 'Mon',
      duration: '28 min',
      exercises: 8,
      intensity: 'Base',
    ),
  ]),
  _WorkoutGroupData(label: 'Last Week', entries: [
    _WorkoutEntry(
      name: 'Full Body Power',
      date: 'Sun',
      duration: '50 min',
      exercises: 14,
      intensity: 'All Out',
    ),
    _WorkoutEntry(
      name: 'Lower Body Strength',
      date: 'Fri',
      duration: '38 min',
      exercises: 10,
      intensity: 'Push',
    ),
    _WorkoutEntry(
      name: 'Cardio Endurance Run',
      date: 'Wed',
      duration: '30 min',
      exercises: 5,
      intensity: 'Base',
    ),
    _WorkoutEntry(
      name: 'Mobility & Stretch',
      date: 'Mon',
      duration: '20 min',
      exercises: 6,
      intensity: 'Base',
    ),
  ]),
  _WorkoutGroupData(label: 'Earlier', entries: [
    _WorkoutEntry(
      name: 'Adaptive Strength Training',
      date: '4 Aug',
      duration: '44 min',
      exercises: 12,
      intensity: 'Push',
    ),
    _WorkoutEntry(
      name: 'Upper Body Blast',
      date: '2 Aug',
      duration: '31 min',
      exercises: 9,
      intensity: 'Base',
    ),
  ]),
];

// ── Widgets ───────────────────────────────────────────────

class _WorkoutGroup extends StatelessWidget {
  const _WorkoutGroup({required this.group});
  final _WorkoutGroupData group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h, top: 4.h),
          child: Text(
            group.label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...group.entries.map((e) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _WorkoutCard(entry: e),
            )),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.entry});
  final _WorkoutEntry entry;

  Color get _intensityColor {
    switch (entry.intensity) {
      case 'All Out':
        return const Color(0xFFEF4444);
      case 'Push':
        return AppColors.primary;
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.fitness_center_rounded,
              color: AppColors.primary,
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        color: AppColors.textSecondary, size: 11.w),
                    SizedBox(width: 3.w),
                    Text(
                      entry.duration,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.textSecondary, size: 11.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${entry.exercises} exercises',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _intensityColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  entry.intensity,
                  style: GoogleFonts.inter(
                    color: _intensityColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                entry.date,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

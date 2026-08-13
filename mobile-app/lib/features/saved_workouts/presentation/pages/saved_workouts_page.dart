import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_colors.dart';

class SavedWorkoutsPage extends StatefulWidget {
  const SavedWorkoutsPage({super.key});

  @override
  State<SavedWorkoutsPage> createState() => _SavedWorkoutsPageState();
}

class _SavedWorkoutsPageState extends State<SavedWorkoutsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = ['All', 'Strength', 'Cardio', 'Flexibility'];

  final List<_WorkoutItem> _saved = [
    _WorkoutItem(
      title: 'Full Body Blast',
      category: 'Strength',
      duration: '45 min',
      level: 'Intermediate',
      exercises: 12,
      tag: 'Strength',
    ),
    _WorkoutItem(
      title: 'Morning Cardio Burn',
      category: 'Cardio',
      duration: '30 min',
      level: 'Beginner',
      exercises: 8,
      tag: 'Cardio',
    ),
    _WorkoutItem(
      title: 'Upper Body Power',
      category: 'Strength',
      duration: '40 min',
      level: 'Advanced',
      exercises: 10,
      tag: 'Strength',
    ),
    _WorkoutItem(
      title: 'Yoga Flow',
      category: 'Flexibility',
      duration: '25 min',
      level: 'Beginner',
      exercises: 14,
      tag: 'Flexibility',
    ),
    _WorkoutItem(
      title: 'HIIT Circuit',
      category: 'Cardio',
      duration: '20 min',
      level: 'Intermediate',
      exercises: 6,
      tag: 'Cardio',
    ),
    _WorkoutItem(
      title: 'Core & Abs',
      category: 'Strength',
      duration: '30 min',
      level: 'Intermediate',
      exercises: 9,
      tag: 'Strength',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_WorkoutItem> get _filtered {
    final tab = _tabs[_tabController.index];
    if (tab == 'All') return _saved;
    return _saved.where((w) => w.tag == tab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildTopBar(context),
            SizedBox(height: 20.h),
            _buildTabBar(),
            SizedBox(height: 16.h),
            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, i) => _WorkoutCard(
                        item: _filtered[i],
                        onRemove: () => setState(() => _saved.remove(_filtered[i])),
                      ),
                    ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(Icons.chevron_left_rounded,
                  color: AppColors.textPrimary, size: 28.w),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Saved Workouts',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            '${_saved.length} saved',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final active = _tabController.index == i;
          return GestureDetector(
            onTap: () => _tabController.animateTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                _tabs[i],
                style: GoogleFonts.inter(
                  color: active ? Colors.white : AppColors.textSecondary,
                  fontSize: 13.sp,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded,
              color: AppColors.textSecondary, size: 56.w),
          SizedBox(height: 16.h),
          Text(
            'No saved workouts yet',
            style: GoogleFonts.outfit(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Bookmark workouts to find them here',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutItem {
  const _WorkoutItem({
    required this.title,
    required this.category,
    required this.duration,
    required this.level,
    required this.exercises,
    required this.tag,
  });
  final String title;
  final String category;
  final String duration;
  final String level;
  final int exercises;
  final String tag;
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.item, required this.onRemove});

  final _WorkoutItem item;
  final VoidCallback onRemove;

  Color get _tagColor {
    switch (item.tag) {
      case 'Cardio':
        return const Color(0xFF3B82F6);
      case 'Flexibility':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: _tagColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              item.tag == 'Cardio'
                  ? Icons.directions_run_rounded
                  : item.tag == 'Flexibility'
                      ? Icons.self_improvement_rounded
                      : Icons.fitness_center_rounded,
              color: _tagColor,
              size: 26.w,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    _Chip(label: item.duration, icon: Icons.timer_outlined),
                    _Chip(
                        label: '${item.exercises} ex',
                        icon: Icons.list_alt_rounded),
                    _Chip(label: item.level, icon: Icons.bar_chart_rounded),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Icon(Icons.bookmark_rounded,
                  color: AppColors.primary, size: 22.w),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 11.w),
        SizedBox(width: 3.w),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

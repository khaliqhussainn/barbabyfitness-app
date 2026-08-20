import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../workouts/data/workout_api_service.dart';
import '../../../workouts/domain/models/workout_api_model.dart';

class SavedWorkoutsPage extends StatefulWidget {
  const SavedWorkoutsPage({super.key});

  @override
  State<SavedWorkoutsPage> createState() => _SavedWorkoutsPageState();
}

class _SavedWorkoutsPageState extends State<SavedWorkoutsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = ['All', 'Strength', 'Cardio', 'Flexibility'];

  List<WorkoutApiModel> _saved = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadSaved();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSaved() async {
    setState(() => _isLoading = true);
    final workouts = await WorkoutApiService.getSavedWorkouts();
    if (!mounted) return;
    setState(() {
      _saved = workouts;
      _isLoading = false;
    });
  }

  Future<void> _unsave(WorkoutApiModel workout) async {
    final success = await WorkoutApiService.unsaveWorkout(workout.id);
    if (!mounted) return;
    if (success) {
      setState(() => _saved.removeWhere((w) => w.id == workout.id));
    }
  }

  List<WorkoutApiModel> get _filtered {
    final tab = _tabs[_tabController.index];
    if (tab == 'All') return _saved;
    return _saved
        .where((w) => (w.category ?? '').toLowerCase() == tab.toLowerCase())
        .toList();
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
            Expanded(child: _buildBody()),
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

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final items = _filtered;

    if (items.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadSaved,
        child: ListView(
          children: [
            SizedBox(height: 80.h),
            Center(
              child: Column(
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
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadSaved,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, i) => _WorkoutCard(
          workout: items[i],
          onRemove: () => _unsave(items[i]),
          onTap: () => context.push(
            RouteNames.workoutDetailV2,
            extra: items[i],
          ),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.workout,
    required this.onRemove,
    required this.onTap,
  });

  final WorkoutApiModel workout;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  Color get _tagColor {
    switch ((workout.category ?? '').toLowerCase()) {
      case 'cardio':
        return const Color(0xFF3B82F6);
      case 'flexibility':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primary;
    }
  }

  IconData get _tagIcon {
    switch ((workout.category ?? '').toLowerCase()) {
      case 'cardio':
        return Icons.directions_run_rounded;
      case 'flexibility':
        return Icons.self_improvement_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              child: Icon(_tagIcon, color: _tagColor, size: 26.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
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
                      _Chip(
                        label: '${workout.durationMinutes} min',
                        icon: Icons.timer_outlined,
                      ),
                      _Chip(
                        label: '${workout.exercises.length} ex',
                        icon: Icons.list_alt_rounded,
                      ),
                      _Chip(
                        label: _capitalize(workout.difficulty),
                        icon: Icons.bar_chart_rounded,
                      ),
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
      mainAxisSize: MainAxisSize.min,
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

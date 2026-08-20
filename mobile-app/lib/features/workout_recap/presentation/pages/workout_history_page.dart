import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../workouts/data/workout_api_service.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final sessions = await WorkoutApiService.getSessionHistory();
    if (!mounted) return;
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  List<_WorkoutGroupData> get _grouped {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));

    final thisWeek = <Map<String, dynamic>>[];
    final lastWeek = <Map<String, dynamic>>[];
    final earlier = <Map<String, dynamic>>[];

    for (final s in _sessions) {
      final completedAt = DateTime.parse(s['completed_at'] as String).toLocal();
      final day = DateTime(completedAt.year, completedAt.month, completedAt.day);
      if (!day.isBefore(weekStart)) {
        thisWeek.add(s);
      } else if (!day.isBefore(lastWeekStart)) {
        lastWeek.add(s);
      } else {
        earlier.add(s);
      }
    }

    return [
      if (thisWeek.isNotEmpty) _WorkoutGroupData(label: 'This Week', sessions: thisWeek),
      if (lastWeek.isNotEmpty) _WorkoutGroupData(label: 'Last Week', sessions: lastWeek),
      if (earlier.isNotEmpty) _WorkoutGroupData(label: 'Earlier', sessions: earlier),
    ];
  }

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
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_sessions.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadHistory,
        child: ListView(
          children: [
            SizedBox(height: 80.h),
            Center(
              child: Column(
                children: [
                  Icon(Icons.history_rounded,
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      size: 56.w),
                  SizedBox(height: 16.h),
                  Text(
                    'No workouts completed yet',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Complete a workout and it will appear here',
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

    final groups = _grouped;
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        itemCount: groups.length,
        itemBuilder: (context, index) => _WorkoutGroup(group: groups[index]),
      ),
    );
  }
}

class _WorkoutGroupData {
  const _WorkoutGroupData({required this.label, required this.sessions});
  final String label;
  final List<Map<String, dynamic>> sessions;
}

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
        ...group.sessions.map((s) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _WorkoutCard(session: s),
            )),
        SizedBox(height: 8.h),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.session});
  final Map<String, dynamic> session;

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (m == 0) return '${s}s';
    if (s == 0) return '${m} min';
    return '${m}m ${s}s';
  }

  String _formatDate(String raw) {
    final dt = DateTime.parse(raw).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final title = session['workout_title'] as String? ?? 'Workout';
    final duration = session['duration_seconds'] as int? ?? 0;
    final calories = session['calories_burned'] as int? ?? 0;
    final completedAt = session['completed_at'] as String? ?? '';

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
                  title,
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
                      _formatDuration(duration),
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.local_fire_department_rounded,
                        color: AppColors.primary, size: 11.w),
                    SizedBox(width: 3.w),
                    Text(
                      '$calories kcal',
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
          Text(
            completedAt.isNotEmpty ? _formatDate(completedAt) : '',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

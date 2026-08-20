import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../data/workout_api_service.dart';
import '../../domain/models/workout_api_model.dart';

class WorkoutSelectionV2Page extends StatefulWidget {
  const WorkoutSelectionV2Page({super.key});

  @override
  State<WorkoutSelectionV2Page> createState() => _WorkoutSelectionV2PageState();
}

class _WorkoutSelectionV2PageState extends State<WorkoutSelectionV2Page> {
  List<WorkoutApiModel> _workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await WorkoutApiService.listWorkouts();
    if (!mounted) return;
    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _onSaveToggled(int index, bool isSaved) {
    setState(() {
      _workouts[index] = _workouts[index].copyWith(isSaved: isSaved);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: _buildHeader(),
            ),
            SizedBox(height: 24.h),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Workout Selection',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Choose a workout designed for today\'s training goals.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_workouts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.4), size: 52.w),
            SizedBox(height: 16.h),
            Text(
              'No workouts available',
              style: GoogleFonts.outfit(
                  color: AppColors.textSecondary, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                setState(() => _isLoading = true);
                _loadWorkouts();
              },
              child: Text(
                'Tap to retry',
                style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadWorkouts,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 25.w).copyWith(bottom: 24.h),
        itemCount: _workouts.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) => _WorkoutCard(
          workout: _workouts[index],
          onViewDetails: () => context.push(
            RouteNames.workoutDetailV2,
            extra: _workouts[index],
          ),
          onSaveToggled: (isSaved) => _onSaveToggled(index, isSaved),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatefulWidget {
  const _WorkoutCard({
    required this.workout,
    required this.onViewDetails,
    required this.onSaveToggled,
  });

  final WorkoutApiModel workout;
  final VoidCallback onViewDetails;
  final ValueChanged<bool> onSaveToggled;

  @override
  State<_WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<_WorkoutCard> {
  late bool _isSaved;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.workout.isSaved;
  }

  Future<void> _toggleSave() async {
    if (_saving) return;
    setState(() => _saving = true);
    final success = _isSaved
        ? await WorkoutApiService.unsaveWorkout(widget.workout.id)
        : await WorkoutApiService.saveWorkout(widget.workout.id);
    if (!mounted) return;
    setState(() {
      _saving = false;
      if (success) _isSaved = !_isSaved;
    });
    if (success) widget.onSaveToggled(_isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 190.h,
                child: widget.workout.imageUrl != null
                    ? Image.network(
                        widget.workout.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: _toggleSave,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: _saving
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: _isSaved ? AppColors.primary : Colors.white,
                            size: 18.w,
                          ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.workout.title,
                  style: GoogleFonts.outfit(
                    color: AppColors.textPrimary,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.workout.description,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 14.h),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      _StatColumn(
                        label: 'Duration',
                        value: '${widget.workout.durationMinutes}',
                        unit: 'Minutes',
                      ),
                      _VertDivider(),
                      _DifficultyColumn(label: _capitalize(widget.workout.difficulty)),
                      _VertDivider(),
                      _CategoryColumn(label: widget.workout.category ?? 'General'),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: widget.onViewDetails,
                    child: Container(
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'View Details',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.fitness_center_rounded,
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          size: 48.w,
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Text(value,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  height: 1)),
          Text(unit,
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

class _DifficultyColumn extends StatelessWidget {
  const _DifficultyColumn({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Difficulty',
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _CategoryColumn extends StatelessWidget {
  const _CategoryColumn({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category',
              style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 4.h),
          Text(label,
              style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.background,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/app_bottom_nav.dart';
import '../../../workouts/domain/models/workout_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> _morningChecked = [true, false, false];
  double _hydrationCurrent = 1.2;
  static const double _hydrationTarget = 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                _buildGreetingRow(),
                SizedBox(height: 20.h),
                _buildFeaturedCard(),
                SizedBox(height: 16.h),
                _buildCoachCard(),
                SizedBox(height: 16.h),
                _buildStatsRow(),
                SizedBox(height: 24.h),
                _buildSuggestedHeader(),
                SizedBox(height: 12.h),
                _buildSuggestedScroll(),
                SizedBox(height: 24.h),
                _buildTodaysPlanHeader(),
                SizedBox(height: 12.h),
                _buildMorningRoutine(),
                SizedBox(height: 12.h),
                _buildScheduledWorkout(),
                SizedBox(height: 12.h),
                _buildHydrationGoal(),
                SizedBox(height: 12.h),
                _buildDailySteps(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Username',
                style: GoogleFonts.outfit(
                  color: AppColors.textPrimary,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Stay Strong. Your future self is watching.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Row(
          children: [
            GestureDetector(
              onTap: () => context.push(RouteNames.savedWorkouts),
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: AppColors.textSecondary,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () => context.push(RouteNames.notifications),
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textSecondary,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () => context.push(RouteNames.paywall),
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFFF8C00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 21.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        height: 249.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            // Athlete image on right side, overflowing top
            Positioned(
              right: 0,
              top: -10,
              bottom: 0,
              width: 190.w,
              child: Image.asset(
                'assets/images/homeimg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topRight,
              ),
            ),
            // Dark gradient over image from left
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF1A1A1A),
                      const Color(0xFF1A1A1A).withValues(alpha: 0.92),
                      const Color(0xFF1A1A1A).withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 0.65, 1.0],
                  ),
                ),
              ),
            ),
            // Content on left
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Workout',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'HIIT Endurance',
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    width: 170.w,
                    child: Text(
                      'High intensity interval training\nto boost stamina and burn fat.',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildTimeBadge('30 MIN'),
                  const Spacer(),
                  _buildStartButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, color: AppColors.textPrimary, size: 11.w),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: () => context.go(
        RouteNames.workoutDetail,
        extra: const WorkoutModel(
          name: 'HIIT Endurance',
          description: 'High intensity interval training to boost stamina and burn fat. Improve cardiovascular endurance, build explosive strength and maximum calorie burn.',
          imagePath: 'assets/images/homeimg.png',
          duration: '30',
          difficulty: 'Intermediate',
          calories: '320',
          exercises: [
            ('High Knees', '3 × 20'),
            ('Burpees', '3 × 10'),
            ('Jump Squats', '3 × 15'),
            ('Mountain Climbers', '3 × 20'),
            ('Plank Hold', '60 Seconds'),
            ('Jump Lunges', '3 × 12'),
          ],
        ),
      ),
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          'Start Workout',
          style: GoogleFonts.inter(
            color: AppColors.onPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCoachCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Coach avatar placeholder
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Coach',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Focus on maintaining proper form before increasing speed. Consistency always beats intensity.',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('Days Streak', '3', null),
        SizedBox(width: 8.w),
        _buildStatCard('Calories', '1250', null),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String? unit) {
    return Expanded(
      child: Container(
        height: 122.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 33.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Suggested for you',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(RouteNames.workoutSelectionV2),
          child: Text(
            'See All',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedScroll() {
    const workouts = [
      ('Full Body Blast', 'Intermediate', '30 MIN'),
      ('Core Crusher', 'Advanced', '30 MIN'),
      ('Cardio Burn', 'Beginner', '30 MIN'),
      ('Calisthenics', 'Advanced', '30 MIN'),
    ];

    return SizedBox(
      height: 166.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: workouts.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final (name, level, duration) = workouts[index];
          return _buildWorkoutCard(name, level, duration);
        },
      ),
    );
  }

  Widget _buildWorkoutCard(String name, String level, String duration) {
    return Container(
      width: 109.w,
      height: 166.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/homeimg.png'),
          fit: BoxFit.cover,
          opacity: 0.35,
        ),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              Icons.bookmark_border_rounded,
              color: AppColors.textPrimary,
              size: 18.w,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 10.w),
              SizedBox(width: 3.w),
              Text(
                duration,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            name,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                level,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 4.w),
              ...List.generate(
                3,
                (_) => Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysPlanHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Plan",
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () => context.push(RouteNames.workoutSelectionV2),
          child: Text(
            'See All',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ── Morning Routine ──────────────────────────────────────
  Widget _buildMorningRoutine() {
    final items = [
      ('5 Min Warmup', '30 MIN'),
      ('Light Jog', '20 MIN'),
      ('Drink 500ml Water', null),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Morning Routine',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate(items.length, (i) {
            final (label, duration) = items[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i < items.length - 1 ? 10.h : 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _morningChecked[i] = !_morningChecked[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: _morningChecked[i] ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: _morningChecked[i] ? AppColors.primary : AppColors.inputBorder,
                          width: 1.5,
                        ),
                      ),
                      child: _morningChecked[i]
                          ? Icon(Icons.check_rounded, color: AppColors.onPrimary, size: 13.w)
                          : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        color: _morningChecked[i]
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        decoration: _morningChecked[i]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (duration != null)
                    Text(
                      duration,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Scheduled Workout ────────────────────────────────────
  Widget _buildScheduledWorkout() {
    return Container(
      width: double.infinity,
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
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.fitness_center_rounded, color: AppColors.primary, size: 22.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scheduled Workout',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'HIIT Endurance',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '30 MIN  ·  05:30 PM',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go(
              RouteNames.workoutDetail,
              extra: const WorkoutModel(
                name: 'HIIT Endurance',
                description: 'High intensity interval training to boost stamina and burn fat. Improve cardiovascular endurance, build explosive strength and maximum calorie burn.',
                imagePath: 'assets/images/homeimg.png',
                duration: '30',
                difficulty: 'Intermediate',
                calories: '320',
                exercises: [
                  ('High Knees', '3 × 20'),
                  ('Burpees', '3 × 10'),
                  ('Jump Squats', '3 × 15'),
                  ('Mountain Climbers', '3 × 20'),
                  ('Plank Hold', '60 Seconds'),
                  ('Jump Lunges', '3 × 12'),
                ],
              ),
            ),
            child: Container(
              height: 34.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Start',
                style: GoogleFonts.inter(
                  color: AppColors.onPrimary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hydration Goal ───────────────────────────────────────
  Widget _buildHydrationGoal() {
    final double progress = (_hydrationCurrent / _hydrationTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hydration Goal',
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Target ${_hydrationTarget}L',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _hydrationCurrent = (_hydrationCurrent + 0.25).clamp(0.0, _hydrationTarget);
                }),
                child: Container(
                  height: 30.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: AppColors.primary, size: 14.w),
                      SizedBox(width: 4.w),
                      Text(
                        'Add 250ml',
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.w),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.w),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.background,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _hydrationCurrent,
              min: 0,
              max: _hydrationTarget,
              divisions: 10,
              onChanged: (value) => setState(() => _hydrationCurrent = value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0L',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${_hydrationCurrent.toStringAsFixed(2)}L / ${_hydrationTarget}L',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_hydrationTarget}L',
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

  // ── Daily Steps ──────────────────────────────────────────
  Widget _buildDailySteps() {
    const int current = 4500;
    const int goal = 8000;
    final double progress = current / goal;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Steps Goal: ${goal.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: current.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' steps done',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          SizedBox(
            width: 72.w,
            height: 72.w,
            child: CustomPaint(
              painter: _CircularProgressPainter(progress: progress),
              child: Center(
                child: Icon(
                  Icons.directions_walk_rounded,
                  color: AppColors.primary,
                  size: 28.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 6.0;
    const startAngle = -1.5707963267948966; // -π/2 (top)

    final bgPaint = Paint()
      ..color = AppColors.background
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * 3.141592653589793 * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) => old.progress != progress;
}

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/saved_workouts/presentation/pages/saved_workouts_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/todo/presentation/pages/todo_list_page.dart';
import '../../features/workouts/presentation/pages/workout_selection_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/workout_recap/presentation/pages/daily_recap_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/user_goals_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/coach_voice_page.dart';
import '../../features/workout_session/presentation/pages/real_time_coaching_page.dart';
import '../../features/workout_session/presentation/pages/active_workout_page.dart';
import '../../features/workouts/presentation/pages/workout_selection_v2_page.dart';
import '../../features/workouts/presentation/pages/workout_detail_page.dart';
import '../../features/workouts/presentation/pages/workout_detail_v2_page.dart';
import '../../features/workouts/domain/models/workout_model.dart';
import '../../features/paywall/presentation/pages/paywall_page.dart';
import '../../features/workout_recap/presentation/pages/workout_complete_page.dart';
import '../../dev/dev_launcher_page.dart';
import '../../features/onboarding_flow/presentation/pages/coach_selection_page.dart';
import '../../features/onboarding_flow/presentation/pages/fitness_level_page.dart';
import '../../features/onboarding_flow/presentation/pages/main_goal_page.dart';
import '../../features/onboarding_flow/presentation/pages/calibration_workout_page.dart';
import '../../features/onboarding_flow/presentation/pages/calibration_active_page.dart';
import '../../features/onboarding_flow/presentation/pages/device_permissions_page.dart';
import '../../features/onboarding_flow/presentation/pages/personal_details_page.dart';
import '../../features/onboarding_flow/presentation/pages/voice_selection_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/pages/unknown_page.dart';
import 'route_names.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: RouteNames.splash,
    errorBuilder: (context, state) => const UnknownPage(),
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: RouteNames.signupName,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.homeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.coachSelection,
        name: RouteNames.coachSelectionName,
        builder: (context, state) => const CoachSelectionPage(),
      ),
      GoRoute(
        path: RouteNames.voiceSelection,
        name: RouteNames.voiceSelectionName,
        builder: (context, state) => const VoiceSelectionPage(),
      ),
      GoRoute(
        path: RouteNames.fitnessLevel,
        name: RouteNames.fitnessLevelName,
        builder: (context, state) => const FitnessLevelPage(),
      ),
      GoRoute(
        path: RouteNames.mainGoal,
        name: RouteNames.mainGoalName,
        builder: (context, state) => const MainGoalPage(),
      ),
      GoRoute(
        path: RouteNames.personalDetails,
        name: RouteNames.personalDetailsName,
        builder: (context, state) => const PersonalDetailsPage(),
      ),
      GoRoute(
        path: RouteNames.devicePermissions,
        name: RouteNames.devicePermissionsName,
        builder: (context, state) => const DevicePermissionsPage(),
      ),
      GoRoute(
        path: RouteNames.calibrationWorkout,
        name: RouteNames.calibrationWorkoutName,
        builder: (context, state) => const CalibrationWorkoutPage(),
      ),
      GoRoute(
        path: RouteNames.calibrationActive,
        name: RouteNames.calibrationActiveName,
        builder: (context, state) => const CalibrationActivePage(),
      ),
      GoRoute(
        path: RouteNames.workoutSelection,
        name: RouteNames.workoutSelectionName,
        builder: (context, state) => const WorkoutSelectionPage(),
      ),
      GoRoute(
        path: RouteNames.progress,
        name: RouteNames.progressName,
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: RouteNames.dailyRecap,
        name: RouteNames.dailyRecapName,
        builder: (context, state) => const DailyRecapPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profileName,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.paywall,
        name: RouteNames.paywallName,
        builder: (context, state) => const PaywallPage(),
      ),
      GoRoute(
        path: RouteNames.workoutComplete,
        name: RouteNames.workoutCompleteName,
        builder: (context, state) => const WorkoutCompletePage(),
      ),
      GoRoute(
        path: RouteNames.userGoals,
        name: RouteNames.userGoalsName,
        builder: (context, state) => const UserGoalsPage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfileName,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.coachVoice,
        name: RouteNames.coachVoiceName,
        builder: (context, state) => const CoachVoicePage(),
      ),
      GoRoute(
        path: RouteNames.realTimeCoaching,
        name: RouteNames.realTimeCoachingName,
        builder: (context, state) => const RealTimeCoachingPage(),
      ),
      GoRoute(
        path: RouteNames.activeWorkout,
        name: RouteNames.activeWorkoutName,
        builder: (context, state) => const ActiveWorkoutPage(),
      ),
      GoRoute(
        path: RouteNames.workoutSelectionV2,
        name: RouteNames.workoutSelectionV2Name,
        builder: (context, state) => const WorkoutSelectionV2Page(),
      ),
      GoRoute(
        path: RouteNames.workoutDetail,
        name: RouteNames.workoutDetailName,
        builder: (context, state) => WorkoutDetailPage(
          workout: state.extra as WorkoutModel,
        ),
      ),
      GoRoute(
        path: RouteNames.workoutDetailV2,
        name: RouteNames.workoutDetailV2Name,
        builder: (context, state) => WorkoutDetailV2Page(
          workout: state.extra as WorkoutModel,
        ),
      ),
      GoRoute(
        path: RouteNames.savedWorkouts,
        name: RouteNames.savedWorkoutsName,
        builder: (context, state) => const SavedWorkoutsPage(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        name: RouteNames.notificationsName,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: RouteNames.todoList,
        name: RouteNames.todoListName,
        builder: (context, state) => const TodoListPage(),
      ),
      if (kDebugMode)
        GoRoute(
          path: RouteNames.devLauncher,
          name: RouteNames.devLauncherName,
          builder: (context, state) => const DevLauncherPage(),
        ),
    ],
  );
});

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/athlete_app/exercise_player_screen.dart';
import '../screens/athlete_app/feedback_screen.dart';
import '../screens/athlete_app/today_workout_screen.dart';
import '../screens/athletes/athlete_profile_screen.dart';
import '../screens/athletes/athletes_screen.dart';
import '../screens/athletes/new_athlete_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/exercises/new_exercise_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/programs/assign_program_screen.dart';
import '../screens/programs/new_program_screen.dart';
import '../screens/programs/program_builder_screen.dart';
import '../screens/programs/programs_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/app_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/register',
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),

    // Main sections — sidebar (desktop) / bottom nav (mobile), shared branch state.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/library', builder: (context, state) => const LibraryScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/programs', builder: (context, state) => const ProgramsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/athletes', builder: (context, state) => const AthletesScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ]),
      ],
    ),

    // Flows / modals — pushed above the shell.
    GoRoute(
      path: '/exercises/new',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NewExerciseScreen(),
    ),
    GoRoute(
      path: '/athletes/new',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NewAthleteScreen(),
    ),
    GoRoute(
      path: '/athletes/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AthleteProfileScreen(athleteId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/programs/new',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NewProgramScreen(),
    ),
    GoRoute(
      path: '/programs/assign',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AssignProgramScreen(
        initialAthleteId: state.uri.queryParameters['athleteId'],
        initialProgramId: state.uri.queryParameters['programId'],
      ),
    ),
    GoRoute(
      path: '/programs/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ProgramBuilderScreen(programId: state.pathParameters['id']!),
    ),

    // Athlete-facing app (mobile-first, separate persona).
    GoRoute(
      path: '/workout',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const TodayWorkoutScreen(),
    ),
    GoRoute(
      path: '/workout/:exerciseId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          ExercisePlayerScreen(exerciseId: state.pathParameters['exerciseId']!),
    ),
    GoRoute(
      path: '/workout/:exerciseId/feedback',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          FeedbackScreen(exerciseId: state.pathParameters['exerciseId']!),
    ),
  ],
);

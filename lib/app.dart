import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/life_theme.dart';
import 'screens/debrief_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/scenario_screens.dart';
import 'screens/settings_screen.dart';
import 'state/app_state.dart';

class LifeIqApp extends StatefulWidget {
  const LifeIqApp({super.key});

  @override
  State<LifeIqApp> createState() => _LifeIqAppState();
}

class _LifeIqAppState extends State<LifeIqApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: '/profile-setup',
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
        path: '/intro/:id',
        builder: (_, state) =>
            ScenarioIntroScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/story', builder: (_, _) => const SimulationScreen()),
      GoRoute(
        path: '/debrief/:id/:score',
        builder: (_, state) => DebriefScreen(
          id: state.pathParameters['id']!,
          score: int.tryParse(state.pathParameters['score']!) ?? 0,
        ),
      ),
      GoRoute(path: '/paywall', builder: (_, _) => const PaywallScreen()),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp.router(
      title: 'LifeIQ',
      debugShowCheckedModeBanner: false,
      theme: buildLifeTheme(),
      locale: state.isUrdu ? const Locale('ur') : const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ur')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}

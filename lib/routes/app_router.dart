import 'package:go_router/go_router.dart';
import 'package:next_door/presentation/auth/auth_screen.dart';
import 'package:next_door/presentation/auth/forgot_password.dart';
import 'package:next_door/presentation/auth/login_screen.dart';
import 'package:next_door/presentation/onboardingscreen/onboarding_screen.dart';
import 'package:next_door/routes/pages.dart';

class AppRouter {
  final bool showOnboarding;

  AppRouter({required this.showOnboarding});

  GoRouter get router => GoRouter(
        initialLocation: showOnboarding ? Pages.onboarding : Pages.auth,
        routes: [
          GoRoute(
            path: Pages.onboarding,
            name: 'onboarding',
            builder: (context, state) => OnboardingScreen(),
          ),
          GoRoute(
            path: Pages.auth,
            name: Pages.auth,
            builder: (context, state) => AuthScreen(),
          ),
          GoRoute(
            path: Pages.login,
            name: Pages.login,
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: Pages.forgotPassword,
            name: Pages.forgotPassword,
            builder: (context, state) => ForgotPassword(),
          ),
        ],
      );
}

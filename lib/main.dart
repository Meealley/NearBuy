import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_door/cubits/cubit/onboarding_cubit.dart';
import 'package:next_door/firebase_options.dart';
import 'package:next_door/routes/app_router.dart';
import 'package:next_door/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  runApp(NextBuyApp(
    showOnboarding: showOnboarding,
  ));
}

class NextBuyApp extends StatelessWidget {
  final bool showOnboarding;
  const NextBuyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(showOnboarding: showOnboarding);
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(),
        ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          return MaterialApp.router(
            theme: ThemeData(
              fontFamily: 'DM Sans',
              primaryColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.background,
                primary: AppColors.background,
                secondary:
                    Color(0xFFE69520), // Optional: Adjust secondary color
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}

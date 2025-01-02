import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/onboarding.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'HelveticaNeueRounded',
          scaffoldBackgroundColor: AppColors.blackColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              color: AppColors.primaryColor,
            ),
            displayMedium: TextStyle(
              fontSize: 24,
              color: AppColors.primaryColor,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: AppColors.secondaryColor,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: AppColors.primaryTextColor,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              color: AppColors.primaryTextColor,
            ),
          ),
        ),
        home: const OnboardingScreen(),
        routes: {
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          Signin.routeName: (context) => const Signin(),
        },
      ),
    );
  }
}

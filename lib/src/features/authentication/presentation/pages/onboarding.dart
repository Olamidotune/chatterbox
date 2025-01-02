import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/signin.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/signup.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppStrings.welcomeTo} Chatterbox',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                    ),
              ),
              Image.asset('assets/png/logo.png'),
              Text(
                AppStrings.connectWithPeople,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                    ),
              ),
              AppSpacing.verticalSpaceMedium,
              Button(
                text: AppStrings.signUp,
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUp.routeName);
                },
              ),
              AppSpacing.verticalSpaceMedium,
              Button(
                text: AppStrings.signIn,
                onPressed: () {
                  Navigator.of(context).pushNamed(Signin.routeName);
                },
                buttonColor: AppColors.greenColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

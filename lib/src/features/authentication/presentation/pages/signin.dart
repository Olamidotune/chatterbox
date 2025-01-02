import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:chatterbox/src/shared/custom_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  static const routeName = '/signin';

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  bool isPasswordVisible = false;
  final bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.horizontalSpacing),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.signIn,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTextColor,
                      ),
                ),
                Image.asset('assets/png/logo.png'),
                Form(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        title: AppStrings.email,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        focusNode: emailFocusNode,
                        hintText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: 'email',
                        validator: (value) {
                          if (EmailValidator.validate(value!)) {
                            return AppStrings.emailIsRequired;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.verticalSpaceMedium,
                      CustomTextFormField(
                        title: AppStrings.password,
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        hintText: AppStrings.password,
                        prefixIcon: 'password',
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        onFieldSubmitted: () {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                        },
                        onSuffixIconPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        obscureText: isPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.passwordIsRequired;
                          }
                          if (value.length < 6) {
                            return AppStrings
                                .enterConfirmPasswordAtLeast6Characters;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.verticalSpaceMedium,
                      Button(
                        text: AppStrings.signIn,
                        onPressed: () {},
                      ),
                      AppSpacing.verticalSpaceMedium,
                      // Text(AppStrings.alreadyHaveAnAccount)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAnAccount,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: AppColors.primaryTextColor,
                                ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.signUp,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: AppColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

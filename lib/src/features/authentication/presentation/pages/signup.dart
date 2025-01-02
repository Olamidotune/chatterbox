import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:chatterbox/src/shared/custom_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static const routeName = '/SignUp';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
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
                  AppStrings.signUp,
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
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        focusNode: nameFocusNode,
                        hintText: AppStrings.email,
                        keyboardType: TextInputType.name,
                        prefixIcon: 'profile',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.nameIsRequired;
                          }
                          return null;
                        },
                      ),
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
                        textInputAction: TextInputAction.next,
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
                      CustomTextFormField(
                        title: AppStrings.confirmPassword,
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        hintText: AppStrings.confirmPassword,
                        textInputAction: TextInputAction.go,
                        prefixIcon: 'password',
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        onFieldSubmitted: () {
                          emailFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                        },
                        onSuffixIconPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                        obscureText: isConfirmPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.passwordIsRequired;
                          }
                          if (value.length < 6) {
                            return AppStrings
                                .enterConfirmPasswordAtLeast6Characters;
                          }
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            return AppStrings.passwordNotMatch;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.verticalSpaceMedium,
                      Button(
                        text: AppStrings.signUp,
                        onPressed: () {},
                        buttonColor: AppColors.greenColor,
                      ),
                      AppSpacing.verticalSpaceMedium,
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
                              AppStrings.signIn,
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

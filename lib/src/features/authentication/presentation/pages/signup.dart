import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/signin.dart';
import 'package:chatterbox/src/services/database.dart';
import 'package:chatterbox/src/services/shared_prefs.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:chatterbox/src/shared/custom_snackbar.dart';
import 'package:chatterbox/src/shared/custom_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

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
  bool _busy = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        title: AppStrings.name,
                        controller: nameController,
                        textInputAction: TextInputAction.next,
                        focusNode: nameFocusNode,
                        hintText: AppStrings.name,
                        keyboardType: TextInputType.name,
                        prefixIcon: 'profile',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.nameIsRequired;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.verticalSpaceMedium,
                      CustomTextFormField(
                        title: AppStrings.email,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        focusNode: emailFocusNode,
                        hintText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: 'email',
                        validator: (value) {
                          if (EmailValidator.validate(value?.trim() ?? '')) {
                            return null;
                          }
                          return AppStrings.invalidEmailAddress;
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
                        busy: _busy,
                        text: AppStrings.signUp,
                        onPressed: register,
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
                            onPressed: () {
                              Navigator.pushNamed(context, Signin.routeName);
                            },
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

  void register() async {
    if (!_busy && _formKey.currentState!.validate()) {
      setState(() {
        _busy = true;
      });
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        CustomSnackbar.show(
          context,
          'Account created successfully',
        );
        setState(() {
          _busy = false;
        });

        final userId = randomAlphaNumeric(10);

        final userInfoMap = {
          'name': nameController.text,
          'email': emailController.text,
          'username': emailController.text.trim().split('@')[0],
          'photoUrl':
              'https://static.vecteezy.com/system/resources/previews/034/951/734/large_2x/dark-blue-silhouette-generic-profile-of-one-person-3d-icon-represent-a-user-or-member-free-png.png',
          'userId': userId,
        };

        await DatabaseMethod().addUserDetails(userId, userInfoMap);
        await SharedPrefs()
            .saveDisplayUserNameSharedPreference(nameController.text);
        await SharedPrefs().saveUserEmailSharedPreference(emailController.text);
        await SharedPrefs().saveUserIDSharedPreference(userId);
        await SharedPrefs().saveUserProfilePicSharedPreference(
            'https://static.vecteezy.com/system/resources/previews/034/951/734/large_2x/dark-blue-silhouette-generic-profile-of-one-person-3d-icon-represent-a-user-or-member-free-png.png');
        await SharedPrefs().saveUserNameSharedPreference(
          emailController.text.trim().split('@')[0],
        );

        debugPrint('User: ${userCredential.user!.email}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          CustomSnackbar.show(
            context,
            'The password provided is too weak.',
            isError: true,
          );
        } else if (e.code == 'email-already-in-use') {
          CustomSnackbar.show(
            context,
            'The account already exists for that email.',
            isError: true,
          );
        }
      } catch (e) {
        setState(() {
          _busy = false;
        });
      }
    }
  }
}

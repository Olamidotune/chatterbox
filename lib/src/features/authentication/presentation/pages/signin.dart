import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/features/authentication/presentation/pages/signup.dart';
import 'package:chatterbox/src/features/authentication/services/database.dart';
import 'package:chatterbox/src/features/chat/presentation/pages/chat_screen.dart';
import 'package:chatterbox/src/services/shared_prefs.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:chatterbox/src/shared/custom_snackbar.dart';
import 'package:chatterbox/src/shared/custom_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String email = '';
  String password = '';
  String name = '';
  String username = '';
  String photoUrl = '';
  String userId = '';

  bool isPasswordVisible = true;
  bool _busy = false;
  final _formKey = GlobalKey<FormState>();

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
                  key: _formKey,
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
                            return null;
                          }
                          return AppStrings.emailIsRequired;
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
                          signIn();
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
                        busy: _busy,
                        text: AppStrings.signIn,
                        onPressed: signIn,
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
                              Navigator.pushNamed(context, SignUp.routeName);
                            },
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

  Future<void> signIn() async {
    if (!_busy && _formKey.currentState!.validate()) {
      setState(() {
        _busy = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        final querySnapshot = await DatabaseMethod().getUserByUserEmail(
          emailController.text,
        );

        name = '${querySnapshot.docs[0]['name']}';
        username = '${querySnapshot.docs[0]['username']}';
        photoUrl = '${querySnapshot.docs[0]['photoUrl']}';
        userId = querySnapshot.docs[0].id;

        await SharedPrefs().saveUserEmailSharedPreference(emailController.text);
        await SharedPrefs().saveUserNameSharedPreference(name);
        await SharedPrefs().saveDisplayUserNameSharedPreference(username);
        await SharedPrefs().saveUserIDSharedPreference(userId);
        await SharedPrefs().saveUserProfilePicSharedPreference(photoUrl);

        CustomSnackbar.show(context, 'Welcome $name');
        await Navigator.pushReplacementNamed(context, ChatScreen.routeName);
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        if (e.code == 'user-not-found') {
          CustomSnackbar.show(
            context,
            'No user found for that email',
            isError: true,
          );
        } else if (e.code == 'invalid-credential') {
          CustomSnackbar.show(context, 'Invalid credentials', isError: true);
        } else {
          CustomSnackbar.show(
            context,
            'An error occurred. Please try again',
            isError: true,
          );
        }
      } finally {
        setState(() {
          _busy = false;
        });
      }
    }
  }
}

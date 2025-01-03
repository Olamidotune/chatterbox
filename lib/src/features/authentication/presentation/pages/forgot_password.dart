import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/constants/app_strings.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:chatterbox/src/shared/button.dart';
import 'package:chatterbox/src/shared/custom_snackbar.dart';
import 'package:chatterbox/src/shared/custom_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const routeName = '/forgot-password';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool _busy = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.horizontalSpacing),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/png/logo.png',
                    width: 500.width, height: 200.height),
                Center(
                  child: Text(
                    AppStrings.hiThereYouForgotYourPassword,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.primaryTextColor,
                          fontSize: 24.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                AppSpacing.verticalSpaceMedium,
                Text(
                  AppStrings.enterYourEmailAndWellSendYouAResetLink,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: AppColors.greyColor,
                        fontSize: 18.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceMedium,
                Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    hintText: AppStrings.enterRegisteredEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    prefixIcon: 'email',
                    title: AppStrings.enterRegisteredEmail,
                    validator: (value) {
                      if (EmailValidator.validate(value?.trim() ?? '')) {
                        return null;
                      }
                      return AppStrings.invalidEmailAddress;
                    },
                  ),
                ),
                AppSpacing.verticalSpaceMedium,
                Button(
                  busy: _busy,
                  text: 'Send Reset Link',
                  onPressed: _sendResetLink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendResetLink() async {
    if (!_busy && _formKey.currentState!.validate()) {
      setState(() {
        _busy = true;
      });
      // send reset link
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: controller.text.trim(),
        );
        debugPrint(FirebaseAuth.instance.currentUser.toString());
        CustomSnackbar.show(
          context,
          'If an account exists with this email, a password reset link will be sent',
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } on FirebaseAuthException catch (e) {
        debugPrint(e.toString());
        if (e.code == 'user-not-found') {
          CustomSnackbar.show(context, 'User not found');
        }
        CustomSnackbar.show(context, e.message ?? 'An error occurred',
            isError: true);
      } finally {
        setState(() {
          _busy = false;
        });
      }
    }
  }
}

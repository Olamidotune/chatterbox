import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final snackBar = SnackBar(
      showCloseIcon: true,
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? AppColors.errorColor : AppColors.greenColor,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

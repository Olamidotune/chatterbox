import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    required this.text,
    this.onPressed,
    this.buttonColor = AppColors.primaryColor,
    this.textColor = AppColors.whiteColor,
    this.busy = false,
    this.pill = false,
    this.deleteButton = false,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final Color textColor;
  final bool busy;
  final bool pill;
  final bool deleteButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          enableFeedback: true,
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.pressed)) {
                return buttonColor.withOpacity(0.5);
              } else if (states.contains(WidgetState.disabled)) {
                return buttonColor.withOpacity(0.5);
              }
              return buttonColor;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: BorderSide(
                color: deleteButton
                    ? AppColors.redColor
                    : buttonColor == Colors.white
                        ? AppColors.primaryColor
                        : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(pill ? 50.radius : 10.radius),
            ),
          ),
        ),
        child: busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16.fontSize,
                      color: deleteButton
                          ? AppColors.redColor
                          : buttonColor == Colors.white
                              ? AppColors.primaryColor
                              : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

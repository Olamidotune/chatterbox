import 'package:chatterbox/src/core/constants/app_colors.dart';
import 'package:chatterbox/src/core/constants/app_spacing.dart';
import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.keyboardType,
    this.customFilled,
    this.title,
    super.key,
    this.obscureText = false,
    this.isPassword = false,
    this.isFilled = true,
    this.validator,
    this.textInputAction,
    this.onSuffixIconPressed,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.maxLength,
    this.fillColor,
    this.editIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? title;
  final String hintText;
  final Color? fillColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? prefixIcon;
  final Widget? editIcon;
  final bool isPassword;
  final bool isFilled;
  final bool? customFilled;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function()? onSuffixIconPressed;
  final void Function()? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 12.fontSize,
                ),
          ),
        ),
        AppSpacing.verticalSpaceSmall,
        TextFormField(
          cursorColor: AppColors.whiteColor,
          maxLength: maxLength,
          onEditingComplete: onFieldSubmitted,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 14.fontSize,
                color: AppColors.primaryTextColor,
              ),
          focusNode: focusNode,
          textInputAction: textInputAction,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.whiteColor),
              borderRadius: BorderRadius.circular(8),
            ),
            fillColor: fillColor ??
                (customFilled ?? true ? AppColors.blackColor : null),
            filled: isFilled,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14.fontSize,
                  color: AppColors.greyColor,
                ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: prefixIcon == null
                  ? null
                  : SvgPicture.asset(
                      'assets/svg/$prefixIcon.svg',
                      color: AppColors.whiteColor,
                    ),
            ),
            suffixIcon: customFilled ?? false
                ? Padding(
                    padding: const EdgeInsets.all(13),
                    child: editIcon,
                  )
                : isPassword
                    ? IconButton(
                        onPressed: onSuffixIconPressed,
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.greyColor,
                        ),
                      )
                    : null,
          ),
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }
}

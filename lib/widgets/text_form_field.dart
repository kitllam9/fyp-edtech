import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';

class MainTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final bool? obsureText;
  final Widget? suffix;
  final String? hintText;
  final AutovalidateMode? autovalidateMode;
  final TextStyle? errorStyle;
  const MainTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.obsureText,
    this.onChanged,
    this.suffix,
    this.hintText,
    this.autovalidateMode,
    this.errorStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      cursorColor: AppColors.primary,
      obscureText: obsureText ?? false,
      onChanged: onChanged,
      style: TextStyle(color: AppColors.primary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.unselected,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        errorStyle: errorStyle ?? TextStyle(color: AppColors.error),
        suffixIcon: suffix,
        suffixIconConstraints: BoxConstraints(
          maxHeight: double.infinity,
        ),
        hintText: hintText,
      ),
    );
  }
}

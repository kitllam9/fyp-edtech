import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';

class MainTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obsureText;
  const MainTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.obsureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      cursorColor: AppColors.primary,
      obscureText: obsureText ?? false,
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
      ),
    );
  }
}

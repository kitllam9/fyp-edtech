import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

AppBar mainAppBar(BuildContext context, {required String title, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: AppColors.primary,
    title: Text(
      title,
      style: TextStyle(
        color: AppColors.secondary,
      ),
    ),
    centerTitle: true,
    leading: TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Icon(
        Symbols.arrow_back_ios,
        color: AppColors.secondary,
        size: 20,
      ),
    ),
    actions: actions,
  );
}

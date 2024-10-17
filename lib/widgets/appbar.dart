import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

AppBar mainAppBar(BuildContext context, {required String title, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: Color(0xFF0F0F0F),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    leading: TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Icon(
        Symbols.arrow_back_ios,
        color: Colors.white,
        size: 20,
      ),
    ),
    actions: actions,
  );
}

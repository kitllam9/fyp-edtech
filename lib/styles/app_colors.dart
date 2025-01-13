import 'package:flutter/material.dart';
import 'package:fyp_edtech/utils/globals.dart';

class AppColors {
  static final Color _text = Color(0xFF767676);
  static final Color _primary = Color(0xFF0F0F0F);
  static final Color _secondary = Colors.white;
  static final Color _unselected = Color(0xFF8E8E8E);
  static final Color _scaffold = Color.fromARGB(255, 248, 248, 248);
  static final Color _error = Color(0xFFB00020);
  static final Color _success = Color(0xFF43A047);
  static final Color _shimmerBase = Colors.grey.shade300;
  static final Color _shimmerHighlight = Colors.grey.shade100;

  // Dark mode colors
  static final Color _darkText = Color(0xFF767676);
  static final Color _darkPrimary = const Color.fromARGB(255, 219, 219, 219);
  static final Color _darkSecondary = Color.fromARGB(255, 22, 22, 22);
  static final Color _darkUnselected = Color(0xFF8E8E8E);
  static final Color _darkScaffold = Color.fromARGB(255, 28, 28, 28);
  static final Color _darkError = Color.fromARGB(255, 197, 74, 97);
  static final Color _darkSuccess = Color(0xFF4CAF50);
  static final Color _darkShimmerBase = Color.fromARGB(255, 28, 28, 28);
  static final Color _darkShimmerHighlight = Color.fromARGB(255, 35, 35, 35);

  static Color get text => Globals.darkMode! ? _darkText : _text;
  static Color get primary => Globals.darkMode! ? _darkPrimary : _primary;
  static Color get secondary => Globals.darkMode! ? _darkSecondary : _secondary;
  static Color get unselected => Globals.darkMode! ? _darkUnselected : _unselected;
  static Color get scaffold => Globals.darkMode! ? _darkScaffold : _scaffold;
  static Color get error => Globals.darkMode! ? _darkError : _error;
  static Color get success => Globals.darkMode! ? _darkSuccess : _success;
  static Color get shimmerBase => Globals.darkMode! ? _darkShimmerBase : _shimmerBase;
  static Color get shimmerHighlight => Globals.darkMode! ? _darkShimmerHighlight : _shimmerHighlight;
}

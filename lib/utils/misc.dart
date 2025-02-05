import 'package:flutter/material.dart';

void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

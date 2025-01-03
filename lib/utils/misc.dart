import 'package:flutter/material.dart';

void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

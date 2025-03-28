import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/auth/auth_page.dart';
import 'package:fyp_edtech/pages/bookmark_page.dart';
import 'package:fyp_edtech/pages/auth/forget_password_page.dart';
import 'package:fyp_edtech/pages/settings/preference_page.dart';
import 'package:fyp_edtech/pages/settings/profile_edit_page.dart';
import 'package:fyp_edtech/pages/settings/settings_page.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/home': (context) => const AppLayout(index: 0),
  '/bookmark': (context) => const BookmarkPage(),
  '/settings': (context) => const SettingsPage(),
  '/profile-edit': (context) => const ProfileEditPage(),
  '/auth': (context) => const AuthPage(),
  '/forget-password': (context) => const ForgetPasswordPage(),
  '/preferences': (context) => const PreferencePage(),
};

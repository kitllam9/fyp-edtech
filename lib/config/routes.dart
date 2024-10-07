import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/bookmark_page.dart';
import 'package:fyp_edtech/pages/settings_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/bookmark': (context) => const BookmarkPage(),
  '/settings': (context) => const SettingsPage(),
};

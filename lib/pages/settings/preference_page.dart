import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fyp_edtech/main.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/appbar.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  AppBrightness selectedBrightness = Globals.brightness!;
  SharedPreferences? prefs;

  final ScrollController _scrollController = ScrollController();

  final List<String> _interests = getIt.get<User>().interest ?? [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = getIt.get<SharedPreferences>();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        context,
        title: 'Preferences',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GenericButton(
              onPressed: () async {
                generalDialog(
                  icon: Symbols.info,
                  title: 'Are you sure?',
                  msg: 'The application needs to be restarted for the settings to take into effect.',
                  cancelText: 'Cancel',
                  confirmText: Platform.isAndroid ? 'Restart' : 'Yes',
                  onConfirmed: () async {
                    switch (selectedBrightness) {
                      case AppBrightness.light:
                        await prefs?.setString('brightness', 'light');
                        Globals.darkMode = false;
                        Globals.brightness = AppBrightness.light;
                        break;
                      case AppBrightness.dark:
                        await prefs?.setString('brightness', 'dark');
                        Globals.darkMode = true;
                        Globals.brightness = AppBrightness.dark;
                        break;
                      case AppBrightness.system:
                        await prefs?.remove('brightness');
                        var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
                        Globals.darkMode = brightness == Brightness.dark;
                        Globals.brightness = AppBrightness.system;
                        break;
                    }
                    if (Platform.isAndroid) {
                      Restart.restartApp();
                    } else {
                      Navigator.of(navigatorKey.currentContext!).pop();
                    }
                  },
                );
              },
              child: Text(
                'Save\nChanges',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Box(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: RawScrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        crossAxisMargin: 5,
                        thickness: 2,
                        thumbColor: AppColors.primary,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (String interest in _interests)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        interest,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 12),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _interests.remove(interest);
                                            });
                                          },
                                          style: IconButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            overlayColor: Colors.transparent,
                                          ),
                                          icon: Icon(
                                            Symbols.close,
                                            size: 18,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Box(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GenericButton(
                        onPressed: () {
                          setState(() {
                            selectedBrightness = AppBrightness.light;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Light',
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                            if (selectedBrightness == AppBrightness.light)
                              Icon(
                                Symbols.check,
                                size: 18,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GenericButton(
                        onPressed: () {
                          setState(() {
                            selectedBrightness = AppBrightness.dark;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dark',
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                            if (selectedBrightness == AppBrightness.dark)
                              Icon(
                                Symbols.check,
                                size: 18,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GenericButton(
                        onPressed: () {
                          setState(() {
                            selectedBrightness = AppBrightness.system;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Automatic (system settings)',
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                            if (selectedBrightness == AppBrightness.system)
                              Icon(
                                Symbols.check,
                                size: 18,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

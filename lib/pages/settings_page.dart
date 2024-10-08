import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/appbar.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: 'Settings', context),
      body: Column(
        children: [
          Box(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenericButton(
                    onPressed: () => Navigator.of(context).pushNamed('/profile-edit'),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                  GenericButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Preferences',
                              style: TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, Map>? menuItems;
  final User user = GetIt.instance.get<User>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await user.getUserData();
      setState(() {});
    });
    menuItems = {
      'Bookmarks': {
        'icon': Symbols.bookmark,
        'onPressed': () {
          Navigator.of(context).pushNamed(
            '/bookmark',
          );
        }
      },
      'Settings': {
        'icon': Symbols.settings,
        'onPressed': () {
          Navigator.of(context).pushNamed(
            '/settings',
          );
        }
      },
      'Help': {
        'icon': Symbols.help,
        'onPressed': () async {
          if (!await launchUrl(Uri.parse('https://github.com/kitllam9/fyp-edtech'))) {
            throw Exception('Could not launch');
          }
        }
      },
      'Logout': {
        'icon': Symbols.logout,
        'onPressed': () async {
          context.loaderOverlay.show();
          await user.logout().then((success) {
            if (success) {
              if (!mounted) return;
              context.loaderOverlay.hide();
              Navigator.of(context).pushNamed(
                '/auth',
              );
            }
          });
        }
      },
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Box(
          margin: EdgeInsets.only(top: 15),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 60,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username ?? '',
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${user.points ?? 0}',
                          ),
                          TextSpan(
                            text: ' Points',
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Box(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: [
                for (var item in menuItems!.entries) ...[
                  GenericButton(
                    onPressed: item.value['onPressed'],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              item.value['icon'],
                              color: AppColors.primary,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              item.key,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (item.key != menuItems!.entries.last.key)
                          Divider(
                            height: 35,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

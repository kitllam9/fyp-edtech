import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:material_symbols_icons/symbols.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Box(
        margin: EdgeInsets.all(5),
        child: Container(
          padding: EdgeInsets.all(15),
          height: 100,
          child: Row(
            children: [
              Icon(
                Symbols.workspace_premium,
                size: 50,
                color: AppColors.primary,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

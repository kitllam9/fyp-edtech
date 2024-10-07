import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Settings',
          style: TextStyle(
            color: AppColors.secondary,
          ),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Symbols.arrow_back_ios,
            color: AppColors.secondary,
            size: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (context, index) => Box(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.text,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Description',
                  style: TextStyle(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

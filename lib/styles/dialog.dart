import 'package:flutter/material.dart';
import 'package:fyp_edtech/main.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';

void generalDialog({
  required IconData icon,
  required String title,
  required String msg,
}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(
                      color: AppColors.text,
                    ),
                    minimumSize: Size(Globals.screenWidth! * 0.22, 30),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: Colors.transparent,
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(
                  width: 25,
                ),
                IconTextButton(
                  width: Globals.screenWidth! * 0.22,
                  height: 30,
                  text: Text(
                    'Yes',
                    style: TextStyle(
                      color: AppColors.secondary,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).popUntil(
                    (route) => route.isFirst || route.settings.name == '/bookmark',
                  ),
                  backgroundColor: AppColors.primary,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

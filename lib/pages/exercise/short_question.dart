import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';

class ShortQuestion extends StatelessWidget {
  final Widget question;
  const ShortQuestion({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Box(
            constraints: BoxConstraints(
              minHeight: 300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: question,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.unselected,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                    hintText: 'Answer',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Globals.screenHeight! * 0.25,
          ),
        ],
      ),
    );
  }
}

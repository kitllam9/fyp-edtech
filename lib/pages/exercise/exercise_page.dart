import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/pages/exercise/multiple_choice.dart';
import 'package:fyp_edtech/pages/exercise/short_question.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int _currentPage = 1;
  final int _total = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: Globals.screenHeight! * 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconTextButton(
              width: Globals.screenWidth! * 0.25,
              height: 35,
              backgroundColor: AppColors.primary,
              icon: Icon(
                Symbols.close,
                color: AppColors.secondary,
                size: 18,
              ),
              text: Text(
                'Exit',
                style: TextStyle(color: AppColors.secondary),
              ),
              onPressed: () {
                generalDialog(
                  icon: Symbols.help,
                  title: 'Are you sure?',
                  msg: 'Do you really want to exit? All your unsaved progress will be lost.',
                  onConfirmed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                );
              },
            ),
            IconTextButton(
              width: Globals.screenWidth! * 0.25,
              height: 35,
              backgroundColor: AppColors.primary,
              icon: Icon(
                Symbols.save,
                color: AppColors.secondary,
                size: 18,
              ),
              text: Text(
                'Save',
                style: TextStyle(color: AppColors.secondary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconTextButton(
              width: Globals.screenWidth! * 0.25,
              height: 35,
              backgroundColor: AppColors.primary,
              icon: Icon(
                _currentPage == _total ? Symbols.check : Symbols.arrow_forward,
                color: AppColors.secondary,
                size: 18,
              ),
              text: Text(
                _currentPage == _total ? 'Finish' : 'Next',
                style: TextStyle(color: AppColors.secondary),
              ),
              onPressed: () {
                if (_currentPage == _total) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CompletedPage(
                        type: CompletedType.exercise,
                      ),
                    ),
                  );
                } else {
                  setState(() {
                    _currentPage = _currentPage + 1;
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _currentPage.isEven
                ? MultipleChoice(
                    question: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Question'),
                      ],
                    ),
                    choices: {
                      'A': '12323',
                      'B': '12323',
                      'C': '12323',
                      'D': '12323',
                    },
                  )
                : ShortQuestion(
                    question: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Question'),
                      ],
                    ),
                  ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              height: 2,
              width: Globals.screenWidth! * (_currentPage / _total),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/question.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/pages/exercise/multiple_choice.dart';
import 'package:fyp_edtech/pages/exercise/short_question.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExercisePage extends StatefulWidget {
  final List<Question> questions;
  const ExercisePage({
    super.key,
    required this.questions,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int _currentPage = 1;
  Question? _currentQuestion;
  int? _total;

  @override
  void initState() {
    _total = widget.questions.length;
    _currentQuestion = widget.questions[_currentPage];
    super.initState();
  }

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
                    _currentQuestion = widget.questions[_currentPage - 1];
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
            _currentQuestion?.type == QuestionType.mc
                ? MultipleChoice(
                    key: ValueKey(DateTime.now()),
                    question: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _currentQuestion?.question ?? '',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    choices: {
                      'A': _currentQuestion?.choices?[0],
                      'B': _currentQuestion?.choices?[1],
                      'C': _currentQuestion?.choices?[2],
                      'D': _currentQuestion?.choices?[3],
                    },
                  )
                : ShortQuestion(
                    question: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentQuestion?.question ?? '',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              height: 2,
              width: _total != null ? Globals.screenWidth! * (_currentPage / _total!) : 0,
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

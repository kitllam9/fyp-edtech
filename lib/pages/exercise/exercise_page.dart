import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/badge.dart';
import 'package:fyp_edtech/model/question.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/pages/exercise/multiple_choice.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/styles/dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';

final User user = GetIt.instance.get<User>();

enum ExerciseViewMode {
  regular,
  review,
}

class ExercisePage extends StatefulWidget {
  final int id;
  final List<Question> questions;
  final int points;
  final ExerciseViewMode mode;
  final Map<String, List<String>>? results;
  const ExercisePage({
    super.key,
    required this.questions,
    required this.id,
    required this.points,
    required this.mode,
    this.results,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int _currentPage = 0;
  Question? _currentQuestion;
  String? _currentAnswer;
  List<String> _selectedAnswer = [];
  int correctCount = 0;
  int? _total;
  double percentage = 1;

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
              onPressed: () async {
                if (_currentAnswer == null && widget.mode == ExerciseViewMode.regular) return;
                if (widget.mode == ExerciseViewMode.regular) _selectedAnswer.add(_currentAnswer!);
                if (_currentAnswer == _currentQuestion?.answer) {
                  correctCount++;
                }
                if (_currentPage == _total! - 1) {
                  if (widget.mode == ExerciseViewMode.regular) {
                    percentage = correctCount / widget.questions.length;
                    await user.checkBadges(points: (widget.points * percentage).round()).then((map) {
                      if (!context.mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => CompletedPage(
                            contentId: widget.id,
                            type: CompletedType.exercise,
                            correct: correctCount,
                            total: widget.questions.length,
                            questions: widget.questions,
                            results: {
                              'selected': _selectedAnswer,
                              'answer': widget.questions.map((q) => q.answer).toList(),
                            },
                            targets: List<int>.from(map!['targets']),
                            currentPoints: map['current_points'],
                            targetPoints: map['target_points'],
                            earnedBadges: [for (var json in map['earned_badges']) MyBadge.fromJson(json)],
                          ),
                        ),
                      );
                    });
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  }
                } else {
                  setState(() {
                    _currentPage = _currentPage + 1;
                    _currentQuestion = widget.questions[_currentPage];
                    if (widget.mode == ExerciseViewMode.regular) _currentAnswer = null;
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
            MultipleChoice(
              key: ValueKey(DateTime.now()),
              mode: widget.mode,
              results: widget.results != null
                  ? {
                      'selected': widget.results!['selected']![_currentPage],
                      'answer': widget.results!['answer']![_currentPage],
                    }
                  : null,
              onSelected: (selected) {
                _currentAnswer = selected;
              },
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

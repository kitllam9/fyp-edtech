import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/badge.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/question.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/file_io.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

enum CompletedType {
  notes,
  exercise,
  quest,
}

final User user = GetIt.instance.get<User>();

class CompletedPage extends StatefulWidget {
  final int? contentId;
  final CompletedType type;

  /// Notes
  final String? pdfUrl;

  /// Exercise
  final int? correct;
  final int? total;
  final List<Question>? questions;
  final Map<String, List<String>>? results;

  /// Points & Badges
  final List<int> targets;
  final int currentPoints;
  final int targetPoints;
  final List<MyBadge> earnedBadges;
  const CompletedPage({
    super.key,
    this.contentId,
    required this.type,
    this.pdfUrl,
    this.correct,
    this.total,
    this.questions,
    this.results,
    required this.targets,
    required this.currentPoints,
    required this.targetPoints,
    required this.earnedBadges,
  });

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  double ratio = 0;

  bool _progressAnimationFinished = false;
  bool _initDisplay = true;

  void ratioVal() async {
    if (!mounted) return;
    if (ratio == 0) {
      setState(() {
        ratio = widget.currentPoints / widget.targets[0];
      });
      if (ratio == widget.currentPoints / widget.targets[0]) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _initDisplay = false;
            if (widget.targetPoints / widget.targets[0] >= 1) {
              ratio = 1;
            } else {
              ratio = widget.targetPoints / widget.targets[0];
            }
          });
          if (widget.targetPoints / widget.targets[0] >= 1 && ratio == 1) {
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                ratio = 0;
              });
              if (ratio == 0) {
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
                    _initDisplay = false;
                    if (widget.targetPoints / widget.targets[1] >= 1) {
                      ratio = 1;
                    } else {
                      ratio = widget.targetPoints / widget.targets[1];
                    }
                  });
                  if (widget.targetPoints / widget.targets[1] >= 1 && ratio == 1) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        ratio = 0;
                      });
                      if (ratio == 0) {
                        Future.delayed(Duration(milliseconds: 500), () {
                          setState(() {
                            ratio = widget.targetPoints / widget.targets[2];
                          });
                          if (ratio == widget.targetPoints / widget.targets[2]) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              setState(() {
                                _progressAnimationFinished = true;
                              });
                            });
                          }
                        });
                      }
                    });
                  } else {
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        _progressAnimationFinished = true;
                      });
                    });
                  }
                });
              }
            });
          } else {
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _progressAnimationFinished = true;
              });
            });
          }
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 450));
      for (int index = 0; index < widget.earnedBadges.length; index++) {
        if (!mounted) return;
        ElegantNotification(
          stackedOptions: StackedOptions(
            key: widget.earnedBadges[index].name,
            itemOffset: Offset(0, (index + 1) * -125),
            type: StackedType.below,
          ),
          toastDuration: Duration(seconds: 7),
          animationDuration: Duration(seconds: 1),
          animationCurve: Curves.easeInOut,
          background: AppColors.secondary,
          title: Text(
            widget.earnedBadges[index].name,
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
          description: Text(
            widget.earnedBadges[index].description,
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
          icon: Icon(
            Icons.workspace_premium,
            color: AppColors.primary,
          ),
          progressIndicatorColor: AppColors.primary,
        ).show(context);
      }
    });
  }

  @override
  void initState() {
    ratioVal();
    if (widget.type == CompletedType.notes || widget.type == CompletedType.exercise) {
      Content.complete(widget.contentId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: widget.type == CompletedType.notes ? Globals.screenHeight! * 0.25 : Globals.screenHeight! * 0.2,
              ),
              if (widget.type == CompletedType.notes)
                Text(
                  'You\'ve completed a reading!',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              if (widget.type == CompletedType.exercise) ...[
                Text(
                  '${((widget.correct! / widget.total!) * 100).toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 66,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'You got ${widget.correct!} out of ${widget.total!} questions right!',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
              ],
              if (widget.type == CompletedType.quest)
                Text(
                  'You\'ve completed a quest!',
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              SizedBox(
                height: 50,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Text slide transitions
                  AnimatedContainer(
                    width: Globals.screenWidth! * 0.8,
                    duration: Duration(milliseconds: 750),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.translationValues(0, _progressAnimationFinished ? -20 : 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '+${(widget.targetPoints - widget.currentPoints).toStringAsFixed(0)} Points',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    width: Globals.screenWidth! * 0.8,
                    duration: Duration(milliseconds: 750),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.translationValues(0, _progressAnimationFinished ? 20 : 0, 0),
                    child: Row(
                      children: [
                        Text(
                          '(${(widget.targetPoints % widget.targets.last == 0 ? widget.targets.last : widget.targets.last - (widget.targetPoints % widget.targets.last))} points until the next badge)',
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mask to hide text before transition
                  Container(
                    color: AppColors.scaffold,
                    height: 20,
                    width: Globals.screenWidth,
                  ),
                  SimpleAnimationProgressBar(
                    ratio: ratio,
                    width: Globals.screenWidth! * 0.8,
                    height: 4,
                    borderRadius: BorderRadius.circular(8),
                    direction: Axis.horizontal,
                    backgroundColor: AppColors.unselected,
                    foregrondColor: AppColors.primary,
                    duration: _initDisplay || ratio == 0 ? Duration.zero : Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                  ),
                ],
              ),
              SizedBox(
                height: widget.type == CompletedType.quest ? Globals.screenHeight! * 0.3 : Globals.screenHeight! * 0.25,
              ),
              Column(
                children: [
                  if (widget.type != CompletedType.quest)
                    IconTextButton(
                      onPressed: () async {
                        if (widget.type == CompletedType.notes) {
                          await downloadFile(
                            widget.pdfUrl!,
                            '${widget.contentId}.pdf',
                            (await getDownloadsDirectory())!.path,
                          ).then((val) {
                            final snackBar = SnackBar(
                              content: Text(
                                'File saved sucessfully!',
                                style: TextStyle(color: AppColors.secondary),
                              ),
                              backgroundColor: AppColors.primary.withAlpha(230),
                              behavior: SnackBarBehavior.floating,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                        } else if (widget.type == CompletedType.exercise) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => ExercisePage(
                                questions: widget.questions!,
                                id: widget.contentId!,
                                points: 0,
                                mode: ExerciseViewMode.review,
                                results: widget.results,
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: AppColors.primary,
                      width: Globals.screenWidth! * 0.8,
                      height: 35,
                      icon: Icon(
                        widget.type == CompletedType.notes ? Symbols.download : Symbols.insights,
                        color: AppColors.secondary,
                      ),
                      text: Text(
                        widget.type == CompletedType.notes ? 'Save' : 'Review Your Results',
                        style: TextStyle(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  IconTextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => AppLayout(index: 0),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => false,
                    ),
                    backgroundColor: AppColors.primary,
                    width: Globals.screenWidth! * 0.8,
                    height: 35,
                    icon: Icon(
                      Symbols.home,
                      color: AppColors.secondary,
                    ),
                    text: Text(
                      'Return to Home',
                      style: TextStyle(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/service/local_storage.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/file_io.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

enum CompletedType {
  notes,
  exercise,
  quest,
}

class CompletedPage extends StatefulWidget {
  final CompletedType type;
  final int contentId;
  const CompletedPage({
    super.key,
    required this.type,
    required this.contentId,
  });

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final double _totalPoints = 100;

  final double _currentValue = 24;
  final double _targetValue = 120;
  double ratio = 0;

  bool _progressAnimationFinished = false;
  bool _initDisplay = true;

  void ratioVal() async {
    if (mounted) {
      if (ratio == 0) {
        setState(() {
          ratio = _currentValue / _totalPoints;
        });
        if (ratio == _currentValue / _totalPoints) {
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _initDisplay = false;
              if (_targetValue / _totalPoints >= 1) {
                ratio = 1;
              } else {
                ratio = _targetValue / _totalPoints;
              }
            });
            if (_targetValue / _totalPoints >= 1 && ratio == 1) {
              Future.delayed(Duration(milliseconds: 500), () {
                setState(() {
                  ratio = 0;
                });
                if (ratio == 0) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      ratio = (_targetValue - _totalPoints) / _totalPoints;
                    });
                    if (ratio == (_targetValue - _totalPoints) / _totalPoints) {
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
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_targetValue >= _totalPoints) {
        await Future.delayed(Duration(milliseconds: 450));
        if (!mounted) return;
        ElegantNotification(
          toastDuration: Duration(seconds: 7),
          animationDuration: Duration(seconds: 1),
          animationCurve: Curves.easeInOut,
          title: Text(
            'Badge Title',
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
          description: Text(
            "Some badge description",
            style: TextStyle(
              color: AppColors.secondary,
            ),
          ),
          icon: Icon(
            Icons.workspace_premium,
            color: AppColors.secondary,
          ),
          progressIndicatorColor: AppColors.secondary,
        ).show(context);
      }
    });
  }

  @override
  void initState() {
    ratioVal();
    if (widget.type == CompletedType.notes || widget.type == CompletedType.exercise) {
      Content.complete(widget.contentId);
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
                  '90%',
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
                  'You got 9 out of 10 questions right!',
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
                          '+${(_targetValue - _currentValue).toStringAsFixed(0)} Points',
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
                          '(${(_targetValue % _totalPoints == 0 ? _totalPoints : _totalPoints - (_targetValue % _totalPoints)).toStringAsFixed(0)} points until the next badge)',
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
                          File file = await getFileFromAssets('sample.pdf');
                          Uint8List bytes = file.readAsBytesSync();

                          await LocalStorage.write(bytes, 'sample.pdf').then((val) {
                            final snackBar = SnackBar(
                              content: Text(
                                'File saved sucessfully!',
                                style: TextStyle(color: AppColors.secondary),
                              ),
                              backgroundColor: AppColors.primary.withOpacity(0.9),
                              behavior: SnackBarBehavior.floating,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                        } else if (widget.type == CompletedType.exercise) {}
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

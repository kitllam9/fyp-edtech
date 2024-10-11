import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

enum CompletedType {
  article,
  exercise,
}

class CompletedPage extends StatefulWidget {
  final CompletedType type;
  const CompletedPage({super.key, required this.type});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final double _totalPoints = 100;

  final double _currentValue = 24;
  final double _targetValue = 78;
  double ratio = 0;

  bool _progressAnimationFinished = false;

  void ratioVal() {
    if (ratio == 0) {
      setState(() {
        ratio = _currentValue / _totalPoints;
      });
      if (ratio == _currentValue / _totalPoints) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            ratio = _targetValue / _totalPoints;
          });
        }).then((val) {
          Future.delayed(Duration(milliseconds: 750), () {
            setState(() {
              _progressAnimationFinished = true;
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ratioVal();
    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTextButton(
                onPressed: () {},
                backgroundColor: AppColors.primary,
                width: Globals.screenWidth! * 0.8,
                height: 35,
                icon: Icon(
                  Symbols.download,
                  color: AppColors.secondary,
                ),
                text: Text(
                  'Save the article locally',
                  style: TextStyle(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.type == CompletedType.article)
                  Text(
                    'You\'ve completed a reading!',
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
                          Text('+${(_targetValue - _currentValue).toStringAsFixed(0)} Points'),
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
                          Text('(${(_totalPoints - _targetValue).toStringAsFixed(0)} points until the next badge)'),
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
                      duration: ratio <= _currentValue / _totalPoints ? Duration.zero : Duration(milliseconds: 750),
                      curve: Curves.easeInOutCubic,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

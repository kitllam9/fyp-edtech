import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';

class MultipleChoice extends StatefulWidget {
  final Widget question;
  final Map<String, String> choices;
  const MultipleChoice({
    super.key,
    required this.question,
    required this.choices,
  });

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  List<bool>? selected;

  @override
  void initState() {
    selected = List.generate(widget.choices.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Box(
            constraints: BoxConstraints(
              minHeight: 300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: widget.question,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Expanded(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.choices.length,
              itemBuilder: (BuildContext context, int index) {
                var c = widget.choices.entries.toList()[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GenericButton(
                      onPressed: () {
                        setState(() {
                          selected!.setAll(0, [false, false, false, false]);
                          selected![index] = !selected![index];
                        });
                      },
                      child: Box(
                        backgroundColor: selected![index] ? AppColors.primary : AppColors.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Text(
                                c.key,
                                style: TextStyle(color: selected![index] ? AppColors.secondary : AppColors.primary),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                c.value,
                                style: TextStyle(color: selected![index] ? AppColors.secondary : AppColors.primary),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

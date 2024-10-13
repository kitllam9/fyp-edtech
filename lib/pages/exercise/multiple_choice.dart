import 'package:flutter/material.dart';
import 'package:fyp_edtech/widgets/box.dart';

class MultipleChoice extends StatelessWidget {
  final Widget question;
  final Map<String, String> choices;
  const MultipleChoice({
    super.key,
    required this.question,
    required this.choices,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Box(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                child: question,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          for (var c in choices.entries) ...[
            Box(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(c.key),
                      SizedBox(
                        width: 10,
                      ),
                      Text(c.value)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ]
        ],
      ),
    );
  }
}

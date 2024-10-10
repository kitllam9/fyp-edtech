import 'package:flutter/material.dart';

class TitlePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  const TitlePlaceholder({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 18,
      color: Colors.white,
    );
  }
}

class ContentPlaceholder extends StatelessWidget {
  final int lines;
  final double? height;
  const ContentPlaceholder({super.key, required this.lines, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < lines; i++) ...[
          Container(
            width: double.infinity,
            height: height ?? 10,
            color: Colors.white,
          ),
          if (i != lines - 1)
            SizedBox(
              height: 8,
            ),
        ]
      ],
    );
  }
}

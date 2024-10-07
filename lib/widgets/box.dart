import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  const Box({
    super.key,
    required this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2.5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

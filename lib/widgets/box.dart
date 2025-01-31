import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';

class Box extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  const Box({
    super.key,
    required this.child,
    this.margin,
    this.constraints,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      constraints: constraints,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor ?? AppColors.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
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

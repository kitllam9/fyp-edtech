import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const GenericButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
        alignment: Alignment.topLeft,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

class IconTextButton extends StatelessWidget {
  final Icon icon;
  final Text text;
  final Function() onPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        overlayColor: Colors.transparent,
        minimumSize: Size(width ?? 0, height ?? 0),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 5,
          ),
          text,
        ],
      ),
    );
  }
}

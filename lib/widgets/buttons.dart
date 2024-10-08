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
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

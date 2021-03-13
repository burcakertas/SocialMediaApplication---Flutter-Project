import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  //constructor for the class (properties)
  CustomRaisedButton({this.borderRadius, this.child, this.color, this.onPressed});
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
    );
  }
}

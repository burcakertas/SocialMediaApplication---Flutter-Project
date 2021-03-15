import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  //constructor for the class (properties)
  CustomRaisedButton({this.borderRadius:4.0, this.child, this.color, this.onPressed, this.height: 50});
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}

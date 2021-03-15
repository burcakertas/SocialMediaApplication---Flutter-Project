import 'package:flutter/cupertino.dart';
import '../../common_widgets/custom_raised_button.dart';

//Sadece text yazılacak (child'a gerek duyulmayacak button için)
class ButtonWithText extends CustomRaisedButton{
  ButtonWithText ({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,

  }) : super(
    child: Text(text, style: TextStyle(color: textColor, fontSize: 18)
    ),
    color: color,
    onPressed: onPressed,
    height: 50,
  );
}
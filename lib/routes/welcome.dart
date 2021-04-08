import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:banana/util/Colors.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:<Widget> [
        Center(
          child:Image(
            image:AssetImage(
              "assets/banana_welcome.png"
            ),
            width: 70,
            height: 70,
          )
        ),
        Center(
          child: Text("Reach the whole world \n\t\t with a single click."
          ,style: GoogleFonts.openSans(
                fontStyle: FontStyle.normal,
                textStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
                )
              )
          ),
        ),
        ElevatedButton(
          child:Text("Create an account",
            style:TextStyle(
              fontSize: 12,
              color: Colors.white
            )
          )
        ,onPressed: (){
            Navigator.pushNamed(context, "/signup");
        },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(AppColors().themeColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                  )
              )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.pushNamed(context, "/login");
              },
              child: Row(
                children: <Widget>[
                  Text("Already have an account?",
                      style:GoogleFonts.openSans(
                          textStyle:TextStyle(
                              color: AppColors().batmanGrey
                          ),
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Text(" Login",
                    style:GoogleFonts.openSans(
                        textStyle:TextStyle(
                            color: AppColors().themeColor
                        ),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
            )
          ],
        )
      ],
      )
    );
  }
}

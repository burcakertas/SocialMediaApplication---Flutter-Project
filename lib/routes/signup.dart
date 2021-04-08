import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:banana/util/Colors.dart';
import 'package:passwordfield/passwordfield.dart';

class Register extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.black54,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        iconTheme: IconThemeData(
          color: Colors.black54, //change your color here
        ),
        title: Text("Sign Up",
          style: TextStyle(
              color: Colors.black54
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                SizedBox(height: 50,),
                Center(
                    child:Image(
                      image:AssetImage(
                          "assets/banana_welcome.png"
                      ),
                      width: 70,
                      height: 70,
                    )
                ),
                SizedBox(height: 25,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          decoration: InputDecoration(
                              //prefixIcon: Icon(Icons.contact_phone_rounded ),
                              suffixIcon: Icon(Icons.badge),
                              fillColor: AppColors().batmanGrey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color:AppColors().batmanGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: AppColors().themeColor, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelStyle: TextStyle(
                                  color:  Colors.black54
                              ),
                              labelText: 'Name',
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                  color:Color.fromRGBO(212, 140, 0, 1)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(left:15.0,right: 15.0,top:7,bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.contact_mail_rounded),
                              fillColor: AppColors().batmanGrey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color:AppColors().batmanGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: AppColors().themeColor, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelStyle: TextStyle(
                                  color:  Colors.black54
                              ),
                              labelText: 'Email',
                              hintText: 'abc@gmail.com',
                              hintStyle: TextStyle(
                                  color:Color.fromRGBO(212, 140, 0, 1)
                              )
                          ),
                          validator: (contact){
                            if(contact == null || contact.isEmpty){
                              return 'Please enter an email';
                            }else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(contact)){
                              return "Enter a valid email";
                            }else{
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 7, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: PasswordField(
                              suffixIcon: Icon(Icons.vpn_key_rounded,color: AppColors().batmanGrey,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color:AppColors().batmanGrey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: AppColors().themeColor, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              hintText: 'Password',
                          pattern: r'().{8,}',
                            errorMessage: 'Password must be at least 8 characters.'
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
SizedBox(height: 25,),
                ElevatedButton(
                  child:Text("Sign Up",
                      style:TextStyle(
                          fontSize: 12,
                          color: Colors.white
                      )
                  )
                  ,onPressed: (){
                    if(_formKey.currentState.validate()){
                      print("Form is valid.");
                    }else{
                      print(_formKey.currentState.validate());
                    }
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

          ],
        ),
      ),
    );
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:banana/util/Styles.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{
  Future<bool> loginUser(String mail,String pass,dynamic context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: mail,
          password: pass
      );
      print("Successfull:" + userCredential.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid@banana", userCredential.user.uid);
      print(prefs.getString("uid@banana"));
      Navigator.pushNamed(context, "/home",arguments: {"id":"0".toString()});

    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if(e.code == 'user-not-found') {
        //error user not found
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('User not found.'),
              content: Text('Check your email or password.'),
            )
        );
        return false;
      }
      else if (e.code == 'wrong-password') {
        //wrong-password
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Wrong password.'),
              content: Text('Check your email or password.'),
            )
        );
      }
    }
  }
  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final List<String> textFieldsValue = [];

  bool _isToggled = true;

  var _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.grey);

  _togglePassword() {
    setState(() {
      if (_isToggled == false) {
        _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.grey);
        _isToggled = true;
      } else {
        _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.blue);
        _isToggled = false;
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAnalytics().logEvent(name: "LoginView");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: AppColors().mostUsedBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
            child: Container(
              color: AppColors().mostUsedBlack,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        iconTheme: IconThemeData(
          color: AppColors().mostUsedBlack,
        ),
        title: Text("Login",
          style: TextStyle(
            color: AppColors().mostUsedBlack,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors().innerButtonWhite,

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
                      width: 90,
                      height: 90,
                    )
                ),
                SizedBox(height: 50,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Theme(
                          child: TextFormField(
                            decoration: AppStyles().loginEmailDecoration,
                            validator: (contact){
                              if(contact==null || contact.isEmpty){return 'Please enter your email';}
                              //else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*@[a-zA-Z0-9]+\.*[a-zA-Z]*").hasMatch(contact)){ return 'Please enter a valid username or email';}
                              else{ textFieldsValue.add(contact); return null;}
                            },
                          ),
                          data:Theme.of(context).copyWith(primaryColor: AppColors().authenticationInput),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(left:15.0,right: 15.0,top:7,bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Theme(
                          child: TextFormField(
                            onChanged: (input){
                            },
                            obscureText: _isToggled,
                            decoration: InputDecoration(
                              //prefixIcon: Icon(Icons.contact_phone_rounded ),
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
                                  color: AppColors().mostUsedBlack,
                                ),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                suffix: InkWell(
                                  onTap: (){
                                    _togglePassword();
                                  },
                                  child: _toggleIcon,
                                ),
                                hintStyle: TextStyle(
                                    color:AppColors().authenticationInput
                                )
                            ),
                            validator: (contact){
                              if(contact == null || contact.isEmpty){
                                return 'Please enter a password';
                              //}else if (!RegExp(r"^[a-zA-Z0-9\W|_]{8,}").hasMatch(contact)){return "Password must be longer or equals to 8 characters";
                              } else{
                                textFieldsValue.add(contact);
                                return null;
                              }
                            },
                          ),
                          data:Theme.of(context).copyWith(primaryColor: AppColors().authenticationInput),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: [
                TextButton(
                  child: Text("Forgot password?",
                    style:TextStyle(
                      color:AppColors().authenticationInput
                    )
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, "/profile");
                  },
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  child:Text("Log in",
                      style:TextStyle(
                          fontSize: 12,
                          color: AppColors().innerButtonWhite
                      )
                  )
                  ,onPressed: (){
                  if(_formKey.currentState.validate()){
                    print("Form is valid.");
                    FirebaseAnalytics().logEvent(name: "LoginCalled",parameters: {"username":textFieldsValue});
                    loginUser(textFieldsValue[0], textFieldsValue[1], context);

                      textFieldsValue.removeRange(0,textFieldsValue.length);
                  }else{
                    print(_formKey.currentState.validate());
                  }
                },
                  style: AppStyles().submitButton
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

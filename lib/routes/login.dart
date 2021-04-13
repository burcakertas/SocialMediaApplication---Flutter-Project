import 'package:banana/util/Styles.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:passwordfield/passwordfield.dart';


class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
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
                      width: 70,
                      height: 70,
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
                              if(contact==null || contact.isEmpty){return 'Please enter your username or email';}
                              else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*@[a-zA-Z0-9]+\.*[a-zA-Z]*").hasMatch(contact)){ return 'Please enter a valid username or email';}
                              else{return null;}
                            },
                          ),
                          data:Theme.of(context).copyWith(primaryColor: AppColors().authenticationInput),
                        ),
                      ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            //padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Theme(
                              child: PasswordField(
                              hasFloatingPlaceholder: true,
                                    floatingText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(color:AppColors().batmanGrey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:  BorderSide(color: AppColors().themeColor, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    hintText: 'Password',
                                  suffixIcon: Icon(
                                    Icons.vpn_key_rounded,
                                    color: AppColors().batmanGrey,
                                  ),
                                  pattern: r'().{8,}',
                                  errorMessage: 'Password must be at least 8 characters.'
                                ),
                              data:Theme.of(context).copyWith(primaryColor: AppColors().mostUsedBlack),
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
                  }else{
                    print(_formKey.currentState.validate());
                  }
                  Navigator.pushNamed(context, "/home");
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

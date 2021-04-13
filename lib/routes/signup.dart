import 'package:banana/util/Styles.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:passwordfield/passwordfield.dart';

class Register extends StatelessWidget {

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
        title: Text("Sign Up",
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
                SizedBox(height: 25,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Theme(
                          child: TextFormField(
                            decoration: AppStyles().nameDecoration,
                            validator: (name){
                              if(name == null || name.isEmpty){
                                return 'Please enter a name';
                              }else if(name.length<6){
                                return 'Please enter a name longer than 6 characters';
                              }else{
                                return null;
                              }
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
                            decoration: AppStyles().emailDecoration,
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
                          data:Theme.of(context).copyWith(primaryColor: AppColors().authenticationInput),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 7, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Theme(
                          child: PasswordField(
                                floatingText: "Password",
                                hasFloatingPlaceholder: true,
                                suffixIcon: Icon(Icons.vpn_key_rounded,color: AppColors().batmanGrey,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color:AppColors().batmanGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: AppColors().themeColor, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                            pattern: r'().{8,}',
                              errorMessage: 'Password must be at least 8 characters.'
                            ),
                          data: Theme.of(context).copyWith(primaryColor: AppColors().mostUsedBlack),
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
                          color: AppColors().innerButtonWhite
                      )
                  )
                  ,onPressed: (){
                    if(_formKey.currentState.validate()){
                      print("Form is valid.");
                    }else{
                      print(_formKey.currentState.validate());
                    }
                },
                  style: AppStyles().submitButton
                ),
          ],
        ),
      ),
    );
  }
}

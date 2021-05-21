import 'package:banana/util/Styles.dart';
import 'package:flutter/material.dart';
import 'package:banana/util/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final List<String> textFieldsValue = [];

  bool _isToggled = true;
  var _toggleIcon = Icon(Icons.remove_red_eye, color: Colors.grey);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<void> signupUser(String mail,String pass,String name,String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: mail, password: pass);
      print("User credentials");
      print(userCredential.toString());
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      User user = await FirebaseAuth.instance.currentUser;

      users.doc(userCredential.user.uid).set({
        'username': username, // John Doe
        'name': name, // Stokes and Sons
        'picUrl':"https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/avocado_scream_avatar_food-512.png",
        'settings': {} // 42
      })
          .then((value) => print("User Added")).catchError((error) => user.delete());
      Navigator.pushNamed(context,"/home");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid@banana", userCredential.user.uid);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if(e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Email already exists.'),
              content: Text('An user with the given email already exists.'),
            )
        );
      }
      else if(e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Weak password.'),
              content: Text('Please choose a strong password in order to proceed.'),
            )
        );
      }
    }
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
                      width: 90,
                      height: 90,
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
                                textFieldsValue.add(name);
                                return null;
                              }
                            },
                          ),
                          data:Theme.of(context).copyWith(primaryColor: AppColors().authenticationInput),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15.0,top:7,bottom: 0),
                        child: Theme(
                          child: TextFormField(
                            decoration: AppStyles().usernameDecoration,
                            validator: (name){
                              if(name == null || name.isEmpty){
                                return 'Please enter a username';
                              }else if(name.length<6){
                                return 'Please enter a username longer than 6 characters';
                              }else{
                                textFieldsValue.add(name);
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
                                textFieldsValue.add(contact);
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
                              }else if (!RegExp(r"^[a-zA-Z0-9]{4,}").hasMatch(contact)){
                                return "Weak";
                              }else if (!RegExp(r"^[a-zA-Z0-9]{8,}").hasMatch(contact)){
                                return "Middle";
                              }else{
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
                      print(textFieldsValue);
                      signupUser(textFieldsValue[2], textFieldsValue[3],textFieldsValue[0],textFieldsValue[1]);
                      textFieldsValue.clear();
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

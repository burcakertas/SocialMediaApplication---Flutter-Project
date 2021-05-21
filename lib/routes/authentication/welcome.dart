import 'package:banana/util/Colors.dart';
import 'package:banana/util/Styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<UserCredential> signInWithGoogle(var context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  var result = await FirebaseAuth.instance.signInWithCredential(credential);
  var uid = result.user.uid;
  var name = result.user.displayName;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User user = await FirebaseAuth.instance.currentUser;
  var checker = await users.doc(uid).get();
  if(checker==null || !checker.exists){
    users.doc(uid).set({
      'username': result.user.email
          .split("@")[0], // John Doe
      'name': name, // Stokes and Sons
      'picUrl':"https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/avocado_scream_avatar_food-512.png",
      'settings': {} // 42
    })
        .then((value) => print("User Added")).catchError((error) => user.delete());
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("uid@banana", uid);
  Navigator.pushNamed(context, "/home",arguments: {"id":"0".toString()});
  return result;
}
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                body:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget> [
                    Center(
                        child:Image(
                          image:AssetImage(
                              "assets/banana_welcome.png"
                          ),
                          width: 90,
                          height: 90,
                        )
                    ),
                    Center(
                      child: Text("Reach the whole world \n\t\t with a single click."
                          ,style: AppStyles().welcomeLargeText
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            child:Text("Create an account",
                                style:AppStyles().createAnAccText
                            )
                            ,onPressed: (){
                          Navigator.pushNamed(context, "/signup");
                        },
                            style: AppStyles().createAnAccButton
                        ),
                        ElevatedButton.icon(
                            label:Text("Sign-in with Google",
                              style: TextStyle(
                                  color:AppColors().mostUsedBlack
                              ),
                            )
                            ,onPressed: (){
                          //authenticate with google
                          signInWithGoogle(context);
                        },icon: FaIcon(FontAwesomeIcons.google,color: AppColors().mostUsedBlack,),
                            style:AppStyles().createGoogleAccButton
                        ),
                      ],
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
                                    style:AppStyles().alreadyHaveAccTexts["grey"]
                                ),
                                Text(" Login",
                                    style:AppStyles().alreadyHaveAccTexts["yellow"]
                                ),
                              ],
                            )
                        )
                      ],
                    )
                  ],
                )
            ),
          );
        }
      }


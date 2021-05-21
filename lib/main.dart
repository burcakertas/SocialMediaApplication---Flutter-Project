import 'package:banana/routes/profile/change_profile.dart';
import 'package:flutter/material.dart';
import 'package:banana/routes/authentication/welcome.dart';
import 'package:banana/routes/authentication/login.dart';
import 'package:banana/routes/authentication/signup.dart';
import 'package:banana/routes/authentication/walkthrough.dart';
import 'package:banana/routes/profile/profile.dart';
import 'package:banana/routes/profile/self_following.dart';
import 'package:banana/routes/profile/self_followers.dart';
import 'package:banana/routes/main/home.dart';
import 'package:banana/routes/main/message_settings.dart';
import 'package:banana/routes/main/message.dart';
import 'package:banana/routes/main/msg_candidates.dart';

import 'package:banana/routes/posting/posting.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    runApp(Gatekeeper());
}

class Gatekeeper extends StatelessWidget {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
       builder: (context,snapshot){
         if(snapshot.hasError){
           print("Cannot connect to firebase: " + snapshot.error.toString());
           return MaterialApp(
             routes:{
               '/':(context) => Scaffold(
                 body:Center(
                   child:Text(
                     "Cannot connect to Firebase"
                   )
                 )
               )
             }
           ); //actually should be a error view
         }
         if(snapshot.connectionState == ConnectionState.done){
          return App();

         }else {
             return CircularProgressIndicator();
           }
         },
     future: _initialization
   );
  }
}

class App extends StatelessWidget {
  firstTimer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("NotFirstTime")==true)
      return [false,prefs.containsKey("uid@banana")];
    else {
      prefs.setBool("NotFirstTime", true);
      bool obtained = prefs.getBool("NotFirstTime");
      return [true,null];
    }
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firstTimer(),
      builder: (context,appCap){
        if(appCap.hasError){
          return Center(child:Text("Error"));
        }else if(appCap.hasData && appCap.data[0]==true){
          return MaterialApp(
              navigatorObservers: [observer],
              initialRoute: '/',
              routes: {
                '/':(context) =>TestScreen(),
                '/welcome':(context) =>Welcome(),
                '/login': (context) => Login(),
                '/signup': (context) => Register(),
                '/profile':(context) => Profile(),
                '/change_profile':(context) => ChangeProfile(),
                '/self_following':(context) => SelfFollowing(),
                '/self_followers':(context) => SelfFollowers(),
                '/home':(context) => Home(),
                '/message_':(context) => MessageSettings(),
                '/single_message':(context) => SingleMessage(),
                '/posting' : (context) => Add(),
                '/select_msg': (context) => MsgCandidate()
              });
        }else if (appCap.hasData && appCap.data[0]==false) {
          print("AppCap"+appCap.data[1].toString());
          return MaterialApp(
            navigatorObservers: [observer],
              initialRoute: appCap.data[1]==true?"/home":"/welcome" ,
              routes: {
                '/welcome': (context) => Welcome(),
                '/profile': (context) => Profile(),
              '/login': (context) => Login(),
              '/signup': (context) => Register(),
              '/change_profile': (context) => ChangeProfile(),
              '/self_following': (context) => SelfFollowing(),
              '/self_followers': (context) => SelfFollowers(),
              '/home': (context) => Home(),
              '/message_': (context) => MessageSettings(),
              '/single_message': (context) => SingleMessage(),
                '/posting' : (context) => Add(),
                '/select_msg': (context) => MsgCandidate()
              });
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}

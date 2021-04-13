import 'package:banana/routes/change_profile.dart';
import 'package:flutter/material.dart';
import 'package:banana/routes/welcome.dart';
import 'package:banana/routes/login.dart';
import 'package:banana/routes/signup.dart';
import 'package:banana/routes/walkthrough.dart';
import 'package:banana/routes/profile.dart';
import 'package:banana/routes/change_profile.dart';
import 'package:banana/routes/self_following.dart';
import 'package:banana/routes/self_followers.dart';
import 'package:banana/routes/home.dart';

void main() => runApp(MaterialApp(
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
    '/home':(context) => Home()

  },
));

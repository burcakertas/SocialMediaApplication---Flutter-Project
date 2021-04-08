import 'package:flutter/material.dart';
import 'package:banana/routes/welcome.dart';
import 'package:banana/routes/login.dart';
import 'package:banana/routes/signup.dart';
import 'package:banana/routes/walkthrough.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',

  routes: {
    '/':(context) =>TestScreen(),
    '/welcome':(context) =>Welcome(),
    '/login': (context) => Login(),
    '/signup': (context) => Register(),
  },
));

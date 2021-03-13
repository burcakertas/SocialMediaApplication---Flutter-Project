import 'package:flutter/material.dart';
import 'package:cs_310_soc_med_app/app/sign_in/sign_in_page.dart';

//main method of my app (every flutter app always requires a main method)
void main(){
  runApp(MyApp()); //Myapp() --> root widget
}

//class of my root widget
class MyApp  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FakeGram',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SignInPage() //home page as a sign in page çünkü ilk o çıkıcak
    );
  }
}


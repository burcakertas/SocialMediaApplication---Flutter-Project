import 'package:flutter/material.dart';
import '../../common_widgets/custom_raised_button.dart';
import 'button_with_text.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
        title: Center(child: Text('(: :)')),
        elevation: 10, //shadow that you can see under the appbar
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      //I GUESS child is a property of the widget container.
      // Children is a property of the widget column.
      // Children needs to be a list of widgets
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,

            ),
          ),
          SizedBox(height: 48),

          CustomRaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('images/google-logo.png'),
                Text('Sign in with Google',

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Opacity(
                    opacity: 0,
                    child: Image.asset('images/google-logo.png')
                ),
              ],
            ),
            color: Colors.white,
            onPressed: (){},
          ),

          SizedBox(height: 15),
          CustomRaisedButton(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('images/facebook-logo.png'),
                Text(
                  'Sign in with Facebook',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Opacity(
                  opacity: 0,
                    child: Image.asset('images/facebook-logo.png')
                ),
              ],
            ),
            color: Color(0xFF334D92), //facebook rengiymiş bu
            onPressed: (){},
          ),
          SizedBox(height: 15),
          ButtonWithText(
            /*child: Text(
              'Sign in',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),*/
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[600],
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}



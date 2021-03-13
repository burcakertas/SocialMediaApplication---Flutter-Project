import 'package:flutter/material.dart';
import 'package:cs_310_soc_med_app/common_widgets/custom_raised_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
        title: Center(child: Text('FakeGram')),
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
          SizedBox(height: 8),
          CustomRaisedButton(
            child: Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
            borderRadius: 4,
            onPressed: (){},
          ),
          CustomRaisedButton(
            child: Text(
              'Sign in with Facebook',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
            borderRadius: 4,
            onPressed: (){},
          ),
          CustomRaisedButton(
            child: Text(
              'Sign in',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            color: Colors.white,
            borderRadius: 4,
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}


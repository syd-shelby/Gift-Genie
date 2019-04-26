import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state_widget.dart';

class GoogleLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GoogleLoginPageState();
}

class GoogleLoginPageState extends State<GoogleLoginPage> {

  StateWidget _appUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //decoration: _buildBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildText(),
              SizedBox(height: 50.0),
              GoogleSignInButton(
                // Passing function callback as constructor argument:
                onPressed: () => StateWidget.of(context).signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {

  GoogleSignInButton({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {

    /*
    Image _buildLogo() {
      return Image.asset(
        "assets/g-logo.png",
        height: 18.0,
        width: 18.0,
      );
    }
    */

    Opacity _buildText() {
      return Opacity(
        opacity: 0.54,
        child: Text(
          "Sign in with Google",
          style: TextStyle(
            fontFamily: 'Roboto-Medium',
            color: Colors.black,
          ),
        ),
      );
    }

    return MaterialButton(
      height: 40.0,
      onPressed: this.onPressed,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //_buildLogo(),
          SizedBox(width: 24.0),
          _buildText(),
        ],
      ),
    );
  }
}
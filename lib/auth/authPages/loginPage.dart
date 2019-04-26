import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:gift_genie/bottomNavigation.dart';
import 'package:gift_genie/auth/authPages/registerPage.dart';
import 'package:gift_genie/auth/state_widget.dart';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  bool _isObscure = true;
  Color _eyeColor;
  List _loginMethod = [
    {
      "title": "google",
      "icon": MdiIcons.google,
      "page": "googleLogin",
      "id": 0,
    },
    {
      "title": "twitter",
      "icon": MdiIcons.twitter,
      "page": "twitterLogin",
      "id": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildOtherLoginText(),
                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )),
    );
  }

  //Registration Info, at bottom
  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Doesn't have a account？"),
            GestureDetector(
              child: Text(
                'Register here',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //TODO Go to register page
                Navigator.of(context).pushNamed("/Registration");
                //print('Go to register');
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Other ways to login, Facebook, Google or Twitter
  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
        builder: (context) {
          return IconButton(
              icon: Icon(item['icon'],
              color: Theme.of(context).iconTheme.color),
              onPressed: () async {
                //if (_formKey.currentState.validate()) {
                  ///only valid
                  //_formKey.currentState.save();

                  //google
                  if(item['icon'] == MdiIcons.google) {
                    await StateWidget.of(context).signInWithGoogle();
                  }
                  //twitter
                  if(item['icon'] == MdiIcons.twitter) {
                    await StateWidget.of(context).signInWithTwitter();
                  }
                  
                  //await StateWidget.of(context).signInWithGoogle();
                  if (StateWidget.of(context).state.isSignedIn == true) {
                    Navigator.of(context).pushNamed("/HomePage");
                  }
                  else {
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("${item['title']}Login Failed..."),
                    ));
                  //}
                }
              }
                /*
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("${item['title']}Login"),
                  action: new SnackBarAction(
                    label: "Cancel",
                    onPressed: () {},
                  ),
                ));
                */
              );
        },
      )
      )
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          'Use other accounts to login',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  //Login Button
  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blueGrey,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ///only valid
              _formKey.currentState.save();

              await StateWidget.of(context).signInWithEmail(_email, _password);
              if(StateWidget.of(context).state.isSignedIn == true) {
                Navigator.of(context).pushNamed("/HomePage");
              }
              else {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Login Failed..."),
                ));
              }

              //Test:
              //Navigator.of(context).pushNamed("HomePage");
              //print('email:$_email , password:$_password');
            }

          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //Forget Password, go to recover page
  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            'Forgot your password？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("/RecoverPasswd");
            //Navigator.pop(context);
          },
        ),
      ),
    );
  }

  //Password and Email Field
  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter your password!';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Emall Address',
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(value)) {
          return 'Invalid E-mail address!';
        }
      },
      onSaved: (String value) => _email = value,
    );
  }

  //Title
  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
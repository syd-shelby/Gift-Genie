import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  String _userName, _email, _password1, _password2;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              SizedBox(
                height: kToolbarHeight,
              ),
              //buildTitle(),
              //buildTitleLine(),
              SizedBox(height: 70.0),
              buildUsernameField(),
              SizedBox(height: 20.0),
              buildEmailField(),
              SizedBox(height: 20.0),
              buildPassword1Field(context),
              SizedBox(height: 20.0),
              buildPassword2Field(context),
              SizedBox(height: 30.0),
              //buildAgreement(),
              SizedBox(height: 15.0),
              buildRegisterButton(),
            ],
          )),
    );
  }

  //Title
  Padding buildTitle() {}

  //Username
  Row buildUsernameField() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            child:
            Padding(
                padding: EdgeInsets.only(top: 20, right: 8, bottom: 2),
                child:
                Text(
                  "Username:",
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                )
            )
        ),
        new Expanded(
            child:
            TextFormField(
              onSaved: (String value) => _userName = value,
              validator: (String value) {
                //TODO check duplicate name
              },
            ),
          flex: 3,
        ),
      ],
    );
  }

  //E-mail
  Row buildEmailField() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            child:
            Padding(
                padding: EdgeInsets.only(top: 20, right: 8, bottom: 2),
                child:
                Text(
                  "E-mail:",
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                )
            )
        ),
        new Expanded(
          child:
          TextFormField(
            onSaved: (String value) => _email = value,
            validator: (String value) {
              var emailReg = RegExp(
                  r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
              if (!emailReg.hasMatch(value)) {
                return 'Invalid E-mail address!';
              }
            },
          ),
          flex: 3,
        ),
      ],
    );
  }

  //Password
  Row buildPassword1Field(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            child:
            Padding(
                padding: EdgeInsets.only(top: 20, right: 8, bottom: 2),
                child:
                Text(
                  "Password:",
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                )
            )
        ),
        new Expanded(
          child:
          TextFormField(
            onSaved: (String value) => _password1 = value,
            obscureText: _isObscure,
            validator: (String value) {
              //TODO check length/special charactors
              if (value.isEmpty) {
              return 'Please enter your password!';
              }
            },
            decoration: InputDecoration (
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
                    }))
          ),
          flex: 3,
        ),
      ],
    );
  }

  //Re-enter password
  Row buildPassword2Field(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Expanded(
            child:
            Padding(
                padding: EdgeInsets.only(top: 20, right: 8, bottom: 2),
                child:
                Text(
                  "Re-type Password:",
                  textAlign: TextAlign.right,
                  style: new TextStyle(
                    fontSize: 16,
                  ),
                )
            )
        ),
        new Expanded(
          child:
          TextFormField(
            onSaved: (String value) => _password2 = value,
            obscureText: _isObscure,
            validator: (String value) {
              //TODO check length/special charactors
              if(_password1 != _password2) {
                return "Password doesn't match!";
              }
            },
            decoration: InputDecoration (
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
                  }))
          ),
          flex: 3,
        ),
      ],
    );
  }

  //Check Agreement
  Align buildAgreement() {}

  //Button
  Align buildRegisterButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 200.0,
        child: RaisedButton(
          child: Text(
            'Register',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blueGrey,
          onPressed: () async {
            //Navigator.of(context).pushNamed("HomePage");
            //TODO: Display: Code sent

            if (_formKey.currentState.validate()) {
              ///only valid
              _formKey.currentState.save();
              await StateWidget.of(context).signUpWithEmail(_email, _password1);

              Navigator.of(context).pushNamed("/LoginPage");
              /*if (StateWidget.of(context).state.isSignedIn == true) {
                Navigator.of(context).pushNamed("/HomePage");
              }
              else {
                Scaffold.of(context).showSnackBar(new SnackBar(
                  content: new Text("Sign up and Login Failed..."),
                ));

                //Test:
                //Navigator.of(context).pushNamed("HomePage");
                //print('email:$_email , password:$_password');
              }*/
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

}
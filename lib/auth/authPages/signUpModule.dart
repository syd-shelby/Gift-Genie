import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/utils/theme.dart' as theme;


class SignUpModule extends StatefulWidget {
  @override
  _SignUpModuleState createState() => new _SignUpModuleState();
}

class _SignUpModuleState extends State<SignUpModule> {

  final _formKey = GlobalKey<FormState>();
  String _userName, _email, _password1, _password2;
  //final reference = FirebaseDatabase.instance.reference().child('Users');

  final db = Firestore.instance.collection('Users');
  final dbUE = Firestore.instance.collection("UserEmails");
  //final dbH = Firestore.instance.collection('UserHash');

  //final CollectionReference UserHashes;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 20),
        child: new Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  color: Colors.white,),
                width: 300,
                height: 330,
                child: buildSignUpTextForm()
            ),

            new Positioned(child: new Center(child:
            buildSignUpButton(),), top: 320,)

          ],
        )
    );
  }

  Widget buildSignUpTextForm() {
    return new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //用户名字
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  onSaved: (String value) => _userName = value,
                  decoration: new InputDecoration(
                      icon: new Icon(
                        FontAwesomeIcons.user, color: Colors.black,),
                      hintText: "Name",
                      border: InputBorder.none
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            //邮箱
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  validator: (String value) {
                    var emailReg = RegExp(
                        r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
                    if (!emailReg.hasMatch(value)) {
                      return 'Invalid E-mail address!';
                    }
                  },
                  onSaved: (String value) => _email = value,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.email, color: Colors.black,),
                      hintText: "Email Address",
                      border: InputBorder.none
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            //密码
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  onSaved: (String value) => _password1 = value,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Password'length must longer than 6!";
                    }
                  },
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.lock, color: Colors.black,),
                    hintText: "Password",
                    border: InputBorder.none,
                    suffixIcon: new IconButton(
                        icon: new Icon(
                          Icons.remove_red_eye, color: Colors.black,),
                        onPressed: () {}),
                  ),
                  obscureText: true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20),
                child: new TextFormField(
                  onSaved: (String value) => _password2 = value,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.lock, color: Colors.black,),
                    hintText: "Confirm Passowrd",
                    border: InputBorder.none,
                    suffixIcon: new IconButton(
                        icon: new Icon(
                          Icons.remove_red_eye, color: Colors.black,),
                        onPressed: () {}),
                  ),
                  validator: (value) {
                    //TODO check length/special charactors
                    if (_password1 != _password2) {
                      return "Password doesn't match!";
                    }
                  },
                  obscureText: true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

          ],
        ));
  }

  Widget buildSignUpButton() {
    return
      new GestureDetector(
        child: new Container(
          padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: theme.Theme.primaryGradient,
          ),
          child: new Text(
            "SIGN UP",
            style: new TextStyle(fontSize: 25, color: Colors.white),),
        ),
        onTap: () async {
          /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
          if (_formKey.currentState.validate()) {
            ///only valid
            _formKey.currentState.save();
            try {
              await StateWidget.of(context).signUpWithEmail(_email, _password1);
              String hashSource = _userName + _email;
              int index = hashSource.hashCode;
              _userLogUp(_userName, _password1, _email, index.toString());
              Navigator.of(context).pushNamed("/LoginPage");
            }
            catch (e) {
              _showDialog();
            }
            /*
            String hashSource = _userName + _email;
            int index = hashSource.hashCode;
            int result = _userLogUp(_userName, _password1, _email, index.toString());
            */
          }
//          debugDumpApp();
        },

      );
  }

  void _userLogUp(String username, String password, String email, String index,
      {String phone, String location, String bday,
        List friends, List outGifts, List inGifts, List favorites, List recommended}) {

    try {
      dbUE.document(email).setData({
        'userIndex':index
      });
      db.document(index).setData({
        'name': username,
        'password': password,
        'email': email,
        'phone': phone,
        'location': location,
        'bday': bday,
        'friends': friends,
        'outGifts': outGifts,
        'inGifts': inGifts,
        'favorites': friends,
        'recommended': recommended,
        'useIndex': index,
      });
    } catch (e) {
        _showDialog();
    }
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Registration Error"),
          content: new Text("Email address already exists!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
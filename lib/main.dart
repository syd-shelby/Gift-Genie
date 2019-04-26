import 'package:flutter/material.dart';
import 'package:gift_genie/auth/authPages/loginPage.dart';
import 'package:gift_genie/auth/authPages/recoverPasswdPage.dart';
import 'package:gift_genie/auth/authPages/registerPage.dart';
import 'bottomNavigation.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/googleLogin.dart';
import 'package:gift_genie/loadingPage.dart';
import 'package:gift_genie/contacts/searchAndAddPage.dart';

//tells main to run MyApp class
void main() => runApp(new StateWidget(
  child: new MyApp(),
));

//the my app class
class MyApp extends StatelessWidget {
  @override
  //everything in flutter comes from a widget
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Gift Genie', //im unclear of what this is. page title?
      //home: LoadingPage(),
      home: LoadingPage(),
      routes: <String, WidgetBuilder> {
        //"/": (context) => BottomNavigationWidget(),
        "/LoginPage":(_) => LoginPage(),
        "/HomePage":(_) => BottomNavigationWidget(),
        "/Registration":(_) => RegisterPage(),
        "/RecoverPasswd":(_) => RecoverPage(),
        "/GoogleLogin":(_) => GoogleLoginPage(),
        "/SearchAdd" :(_) => SearchAndAddPage(),
        /*
        "facebookLogin":(_) => GoogleLoginPage(),
        "twitterLogin":(_) => GoogleLoginPage(),
        */
      },
    );
  }
}

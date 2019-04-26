import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:flutter/widgets.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {

  StateModel _appUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoadingIndicator(),
    );
  }

  @override
  void initState() {
    super.initState();
    countDown();

  }

  void countDown() {
    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration, _buildPage);
  }

  void _buildPage() {

    _appUser = StateWidget.of(context).state;

    if(_appUser.user != null && _appUser.isSignedIn == true){
      Navigator.of(context).pushReplacementNamed("/HomePage");
    }
    else {
      Navigator.of(context).pushReplacementNamed("/LoginPage");
    }
  }

  //Loading sign/or replace it with picture
  Container _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: Center(
        child: new CircularProgressIndicator(),
      )
    );
  }

}
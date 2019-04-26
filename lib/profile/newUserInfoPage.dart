import 'package:flutter/material.dart';

class NewUserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewUserInfoPageState();
}

class NewUserInfoPageState extends State<NewUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Information'),
      ),
    );
  }
}
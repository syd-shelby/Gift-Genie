import 'package:flutter/material.dart';

class RecoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecoverPageState();
}

class RecoverPageState extends State<RecoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recover Your Password'),
      ),
    );
  }
}
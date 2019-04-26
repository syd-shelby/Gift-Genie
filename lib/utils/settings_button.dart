
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  //final String caption;
  final Function onPressed;

  SettingsButton(this.icon, this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: const Color(0xFF807a6b),
      padding: EdgeInsets.all(14.0),
      onPressed: this.onPressed,
      child: Row(
        children: <Widget>[
          Icon(this.icon),
          SizedBox(width: 10.0),
          Text(this.title),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/contacts/reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendDetailFooter extends StatelessWidget {
  FriendDetailFooter(this.friend);
  final Friend friend;
  StateModel _appState;

  /*
  Widget _buildLocationInfo(TextTheme textTheme) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            friend.location==null?"-":friend.locat,
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    _appState = StateWidget.of(context).state;

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new RaisedButton(onPressed: (){
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return _buildButton(context, friend.name , friend.userInex);
            },
          ).then((val) {
            print(val);
          });
        })
        /*
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting '
                'industry. Lorem Ipsum has been the industry\'s standard dummy '
                'text ever since the 1500s.',
            style:
            textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, theme.accentColor),
              _createCircleBadge(Icons.cloud, Colors.white12),
              _createCircleBadge(Icons.shop, Colors.white12),
            ],
          ),
        ),
        */
      ],
    );
  }

  Widget _buildButton(BuildContext context, name, index) {
    return new AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('Are U sure to delete'),
            new Text(name + "?"),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: (){
              _delete(index);
              Navigator.of(context).pop();
            //else return;
          },
          child: new Text('Delete'),),
        new FlatButton(
          child: new Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _delete(userIndex) {

    updateInvitations(userIndex, _appState.user.uid, 1);

  }

}
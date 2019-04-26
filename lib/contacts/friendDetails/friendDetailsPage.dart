import 'package:flutter/material.dart';
//import 'package:flutter_mates/ui/frienddetails/footer/friend_detail_footer.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsBody.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsPageHeader.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/contacts/reply.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:meta/meta.dart';

class FriendDetailsPage extends StatefulWidget {
  FriendDetailsPage(
      this.friend, {
        @required this.avatarTag,
      });

  final Friend friend;
  final Object avatarTag;

  @override
  _FriendDetailsPageState createState() => new _FriendDetailsPageState();
}

class _FriendDetailsPageState extends State<FriendDetailsPage> {

  StateModel _appState;

  @override
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;

    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFFd3ddea),
          const Color(0xFFa3ddea),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FriendDetailHeader(
                widget.friend,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new FriendDetailBody(widget.friend),
              ),
              new Container(
                alignment: Alignment.center,
                child: new Padding(
                    padding: EdgeInsets.all(4.0),
                    child: new RaisedButton(
                      child: new Text("Delete"),
                      onPressed: (){
                      showDialog<Null>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildButton(widget.friend.name , widget.friend.userInex);
                        },
                      ).then((val) {
                        print(val);
                      });
                    },
                ),
              ),
              )//new FriendShowcase(widget.friend),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(name, index) {
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsPage.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  StateModel _appState;
  User _user;
  final db = Firestore.instance.collection("Users");
  
  List<String> _friendIndexes = [];
  List<Friend> _friends = [];

  @override
  void initState() {
    super.initState();
    //_loadFriends();
  }

  Future<void> getFriendIndexes() async{

    db.document(_user.userIndex)
        .get()
        .then((DocumentSnapshot ds) {
      _friendIndexes = ds["friends"];
    });

  }
  
  Future<void> _loadFriends() async {
    _friendIndexes = ["236893061", "1064167805", "911341877"];
    if(_friendIndexes.length == 0) return;

    String avatarUrl;
    String name;
    String email;

    _friendIndexes.forEach((index) {
      db.document(index)
          .get()
          .then((DocumentSnapshot ds) {
        avatarUrl = ds["avatar"];
        name = ds["name"];
        email = ds["email"];
        _friends.add(new Friend(avatarUrl: avatarUrl, name: name, email: email));
      });
    });

    setState(() {
    });
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatarDownloadUrl),
        ),
      ),
      title: new Text(friend.name),
      subtitle: new Text(friend.email),
    );
  }

  void _navigateToFriendDetails(Friend friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  Future<void> _loadFRZ() async {
    await getFriendIndexes();
    await _loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    _appState = StateWidget.of(context).state;
    _user = _appState.uuser;
    _loadFRZ();

    Widget content;

    if (_friends.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      /*
      content = new ListView.builder(
        itemCount: _friends.length,
        itemBuilder: _buildFriendListTile,
      );
      */
      content = new StreamBuilder<QuerySnapshot>(
          stream: db.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData) return Text('Loading...');
            return ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (BuildContext context, int index){
                _buildFriendListTile(context, index);
              },
            );
          });
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text('Friends')),
      body: content,
    );
  }
}
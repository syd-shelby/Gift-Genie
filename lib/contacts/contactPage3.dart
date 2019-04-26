import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:gift_genie/contacts/friendDetails/friendDetailsPage.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/contacts/searchAndAddPage.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';

class ContactPage extends StatefulWidget {

  ContactPage({Key key, @required this.user})
      : super(key: key);

  final User user;

  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Widget appBarTitle = new Text(
    "My Friends",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = "";
  List<Friend> _searchresult = new List<Friend>();

  ContactPageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  ////////////////
  List<Friend> _friends = [
    new Friend(avatarUrl: "", name: "ds679", email: "dereksun679@gmail.com"),
    new Friend(avatarUrl: "", name: "dspub", email: "dereksunpublic@gmail.com"),
    new Friend(avatarUrl: "", name: "ds9477", email: "947797957@qq.com"),
  ];
  List<String> _friendIndexes = ["718958539","236893061"];
  //List<String> _friendIndexes = [];
  final db = Firestore.instance.collection("Users");
  //String uIdx;
  User _user;
  
 
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    //_user = widget.user;
    //uIdx = _user.userIndex;
    //uIdx = "718958539";
    //_getFriendIndexes();
    //_loadFriends();
  }

/*
  Future<void> _getFriendIndexes() async{

    List<String> _fi = [];
    await db.document("718958539")
        .get()
        .then((DocumentSnapshot ds) {
          /*
      var list = ds["friends"];
      for(var i = 0; i < list.length; i++) {
        _fi.add(list[i]);
      }
      */
          _fi = ds["friends"];
    });

    setState(() {
      _friendIndexes = _fi;
    });

  }
  
  Future<void> _loadFriends() async {
    List<Friend> _fd = [];
    for(var i = 0; i<_friendIndexes.length; i++) {
      await db.document(_friendIndexes[i])
          .get()
          .then((DocumentSnapshot ds) {
            String name = ds["name"];
            String email = ds["email"];
            String avatar = ds["avatar"];
            _fd.add(new Friend(avatarUrl: avatar, name: name, email: email));
      });
    }

    setState(() {
      _friends = _fd;
    });
  }
  */

  Widget _buildFriendListTile(BuildContext context, int index, int mode) {
    var friend;
    if(mode == 0) friend = _searchresult[index];
    else friend = _friends[index];

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

  @override
  Widget build(BuildContext context) {

    /*
    return new Scaffold(
      appBar: new AppBar(title: new Text('Friends')),
      body: buildFriendListView(),
    );
    */

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          key: globalKey,
          appBar: buildSearchBar(context),
          body: new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Flexible(
                    child: _searchresult.length != 0 || _controller.text.isNotEmpty
                        ? new ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchresult.length,
                      itemBuilder: (BuildContext context, int index) {
                        //String listData = searchresult[index];
                        return _buildFriendListTile(context, index, 0);
                      },
                    )
                        : new ListView.builder(
                      shrinkWrap: true,
                      itemCount: _friends.length == null?0:_friends.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Friend listData = _friends[index];
                        return _buildFriendListTile(context, index, 1);
                      },
                    ))
              ],
            ),
          ),
          floatingActionButton: new FloatingActionButton(
              onPressed: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchAndAddPage()));},
              tooltip: 'Go to Adding Page',
              child: new Icon(Icons.add)
          )
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged:(value) { searchOperation(value);},
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "My Friends",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    setState(() {
      _searchresult.clear();

      if (_isSearching != null) {
        for (int i = 0; i < _friends.length; i++) {
          Friend data = _friends[i];
          if (data.name.toLowerCase().contains(searchText.toLowerCase())) {
            _searchresult.add(data);
          }
        }
      }
    });
    //searchresult.clear();
  }

  _addNewUsers() {

    setState(() {

    });
  }
}

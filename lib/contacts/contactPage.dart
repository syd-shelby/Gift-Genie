import 'package:flutter/material.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsPage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {

  StateModel _appState;
  User _user;
  final db = Firestore.instance.collection("Users");

  //////For the Main Page/////
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
  List<String> _friendIndexes = new List<String>();
  List<Friend> _friends = new List<Friend>();
  bool _isSearching;
  String _searchText = "";
  List<Friend> _searchresult = new List<Friend>();

  ///////For the Adding Page/////
  final addPageGlobalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _addPageController = new TextEditingController();
  List<dynamic> _addPageList;
  //bool _isSearching;
  //String _searchText = "";
  List _addPageSearchResult = new List();

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

  @override
  void initState() {
    super.initState();
    _isSearching = false;
  }

  Future<void> getFriendIndexes() async{

    db.document(_user.userIndex)
        .get()
        .then((DocumentSnapshot ds) {
          _friendIndexes = ds["friends"];
    });

  }

  Future<void> getFriends() async {

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

  }

  @override
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;
    _user = _appState.uuser;
    getFriendIndexes();
    getFriends();


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
              onPressed: _addNewUsers(),
              tooltip: 'Add Item',
              child: new Icon(Icons.add)
          )
      ),
    );
  }

  Widget _buildFriendListTile(BuildContext context, int index, int mode) {

    var friend;
    if(mode == 0) friend = _searchresult[index];
    else if(mode == 1) friend = _friends[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatar),
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

    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                key: addPageGlobalKey,
                appBar: buildSearchBar(context),
                body: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Flexible(
                          child: _searchresult.length != 0 || _addPageController.text.isNotEmpty
                              ? new ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchresult.length,
                            itemBuilder: (BuildContext context, int index) {
                              //Friend listData = searchresult[index];
                              return _buildFriendListTile(context, index, 0);
                            },
                          )
                              : new ListView.builder(
                            shrinkWrap: true,
                            itemCount: _addPageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              //String listData = _addList[index];
                              return _buildFriendListTile(context, index, 1);
                            },
                          ))
                    ],
                  ),
                ),
              );
            }
        )
    );
  }

/*
  Widget buildSearchBar(BuildContext context) {
    return  new Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }

  void filterSearchResults(String query) {
    
    List<String> searchList = List<String>();
    searchList.addAll(duplicateItems);
    
    if(query.isNotEmpty) {
      List<String> searchListData = List<String>();
      searchList.forEach((item) {
        if(item.contains(query)) {
          searchListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(searchListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
  */
}

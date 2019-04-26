import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsPage.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/contacts/searchAndAddPage.dart';
import 'package:gift_genie/contacts/reply.dart';
import 'package:gift_genie/contacts/send.dart';



class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  //@override
  StateModel appState;
  List<Friend> _friends = [];
  List<Friend> _notif = [];
  final db = Firestore.instance.collection("Users");


  DefaultTabController _buildTabView({Widget body}) {
    const double _iconSize = 20.0;

    //appState = StateWidget.of(context).state;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            //title: Text('Gift List'),
            //title: new Text('Tabs Demo'),
            elevation: 2.0,
            bottom: TabBar(
              labelColor:  Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.contacts, size: _iconSize)),
                Tab(icon: Icon(Icons.notifications_active, size: _iconSize))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
          floatingActionButton: new FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAndAddPage()));},
              tooltip: 'Go to Adding Page',
              child: new Icon(Icons.add)
          )
      ),
    );
  }

  Widget _buildContent() {
    if (appState.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      Navigator.of(context).pushNamed("/HomePage");
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  Future<void> getFriends() async {

    List<dynamic> ls = [];
    List<Friend> tempList = [];

    await db.document(appState.user.uid).get().then((DocumentSnapshot ds){
      ls = ds["friends"];
    });

    for(var i = 0; i < ls.length; i++) {
      await db.document(ls[i]).get().then((DocumentSnapshot ds) {
        String ava = ds["avatar"];
        String name = ds["name"];
        String email = ds["email"];
        Friend temp = new Friend(avatarUrl: ava, name: name, email: email);
        temp.userInex = ds["userIndex"];
        tempList.add(temp);
      } );
    }

    setState(() {
      _friends = tempList;
    });

  }

  Future<void> getInvitations() async {

    List<dynamic> ls = [];
    List<Friend> temp = [];

    await db.document(appState.user.uid).get().then((DocumentSnapshot ds){
      ls = ds["invitations"];
    });

    for(var i = 0; i < ls.length; i++) {
      await db.document(ls[i]).get().then((DocumentSnapshot ds) {
        String ava = ds["avatar"];
        String name = ds["name"];
        String email = ds["email"];
        String id = ds["userIndex"];
        Friend tp = new Friend(avatarUrl: ava, name: name, email: email);
        tp.userInex = id;
        temp.add(tp);
      } );
    }

    setState(() {
      _notif = temp;
    });

  }

  TabBarView _buildTabsContent() {
    Padding _buildUserList({int type, List<String> ids}) {

      // Define query depending on passed args
      return Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child:  type == 0? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: _friends.length == null?0:_friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      //Friend listData = _friends[index];
                      return _buildFriendListTile(context, index);
                    },
                  ): new ListView.builder(
                shrinkWrap: true,
                itemCount: _notif.length == null?0:_notif.length,
                itemBuilder: (BuildContext context, int index) {
                  //Friend listData = _friends[index];
                  return _buildNotifListTile(context, index);
                },
              ),
            ),
          ],
        ),
      );
    }

      return TabBarView (
      children: [
        _buildUserList(type: 0),
        _buildUserList(type: 1),
        //Center(child: Icon(Icons.favorite)),
      ],
    );
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

  Widget _buildNotifListTile(BuildContext context, int index) {

    var friend = _notif[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatarDownloadUrl),
        ),
      ),
      title: new Text(friend.name + "wants to add you!"),
      subtitle: new Text(friend.email),
      trailing: new RaisedButton(
          child: new Text("Reply"),
          onPressed: (){
            showDialog<Null>(
              context: context,
              builder: (BuildContext context) {
                return _buildButton(friend.name, friend.userInex);
              },
            ).then((val) {
              print(val);
            });
          })
    );
  }

  Widget _buildButton(name, id) {
    return new AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text("Reply to"),
            new Text(name),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: (){
            _acceptReq(id);
            Navigator.of(context).pop();
            //else return;
          },
          child: new Text('Accept'),),
        new FlatButton(
          child: new Text('Decline'),
          onPressed: () {
            _declineReq(id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _acceptReq(userIndex) {

    sendInvitations(userIndex, appState.user.uid, 1);
    updateInvitations(userIndex, appState.user.uid, 0);

  }

  void _declineReq(userIndex) {

    updateInvitations(userIndex, appState.user.uid, 0);

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

  /*
  void _handleFavoritesListChanged(String productID) {
    updateFavorites(appState.user.uid, productID).then((result) {
      // Update the state:
      if (result == true) {
        setState(() {
          if (!appState.favorites.contains(productID))
            appState.favorites.add(productID);
          else
            appState.favorites.remove(productID);
        });
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    getFriends();
    getInvitations();
    return _buildContent();
  }
}
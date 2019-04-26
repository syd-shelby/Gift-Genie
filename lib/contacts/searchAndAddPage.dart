import 'package:flutter/material.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/contacts/friendDetails/friendDetailsPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:gift_genie/contacts/send.dart';



class SearchAndAddPage extends StatefulWidget {

  @override
  SeachAndAddPageState createState() => new SeachAndAddPageState();
}

class SeachAndAddPageState extends State<SearchAndAddPage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  StateModel _appState;
  String target;
  String myId;
  String _searchText = "";

  final dbUE = Firestore.instance.collection("UserEmails");
  final db = Firestore.instance.collection("Users");

  SeachAndAddPageState() {
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
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;

    const textStyle = const TextStyle(
        fontSize: 35.0,
        fontFamily: 'Butler',
        fontWeight: FontWeight.w400
    );
    return new Scaffold(
      key: scaffoldKey,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            forceElevated: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: new IconThemeData(color: Colors.black),
          ),
          new SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(height: 8.0,),
                  new Text("Search for Friends", style: textStyle,),
                  new SizedBox(height: 16.0),
                  new Card(
                      elevation: 4.0,
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextField(
                          controller: _controller,
                          decoration: new InputDecoration(
                              hintText: "Search by Emails",
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Icon(Icons.search),
                              ),
                              border: InputBorder.none
                          ),
                          onChanged: (string) {
                            setState(() {
                              _searchText = string;
                            });
                          },
                        ),
                      )
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child:Padding(padding: EdgeInsets.all(26.0),
                      child: new RaisedButton(
                        child: new Text("Search"),
                        onPressed:() {
                          getUser();
                          showDialog<Null>(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildButton();
                            },
                          ).then((val) {
                            print(val);
                          });
                        }
                      ),
                  ),),
                  new SizedBox(height: 10.0,),
                ],
              ),
            ),
          ),
          /*
          isLoading? new SliverToBoxAdapter(child: new Center(child: new CircularProgressIndicator()),): new SliverToBoxAdapter(),
          new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index){
            return new BookCardCompact(items[index], onClick: (){
              Navigator.of(context).push(
                  new FadeRoute(
                    builder: (BuildContext context) => new BookDetailsPageFormal(items[index]),
                    settings: new RouteSettings(name: '/book_detais_formal', isInitialRoute: false),
                  ));
            },);
          },
              childCount: items.length)
          )
          */
        ],
      ),
    );
  }

  Widget _buildButton() {
    return new AlertDialog(
      //title: new Text('标题'),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text('User:'),
            new Text(_searchText),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: (){
              if(target != "NOT FOUND") {
                _sendInvitation();
                Navigator.of(context).pop();
              }
              //else return;
            },
            child: new Text('Add'),),
        new FlatButton(
          child: new Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> getUser() async {

    String userIndex;

    if(!(_searchText == null)) {
      await dbUE.document(_searchText).get().then((DocumentSnapshot ds){
        userIndex = ds["userIndex"];
      });

      if(userIndex!=null){
        setState(() {
          target = userIndex;
        });
      }
      else {
        setState(() {
          target = "NOT FOUND";
        });
      }
    }
    else return;
  }

  void _sendInvitation() {

    sendInvitations(_appState.user.uid, target, 0).then((result){
      if(result) {
        print("DONE!");
      }
    });
    
  }
}
import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/list/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/list/product.dart';
import 'package:gift_genie/list/product_card.dart';
import 'package:gift_genie/list/listPage.dart';
import 'dart:io';

class QuizPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final _picked = <String>[];
  final _options = <String>["Men's Clothing", "Women's Clothing", "Jewelry", "Games", "Electronics", "Home", "Movies", "Sports & Outdoors", "Video Games", "Books"];
  var _list;
  StateModel appState;

  @override
  Widget build(BuildContext context) {
    _list = _buildList();
    print("build");

    appState = StateWidget.of(context).state;
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text("Quiz"),
            ),
            body: Center(
              child: new ListView(
                  children: <Widget>[
                    _list[0],
                    _list[1],
                    _list[2],
                    _list[3],
                    _list[4],
                    _list[5],
                    _list[6],
                    _list[7],
                    _list[8],
                    _list[9],
                    new FlatButton.icon(
                      color: Colors.cyanAccent,
                      icon: new Icon(Icons.cached),
                      label: Text('SUBMIT'), //`Text` to display
                      onPressed: () {
                        _handlePressed(_picked);
                      },
                    ),

                  ]),
            )
        )
    );
  }
  List<ListTile> _buildList()
  {
    print("_buildList");
    List L = <ListTile>[];
    ListTile ll;
    int i;
    for(i = 0; i < _options.length; i++)
    {
      ll = _buildOption(_options[i]);
      L.add(ll);
    }
    return L;
  }

  void _handlePressed(List<String> l)
  {
    int i;
    Future<List<Object>> docs;
    List<Object> d;
    CollectionReference collectionReference = Firestore.instance.collection('Products');
    Stream<QuerySnapshot> stream;
    stream = collectionReference.snapshots();
    AsyncSnapshot<QuerySnapshot> snapshot;
    //   print("THREAD A");
    // appState.isLoading = true;
    stream.forEach(_process);
    //print("THREAD B");

  }
  String update_category(String cat) {
    if(cat == "Men's Clothing") {
      cat = "Men";
    }
    if(cat == "Women's Clothing") {
      cat = "Women";
    }
    if(cat == "Jewelry") {
      cat = "> Jewelry >";
    }
    return cat;
  }

  void _process(Object element)
  {
    print("_process");
    QuerySnapshot qs;
    List<DocumentSnapshot> ds;
    int i;
    String id;
    int j;
    Map<String, dynamic> m;
    String s;
    qs = element;
    ds = qs.documents;
    var rec_asins = <String>[];
    for(i = 0; i < ds.length;i++) {
      if (ds[i].exists) {
        m = ds[i].data;
        id = ds[i].documentID;
        s = m['Categories'];
        //print(m['Name']);
        for (j = 0; j < _picked.length; j++) {
          if (s.contains(update_category(_picked[j]))) {
            //print(_picked);
            if(id.isNotEmpty) {
              rec_asins.add(id);
              //_handleRecommendedListChanged(id);
            }
          }
        }
      }
    }
    _handleRecommendedListChanged(rec_asins);
  }
  void _handleRecommendedListChanged(List<String> ids) {
    print("_handleRecommendedListChanged");
    for(int i = 0; i<ids.length; i++) {
      String productID = ids[i];
      updateRecommended(appState.user.uid, productID).then((result) {
        // Update the state:
        if (result == true) {
          if (this.mounted) {
            setState(() {
              if (!appState.recommended.contains(productID))
                appState.recommended.add(productID);
              else
                appState.recommended.remove(productID);
            });
          }
        }
      });
    }
  }
  Widget _buildOption(String option) {
    final bool saved = _picked.contains(option);
    print("_buildOption");
    return ListTile(
        title: Text(option),
        leading: new Icon(
          saved ? Icons.check_box : Icons.check_box_outline_blank,
          color: saved ? Colors.tealAccent : null,
        ),
        onTap: () {
          if (this.mounted) { //This registers a tap to a widget from the screen.
            setState(() {
              if (saved) { //If it's already saved, tapping it will remove it.
                _picked.remove(option);
              } else { //If not, it'll add it ot save.
                _picked.add(option);
              }
            });
          }
        }
    );
  }
}
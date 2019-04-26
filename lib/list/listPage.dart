import 'package:flutter/material.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/list/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/list/product.dart';
import 'package:gift_genie/list/product_card.dart';

var tmp = ["1506702023", "B0009KF58I", "B010TQY7A8"];

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ListPageState();
}

class ListPageState extends State<ListPage> {
  //@override
  StateModel appState;


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
                Tab(icon: Icon(Icons.local_offer, size: _iconSize)),
                Tab(icon: Icon(Icons.redeem, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: body,
        ),
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

  TabBarView _buildTabsContent() {
    Padding _buildProducts({int type, List<String> ids}) {
      CollectionReference collectionReference =
      Firestore.instance.collection('Products');
      Stream<QuerySnapshot> stream;
      //The argument recipeType is set
     /* if (type != null) {
        stream = collectionReference
            .where("type", isEqualTo: type)
            .snapshots();
      } else {*/
        // Use snapshots of all recipes if recipeType has not been passed
        stream = collectionReference.snapshots();
      //}

      // Define query depending on passed args
      return Padding(
        // Padding before and after the list view:
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: new StreamBuilder(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return _buildLoadingIndicator();
                  return new ListView(
                    children: snapshot.data.documents
                    // Check if the argument ids contains document ID if ids has been passed:
                        .where((d) => ids == null || ids.contains(d.documentID))
                        .map((document) {
                      return new ProductCard(
                        product:
                            Product.fromMap(document.data, document.documentID),
                        inFavorites:
                            appState.favorites.contains(document.documentID),
                        onFavoriteButtonPressed: _handleFavoritesListChanged,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return TabBarView (
      children: [
        _buildProducts(type: 1),
        _buildProducts(ids: appState.recommended),
        _buildProducts(ids: appState.favorites),
        //Center(child: Icon(Icons.favorite)),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}

/*
    @override
    Widget build(BuildContext context) {
      appState = StateWidget
          .of(context)
          .state;
      return Scaffold(
        body: _buildPageContent(),
      );
    }
  }
  */

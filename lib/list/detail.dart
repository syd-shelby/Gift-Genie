import 'package:flutter/material.dart';
import 'package:gift_genie/list/product.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/list/store.dart';

import 'package:gift_genie/list/product_image.dart';
import 'package:gift_genie/list/product_title.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';


class DetailScreen extends StatefulWidget {
  final Product product;
  final bool inFavorites;

  DetailScreen(this.product, this.inFavorites);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  StateModel appState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _inFavorites = widget.inFavorites;
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProductImage(widget.product.imageURL), //PRODUCT IMAGE*************
                    ProductTitle(widget.product, 25.0),
                  ],
                ),
              ),
              expandedHeight: 340.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                labelColor:  Colors.black,
                tabs: <Widget>[
                  Tab(text: "Description"),
                  Tab(text: "Link to Amazon"),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            IngredientsView(widget.product.description, widget.product.rating),
            PreparationView(widget.product.id),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateFavorites(appState.user.uid, widget.product.id).then((result) {
            // Toggle "in favorites" if the result was successful.
            if (result) _toggleInFavorites();
          });
        },

        child: Icon(
          _inFavorites ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class IngredientsView extends StatelessWidget {
  final String description;
  final String rating;
  IngredientsView(this.description, this.rating);
  //IngredientsView(this.rating);

  @override
  Widget build(BuildContext context) {

   List<Widget> children = new List<Widget>();
    //ingredients.forEach((item) {
      children.add(
        new Column(
          children: <Widget>[
            //new Icon(Icons.done),
            new SizedBox(width: 5.0),
            new Text("Rating: " + rating),
            new Text(""),
            new Text(description),
          ],

        ),
      );
      // Add spacing between the lines:
      children.add(
        new SizedBox(
          height: 5.0,
        ),
      );
    //});

    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );

  }
}

class PreparationView extends StatelessWidget {
  final String id;
  PreparationView(this.id);

  @override
  Widget build(BuildContext context) {
    /*List<Widget> children = new List<Widget>();
    //ingredients.forEach((item) {
    children.add(
      new Column(
        children:[
          new SizedBox(width: 5.0),
          new Text("https://www.amazon.com/dp/" + id),
        ],
      ),
    );
    // Add spacing between the lines:
    children.add(
      new SizedBox(
        height: 5.0,
      ),
    );
    //});

    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );*/

    String url = "https://www.amazon.com/dp/" + id;

    return Scaffold(
      body: new Center(
        child: new RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: url,
                style: new TextStyle(color: Colors.blue),

                recognizer: new TapGestureRecognizer()
                ..onTap = () { launch(url);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
Center _buildStars(String rating) {
  var ratingNum = int.p barse(rating);
child:
  if(ratingNum < 1)
    print(new Icon(Icons.star_half));

  else if(ratingNum < 1.5)
    print(new Icon(Icons.star));

  else if(ratingNum < 2) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star_half));
  }

  else if(ratingNum < 2.5) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
  }

  else if(ratingNum < 3) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star_half));
  }

  else if(ratingNum < 3.5) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
  }

  else if(ratingNum < 4) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star_half));
  }

  else if(ratingNum < 4.5) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
  }

  else if(ratingNum < 5) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star_half));
  }

  else if(ratingNum == 5) {
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
    print(new Icon(Icons.star));
  }
    return child;

} */

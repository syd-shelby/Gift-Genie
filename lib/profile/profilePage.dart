import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/utils/settings_button.dart';
//import 'package:image_picker/image_picker.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  StateModel _appState;

  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;

  var userAvatar;
  var userName;
  var titles = [
    "Update Profile", "Security Settings", "Notification Settings", "Quiz", "EXIT"];
  //var tabCount = 0;
  final int tabTotal = 4;
  var imagePaths = [
    "images/ic_my_message.png",
    "images/ic_my_blog.png",
    "images/ic_my_blog.png",
    "images/ic_my_question.png",
    "images/ic_discover_pos.png",
    "images/ic_my_team.png",
    "images/ic_my_recommend.png"
  ];

  var imageFile = "Images/userPic.jpg";
  var imageFile2;

  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var rightArrowIcon = new Image.asset(
    'Images/ic_arrow_right.png',
    width: ARROW_ICON_WIDTH,
    height: ARROW_ICON_WIDTH,
  );

  @override
  Widget build(BuildContext context) {
//    return showCustomScrollView();
    var listView = new ListView.builder(
      itemBuilder: (context, i) => renderRow(context, i),
      itemCount: titles.length * 2 + 1,
    );
    return listView;
  }

  renderRow(context, i) {
    final userHeaderHeight = 200.0;
    if (i == 0) {
      var userHeader = new Container(
          height: userHeaderHeight,
          color: Colors.blue,
          child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  userAvatar == null
                      ? new Image.asset(
                    imageFile,
                    width: 130.0,
                  )
                      : new Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: new DecorationImage(
                            image: new NetworkImage(userAvatar),
                            fit: BoxFit.cover),
                        border:
                        new Border.all(color: Colors.white, width: 5.0)),
                  ),
                  new Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: new Text(
                      StateWidget.of(context).state.uuser.getName(),
                      style: new TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )
                ],
              )));
      return new GestureDetector(
        onTap: () {
          showModalBottomSheet(context: context, builder: (BuildContext context) {
            return new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text("Take a Photo"),
                  /*
                  onTap: () async {
                    imageFile2 = await ImagePicker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context);
                    setState(() {
                      imageFile = imageFile2;
                    });
                  }
                  */
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text("Choose from Gallery"),
                  /*
                  onTap: () async {
                    imageFile2 = await ImagePicker.pickImage(source: ImageSource.camera);
                    Navigator.pop(context);
                    setState(() {
                      imageFile = imageFile2;
                    });
                  },*/
                ),
              ],
            );
          });
        },
        child: userHeader,
      );
    }
    --i;
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;
    String title = titles[i];
    if(title == "EXIT") {
      return new Row(
        children: <Widget>[
          _buildButton(),
        ],
        //onTap: () {tabCount = 0;},
      );
    }
    //tabCount += 1;
    var listItemContent = new Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
      child: new Row(
        children: <Widget>[
          new GestureDetector(
              child: new Text(
                title,
                style: titleTextStyle,
              )),
          rightArrowIcon,
        ],
      ),
    );
    return new InkWell(
      child: listItemContent,
      onTap: () {
        _pushAddTodoScreen(i);
      },
    );
  }

  void _pushAddTodoScreen(index) {
    //var _timeR;
    // Push this page onto the stack
    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well as adding
      // a back button to close it
        new MaterialPageRoute(
            builder: (context) {

              if(index == 0) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text(titles[index])
                    ),
                    body: new Column(

                    )
                );
              }
              else if(index == 1) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text(titles[index])
                    ),
                    body: new Column()
                );
              }
              else if(index == 2) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text(titles[index])
                    ),
                    body: new Column()
                );
              }
              else if(index == 3) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text(titles[index])
                    ),
                    body: new Column()
                );
              }
            }
        )
    );
  }
  /*
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("Choose from Library or Take a Photo"),
      );
    } else {
      return Image.file(
        imgPath,
      );
    }
  }

  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image;
    });
  }

  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image;
    });
  }
  */

  Widget showCustomScrollView() {
    return new CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: const FlexibleSpaceBar(
            title: const Text('Demo'),
          ),
        ),
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: new Text('grid item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        new SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
          new SliverChildBuilderDelegate((BuildContext context, int index) {
            return new Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: new Text('list item $index'),
            );
          }, childCount: 10),
        ),
      ],
    );
  }

/*
  @override
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _buildButton(),
    );
  }

 */
  //Log Out Button
  Align _buildButton() {

    return Align(
      //crossAxisAlignment: CrossAxisAlignment.center,
      child: SizedBox(
        height: 45.0,
          width: 150.0,
          child :SettingsButton(
            Icons.exit_to_app,
            'Log out',
            () async {
              if(StateWidget.of(context).state.type == LogType.google) {
                await StateWidget.of(context).signOutOfGoogle();
              }
              if(StateWidget.of(context).state.type == LogType.email) {
                await StateWidget.of(context).signOutOfEmail();
              }
              if(StateWidget.of(context).state.type == LogType.twitter){
                await StateWidget.of(context).signOutOfTwitter();
              }

              if(StateWidget.of(context).state.isSignedIn == false) {
                Navigator.of(context).pushNamedAndRemoveUntil("/LoginPage", (Route<dynamic> route) => false);
              }
            },
          )
      ),
    );
  }

  void logOutOfApp() {

  }
}
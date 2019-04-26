import 'package:flutter/material.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/utils/friend.dart';
import 'package:intl/intl.dart';
import 'package:gift_genie/utils/userPair.dart';
import 'package:gift_genie/auth/authPages/loginPage.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  StateModel _appState;

  final dbGR = Firestore.instance.collection("GivingRecords");
  final db = Firestore.instance.collection("Users");
  
  double _imageWidth = 512;
  double _imageHeight = 220;

  //Temporary user list - for test:
  List<User> entryList =[];
  Map<String, String> indToName = {
    "2sRkm9sv9ibOCyPtZ63eYcGx3qC2":"dspub",
    "ywO18AiLQzNxueHOoOMRGuGtfUA3": "ds679",
    "3deCiLECivZa3MFQ5a2ROMCrPsK2": "ds976",
    "w8ubbSDoq0fbFeYgK91Rr3K2hCI3": "ds546",
    "tecBMTwsWaOelvJ1NdseSgpUJDv2": "ds9477",
  };

  @override
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;

    return Scaffold(
      body: _buildContent(),
    );

    }

  //TODO User can choose pic themselves
  Widget _buildImage() {
    return new ClipPath(
      clipper: new DiagonalClipper(),
      child: new Image.asset(
        'Images/background.jpg',
        height: _imageHeight,
        width: _imageWidth,
        fit: BoxFit.fill,
        colorBlendMode: BlendMode.srcOver,
        color: new Color.fromARGB(50, 20, 10, 40),
      ),
    );
  }

  Widget _buildHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileRow() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundColor: Colors.white,
            backgroundImage: new AssetImage('Images/userPic.jpg'),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  _appState.uuser.name,
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                /*
                new Text(
                  'Project Leader',
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildEntryList(),
        ],
      ),
    );
  }

  Widget _buildMyTasksHeader() {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Gift Plaza',
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            formattedDate,
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: _imageHeight - 55,
      bottom: 0.0,
      left: 37.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[700],
      ),
    );
  }

  Future getRecords() async {
    QuerySnapshot qs = await dbGR.getDocuments();

    return qs.documents;
  }


  Widget _buildEntryList() {
    return new Expanded(
      child: new FutureBuilder(
         future: getRecords(),
          builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading"),
              );
            }
            else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index){
                      //buildItem(index, snapshot);
                      return buildItem(context, index, snapshot);
                    });
            }
          })
      /*
      new ListView(
        children: entryList.map((user) => new UserUpdateEntry(giver: user)).toList(),
      ),
      */
    );
  }

  Future<String> getUserName(String userIndex) async {

    String n;

    await db.document(userIndex).get().then((DocumentSnapshot ds) {

      n = ds["name"];
    });

    return n;
  }

  Widget buildItem(BuildContext context, int index, snapshot)  {

    String giverIndex = snapshot.data[index].data["giver"];
    String receiverIndex = snapshot.data[index].data["receiver"];
    String time = snapshot.data[index].data["time"];

    String gn = indToName[giverIndex];
    String rn = indToName[receiverIndex];

    print(gn);
    print(rn);

    Friend userG = new Friend(avatarUrl: "", name: gn, email: "-");
    Friend userR = new Friend(avatarUrl: "", name: rn, email: "-");


    return new ListTile(
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(userG.avatarDownloadUrl),
        ),
      ),
      title: new Text(userG.name + " Sent " + userR.name + " a Gift!"),
      subtitle: new Text(time),
      trailing: new Text("View More")
      );
    
    //return new UserUpdateEntry(giver:userG, receiver: userR, time: time);

  }



  Widget _buildContent() {

    if (_appState.isLoading) {
      return _buildLoadingIndicator();
    }
    else {
      return _buildWholePage();
    }
  }

  Widget _buildWholePage() {

    return new Stack(
      children: <Widget>[
        _buildImage(),
        _buildHeader(),
        _buildTimeline(),
        _buildProfileRow(),
        _buildBottomPart(),
      ],
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

}

class UserUpdateEntry extends StatefulWidget {

  final User giver;
  final User receiver;
  final double _radius = 24;
  final String time;

  UserUpdateEntry({Key key, this.giver, this.receiver, this.time}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _UserUpdateEntryState();
  }

}

class _UserUpdateEntryState extends State<UserUpdateEntry> {

  void initState() {
    super.initState();
    //renderUserPic();
  }
  
  Widget get userImage {
    return Container(
      width: widget._radius,
      height: widget._radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: new AssetImage('Images/userPic.png')),
      ),
    );
  }

  Widget build(BuildContext context) {

    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 32.0 - widget._radius / 2),
            child: new Container(
              height: widget._radius,
              width: widget._radius,
              decoration: new BoxDecoration(shape: BoxShape.circle),
              child: userImage,
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.giver.name,
                  style: new TextStyle(fontSize: 18.0),
                ),
                new Text(
                  widget.giver.status,
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                )
              ],
            ),
          ),
          new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: new Text("Sent"),
          ),
          new Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: new Text(
                widget.receiver.name,
                style: new TextStyle(fontSize: 18.0),
              ),
          ),
          new Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: new Text(
              widget.time,
              style: new TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

}

class DiagonalClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

import 'package:gift_genie/utils/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String name;
  var age;
  var year;
  var month;
  var day;
  var gender;
  var location;
  var email;
  var cellphone;
  var imageUrl;
  var avatar;
  var userID;
  var userIndex;
  List<String> friendList = [];
  List outGiftList = [];
  List inGiftList = [];
  List favGiftList = [];
  DocumentReference reference;

  var status = "TEST STATUS";

  User(name, {month, day, year, gender}) {
    this.name = name;
    this.month = month;
    this.day = day;
    this.year = year;
    this.gender = gender;
    //this.userIndex = index;
  }

  Future getImageUrl() async {
    if(imageUrl != null)
      return;
  }

  String getName() {
    return this.name;
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);


}
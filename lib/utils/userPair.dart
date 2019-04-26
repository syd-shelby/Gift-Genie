import 'package:gift_genie/utils/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPair {

  String nameG;
  String nameR;
  DocumentReference reference;

  UserPair(nameG, nameR) {
    this.nameG = nameG;
    this.nameR = nameR;
    //this.userIndex = index;
  }

  UserPair.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['giver'] != null),
        assert(map['receiver'] != null),
        nameG = map['giver'],
        nameR = map['receive'];

  UserPair.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
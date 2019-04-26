import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> updateInvitations(String uid, String userIndex, int mode) {

  String field;
  if(mode == 0) {
    field = "invitations";
  }
  else {
    field = "friends";
  }

  DocumentReference userReference =
  Firestore.instance.collection('Users').document(userIndex);

  return Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(userReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the recipe ID:
      if (postSnapshot.data[field].contains(uid)) {
        await tx.update(userReference, <String, dynamic>{
          field: FieldValue.arrayRemove([uid])
        });
        print("DELETED!");
        // Delete the recipe ID from 'favorites':
      } else {
        /*
        await tx.update(userReference, <String, dynamic>{
          'invitations': FieldValue.arrayRemove([userIndex])
        });
        */
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('Error: $error');
    return false;
  });
}
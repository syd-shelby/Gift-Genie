import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> updateFavorites(String uid, String productId) {
  DocumentReference favoritesReference =
  Firestore.instance.collection('Users').document(uid);

  return Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the recipe ID:
      if (!postSnapshot.data['favorites'].contains(productId)) {
        await tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayUnion([productId])
        });
        // Delete the recipe ID from 'favorites':
      } else {
        await tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayRemove([productId])
        });
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      await tx.set(favoritesReference, {
        'favorites': [productId]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('Error: $error');
    return false;
  });
}

Future<bool> updateRecommended(String uid, String productId) {
  print("update rec");
  DocumentReference recommendedReference =
  Firestore.instance.collection('Users').document(uid);

  return Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(recommendedReference);
    if (postSnapshot.exists) {
      // Extend 'favorites' if the list does not contain the recipe ID:
      if (!postSnapshot.data['recommended'].contains(productId)) {
        await tx.update(recommendedReference, <String, dynamic>{
          'recommended': FieldValue.arrayUnion([productId])
        });
        // Delete the recipe ID from 'favorites':
      } else {
        await tx.update(recommendedReference, <String, dynamic>{
          'recommended': FieldValue.arrayRemove([productId])
        });
      }
    } else {
      // Create a document for the current user in collection 'users'
      // and add a new array 'favorites' to the document:
      await tx.set(recommendedReference, {
        'recommended': [productId]
      });
    }
  }).then((result) {
    return true;
  }).catchError((error) {
    print('Error: $error');
    return false;
  });
}
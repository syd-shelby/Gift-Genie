import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:gift_genie/auth/state.dart';
import 'package:gift_genie/auth/auth.dart';

class StateWidget extends StatefulWidget {

  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
    as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  final db = Firestore.instance.collection('Users');
  final dbUE = Firestore.instance.collection('UserEmails');
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<List<String>> getFavorites() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('Users')
        .document(state.user.uid)
        .get();
   if (querySnapshot.exists &&
       querySnapshot.data.containsKey('favorites') &&
       querySnapshot.data['favorites'] is List) {
     // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['favorites']);
    }
    return [];
  }

  Future<List<String>> getRecommended() async {
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('Users')
        .document(state.user.uid)
        .get();
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('recommended') &&
        querySnapshot.data['recommended'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data['recommended']);
    }
    return [];
  }

  //Google Login and Log out
  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await handleSignInGoogle(googleAccount);
    state.user = firebaseUser;
    //state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
    List<String> favorites = await getFavorites();
    List<String> recommended = await getRecommended();

    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
      state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
      state.isSignedIn = true;
      state.type = LogType.google;
      state.favorites = favorites;
      state.recommended = recommended;
      getIndex();
      loadUserInfo();
    });
  }

  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.user = null;
    state.uuser = null;
    setState(() {
      state = StateModel(user: null, uuser: null);
    });
  }


  //TODO Facebook login
  /*
  Future<Null> signInWithFacebook() async {
    FirebaseUser firebaseUser = await handleSignInFacebook();
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
      state.isSignedIn = true;
      state.type = LogType.facebook;
    });
  }

  Future<Null> signOutOfFacebook() async {
    // Sign out from Firebase and email
    await FirebaseAuth.instance.signOut();
    //await emailSignIn.signOut();
    // Clear variables
    //googleAccount = null;
    state.user = null;
    setState(() {
      state = StateModel(user: null);
    });
  }
  */

  Future<Null> signInWithTwitter() async {
    FirebaseUser firebaseUser = await handleSignInTwitter();
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
      state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
      state.isSignedIn = true;
      state.type = LogType.twitter;
    });
  }

  Future<Null> signOutOfTwitter() async {
    // Sign out from Firebase and email
    await FirebaseAuth.instance.signOut();

    // Clear variables
    state.user = null;
    state.uuser = null;
    setState(() {
      state = StateModel(user: null, uuser: null);
    });
  }

  //Email/Password Login and Log out
  Future<Null> signInWithEmail(String email, String password) async {
    FirebaseUser firebaseUser = await handleSignInEmail(email, password);

    state.user = firebaseUser;

    if(!firebaseUser.isEmailVerified) {
      state.user = null;
      return;
    }

    List<String> favorites = await getFavorites();
    List<String> recommended = await getRecommended();

    //state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
      state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
      state.isSignedIn = true;
      state.type = LogType.email;
      state.favorites = favorites;
      state.recommended = recommended;
      getIndex();
      loadUserInfo();
    });
    print("PRINTING!");
    print(state.uuser.userIndex);
  }

  Future<Null> signOutOfEmail() async {
    // Sign out from Firebase and email
    await FirebaseAuth.instance.signOut();

    // Clear variables
    state.user = null;
    state.uuser = null;
    setState(() {
      state = StateModel(user: null, uuser: null);
    });
  }

  Future<Null> signUpWithEmail(String email, String password) async {
    FirebaseUser firebaseUser = await handleSignUp(email, password);
    state.user = firebaseUser;
    state.uuser = User(firebaseUser.displayName == null? firebaseUser.email.split("@")[0]:firebaseUser.displayName);
    state.type = LogType.email;
  }

  Future<void> getIndex() async {
     await dbUE.document(state.uuser.email)
        .get()
        .then((DocumentSnapshot ds) {
      state.uuser.userIndex = ds["userIndex"];
    });
     print("PRINTING!");
     print(state.uuser.userIndex);
  }

  Future<void> loadUserInfo() async {

     await db.document(state.uuser.userIndex)
    .get()
    .then((DocumentSnapshot ds) {
        state.uuser.avatar = ds["avatar"];
        state.uuser.friendList = ds["friends"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
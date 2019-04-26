import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
    // Is the user already signed in?
    GoogleSignInAccount account = googleSignIn.currentUser;
      // Try to sign in the previous user:
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
}

Future<FirebaseUser> handleSignInGoogle(
    GoogleSignInAccount googleSignInAccount) async {
      FirebaseAuth _auth = FirebaseAuth.instance;

      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      return await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
}

Future<FirebaseUser> handleSignInEmail(String email, String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseUser user = await auth.signInWithEmailAndPassword(email: email, password: password);

  assert(user != null);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await auth.currentUser();
  assert(user.uid == currentUser.uid);

  print('signInEmail succeeded: $user');
  return user;
}

Future<FirebaseUser> handleSignUp(email, password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.createUserWithEmailAndPassword(email: email, password: password);

  assert (user != null);
  assert (await user.getIdToken() != null);

  user.sendEmailVerification();

  return user;
}

Future<FirebaseUser> handleSignInTwitter() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TwitterLogin twitterLogin = new TwitterLogin(consumerKey: 'NZqaxwMqA2U6Lk39Vt8BZtvpD',
     consumerSecret: 'DYW77DrIwwrIWbXAupbDiO03d4w3bDoD5cwZvTLmhnuviU0ZSC'
  );

  TwitterLoginResult _twitterLoginResult = await twitterLogin.authorize();
  TwitterSession _currentUserTwitterSession = _twitterLoginResult.session;
   TwitterLoginStatus _twitterLoginStatus = _twitterLoginResult.status;

  final FirebaseUser user = await auth.signInWithTwitter(
      authToken: _currentUserTwitterSession?.token ?? '',
      authTokenSecret: _currentUserTwitterSession?.secret ?? ''
  );
  return user;
}

Future<FirebaseUser> handleSignInFacebook() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
}
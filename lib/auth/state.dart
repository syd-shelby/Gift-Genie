import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift_genie/utils/user.dart';

enum LogType {
  email,
  facebook,
  google,
  twitter,
  unset,
}

class StateModel {
  bool isLoading;
  bool isSignedIn;
  LogType type;
  FirebaseUser user;
  User uuser;
  List<String> favorites;
  List<String> recommended;

  StateModel({
    this.isLoading = false,
    this.isSignedIn = false,
    this.type = LogType.unset,
    this.user = null,
    this.uuser = null,
    this.favorites = null,
    this.recommended = null
  });
}
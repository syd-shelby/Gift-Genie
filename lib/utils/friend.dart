import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Friend {
  Friend({
    @required this.avatarUrl,
    @required this.name,
    @required this.email,
  }
  ) {
    downloadImage();
  }

  final String avatarUrl;
  final String name;
  final String email;
  String cellphone;
  String gender;
  String avatarDownloadUrl;
  String userInex;


  static String _capitalize(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  Future downloadImage() async{
      StorageReference reference = FirebaseStorage.instance.ref().child(this.avatarUrl);
      //this.avatarDownloadUrl = await reference.getDownloadURL();
    this.avatarDownloadUrl = "https://firebasestorage.googleapis.com/v0/b/gift-genie-f1f6a.appspot.com/o/718958539%2Fdthc.ava.jpg?alt=media&token=f5644954-ac17-4f6f-9729-4e12674c97f2";
  }
}
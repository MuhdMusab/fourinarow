import 'package:cloud_firestore/cloud_firestore.dart';

class GameUser {
  final String username;

  GameUser(this.username);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'username': username,
  };

  GameUser.fromJson(Map<dynamic, dynamic> json)
      : username = json['username'] as String;

  void addUser() {
    FirebaseFirestore.instance
        .collection("users").doc(username).set(toJson());
  }
}
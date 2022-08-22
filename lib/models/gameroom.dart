import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Gameroom {
  final String firstUser;
  final String secondUser;

  Gameroom(this.firstUser, this.secondUser);

  Map<String, dynamic> generateBoard() {
    Map<String, dynamic> map = {};
    for (int i = 0; i < 7 * 6; i++) {
      map[i.toString()] = {
        'index' : i,
        'player': 'unknown',
      };
    }
    return map;
  }

  Map<String, dynamic> toJson(String gameroomId) {
    Map<String, dynamic> map = {
    'isAboutToDelete': false,
    'gameroomId': gameroomId,
    'firstUser': firstUser,
    'secondUser': secondUser,
    'isFirstUserTurn': true,
    'winner': "unknown",
    };
    for (int i = 0; i < 7 * 6; i++) {
      map[i.toString()] = {
        'index' : i,
        'player': 'unknown',
      };
    }
    return map;
  }

  Gameroom.fromJson(Map<dynamic, dynamic> json)
      : firstUser = json['firstUser'] as String,
        secondUser = json['secondUser'] as String;

  void addGameroom() {
    String gameroomId = const Uuid().v1(); // creates unique id based on time
    FirebaseFirestore.instance
        .collection("gamerooms").doc(gameroomId).set(toJson(gameroomId));
  }

  Future<String> getGameroomId() async{
    List<QueryDocumentSnapshot<Map<String, dynamic>>> firstCombination = (await FirebaseFirestore.instance
        .collection("gamerooms")
        .where('firstUser', isEqualTo: firstUser)
        .where('secondUser', isEqualTo: secondUser).get()).docs;
    List<QueryDocumentSnapshot<Map<String, dynamic>>> secondCombination = (await FirebaseFirestore.instance
        .collection("gamerooms")
        .where('firstUser', isEqualTo: secondUser)
        .where('secondUser', isEqualTo: firstUser).get()).docs;
    if (firstCombination.length == 1) {
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot = firstCombination[0];
      return snapshot.data()['gameroomId'];
    }
    if (secondCombination.length == 1) {
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot = secondCombination[0];
      return snapshot.data()['gameroomId'];
    }
    return "";
  }
  static Future<bool> containsGameroom(String firstUser, String secondUser) async{
    bool containsFirstCombination = (await FirebaseFirestore.instance
        .collection("gamerooms")
        .where('firstUser', isEqualTo: firstUser)
        .where('secondUser', isEqualTo: secondUser).get()).docs.length == 1;
    bool containsSecondCombination = (await FirebaseFirestore.instance
        .collection("gamerooms")
        .where('firstUser', isEqualTo: secondUser)
        .where('secondUser', isEqualTo: firstUser).get()).docs.length == 1;
    return containsFirstCombination || containsSecondCombination;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/gameroom.dart';
import 'package:four_in_a_row/models/user.dart';
import 'package:four_in_a_row/screens/game_screen.dart';
import 'package:four_in_a_row/widgets/cancellable_dialog_box.dart';

void signIn(GlobalKey<FormState> usernameFormKey, TextEditingController usernameEditingController, Function callback) async{
  if (usernameFormKey.currentState!.validate()) {
    String username =  usernameEditingController.text;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(username).get();
    if (snapshot.data() == null) {
      GameUser user = GameUser(username);
      user.addUser();
    }
    callback();
  }
}

void checkOpponent(GlobalKey<FormState> opponentFormKey, String username, TextEditingController opponentUsernameEditingController,
    Function callback, BuildContext context) async{
  if (opponentFormKey.currentState!.validate()) {
    String opponentUsername =  opponentUsernameEditingController.text;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(opponentUsername).get();
    if (snapshot.data() == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CancellableDialogBox(title: 'Error', text: 'Opponent not found');
          });
    } else if (username == opponentUsername) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CancellableDialogBox(title: 'Error', text: "You can't challenge yourself!");
          });
    } else {
      Gameroom gameroom = Gameroom(username, opponentUsername);
      String gameroomId = await gameroom.getGameroomId();
      if (await Gameroom.containsGameroom(username, opponentUsername)) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(firstUser: username,
                secondUser: opponentUsername, gameroomId: gameroomId,),
            ));
      } else {
        gameroom.addGameroom();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(firstUser: username,
                secondUser: opponentUsername, gameroomId: gameroomId,),
            ));
      }
    }
  } else {
    print('yes');
  }


}

void popDialog(String gameroomId) {
  final db = FirebaseFirestore.instance.collection('gamerooms').doc(gameroomId);
  db.update({
    "isAboutToDelete": true,
    "winner": "unknown",
  });
}
void restartBoard(String firstUser, String secondUser, String gameroomId) async {
  popDialog(gameroomId);
  Future.delayed(Duration(milliseconds: 500));
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
  FirebaseFirestore.instance
      .collection("gamerooms").doc(gameroomId).set(map);
}

void updateTile(String gameroomId, int tileIndex, String player, bool newIsFirstUserTurn) async {
  FirebaseFirestore.instance.collection('users').doc(gameroomId)
      .update({
    "isFirstPlayerTurn": newIsFirstUserTurn,
  });
}
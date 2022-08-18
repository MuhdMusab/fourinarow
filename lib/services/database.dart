import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_in_a_row/blocs/internet_cubit.dart';
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
    } else {
      GameUser user = GameUser(username);
    }
    callback();
  } else {
    print('yes');
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
      if (await Gameroom.containsGameroom(username, opponentUsername)) {
        String gameroomId = await gameroom.getGameroomId();
        print('contains');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(firstUser: username,
                secondUser: opponentUsername, gameroomId: gameroomId,),
            ));
      } else {
        print('does not contain');
        gameroom.addGameroom();
      }
    }
  } else {
    print('yes');
  }

  void updateTile(String gameroomId, int tileIndex, String player, bool newIsFirstUserTurn) async {
    FirebaseFirestore.instance.collection('users').doc(gameroomId)
        .update({
          "isFirstPlayerTurn": newIsFirstUserTurn,
        });
  }
}
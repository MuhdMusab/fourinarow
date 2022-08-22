import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_in_a_row/blocs/board_cubit.dart';
import 'package:four_in_a_row/models/board.dart';
import 'package:four_in_a_row/screens/play_screen.dart';
import 'package:four_in_a_row/widgets/double_option_dialog_box.dart';
import 'package:four_in_a_row/services/database.dart';

class GameScreen extends StatefulWidget {
  final String firstUser;
  final String secondUser;
  final String gameroomId;

  const GameScreen({
    Key? key,
    required this.firstUser,
    required this.secondUser,
    required this.gameroomId,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  void listenToDoc() {
    FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).snapshots(includeMetadataChanges: true).listen((DocumentSnapshot<Map<String, dynamic>> event) {
      Map<String, dynamic>? map = event.data();
      if (map != null && map.containsKey("winner") && map["isAboutToDelete"] == true && map["winner"] != "unknown") {
        Navigator.of(context, rootNavigator: true).pop();
        popUntilHome();
      }
      if (map != null && map.containsKey("winner") && map["isAboutToDelete"] == true && map["winner"] == "unknown") {
        Navigator.of(context).pop();
      }
      if (map != null && map.containsKey("winner") && map["winner"] == widget.secondUser
          && map.containsKey("winner") && map["isAboutToDelete"] == false) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return DoubleOptionDialogBox(
                title: 'Aww',
                text: "You've lost the game",
                firstFunction: restartBoard,
                secondFunction: exitPopFunction,
                firstOptionText: "Play again",
                secondOptionText: "Exit",
                firstUser: widget.firstUser,
                secondUser: widget.secondUser,
                gameroomId: widget.gameroomId,
              );
            });
      }
    });
  }

  void popUntilHome() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => PlayScreen()), (Route route) => false);
  }

  void exitPopFunction() async {
    final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
    db.update({
      "isAboutToDelete": true
    });
   popUntilHome();
    await Future.delayed(const Duration(seconds: 5));
    FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).delete();
  }

  void initState() {
    listenToDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('gamerooms').where('gameroomId', isEqualTo: widget.gameroomId, ).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      Navigator.pop(context);
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      bool isFirstUser = snapshot.data!.docs[0].data()["firstUser"] == widget.firstUser
                          ? true
                          : false;
                      bool isFirstUserTurn = snapshot.data!.docs[0].data()["isFirstUserTurn"];
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 100.0),
                                  child: Board(snapshot: snapshot.data!.docs[0].data(), firstUser: widget.firstUser,
                                      secondUser: widget.secondUser, isFirstUser: isFirstUser, isFirstUserTurn:
                                      isFirstUserTurn, gameroomId: widget.gameroomId),
                                ),
                                Align(
                                  alignment: Alignment(0, 0.5),
                                  child: Text(
                                    isFirstUser
                                        ? isFirstUserTurn
                                        ? "It's your turn!"
                                        : "It's " + widget.secondUser + "'s turn"
                                        : isFirstUserTurn
                                        ? "It's " + widget.secondUser + "'s turn"
                                        : "It's your turn!",
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }
              )
    );
  }
}

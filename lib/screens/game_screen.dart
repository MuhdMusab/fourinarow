import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_in_a_row/blocs/board_cubit.dart';
import 'package:four_in_a_row/blocs/internet_cubit.dart';
import 'package:four_in_a_row/models/board.dart';
import 'package:four_in_a_row/screens/play_screen.dart';
import 'package:four_in_a_row/widgets/board_tile.dart';
import 'package:four_in_a_row/widgets/cancellable_dialog_box.dart';
import 'package:four_in_a_row/widgets/double_option_dialog_box.dart';
import 'package:four_in_a_row/widgets/uncancellable_dialog_box.dart';
import 'package:provider/provider.dart';

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
  BuildContext? _dialogContext;

  // void listenToDoc() {
  //   FirebaseFirestore.instance.collection('gamerooms')
  //       .doc(widget.gameroomId).snapshots(includeMetadataChanges: true).listen((DocumentSnapshot<Map<String, dynamic>> event) {
  //     print("hello");
  //     final map = event.data();
  //     if (map != null) {
  //       print(map['firstUser']);
  //     }
  //   });
  // }
  void listenToDoc() {
    FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).snapshots(includeMetadataChanges: true).listen((DocumentSnapshot<Map<String, dynamic>> event) {
      Map<String, dynamic>? map = event.data();
      if (map != null && map.containsKey("winner") && map["isAboutToDelete"] == true) {
        // if (_dialogContext != null) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }
        Navigator.of(context, rootNavigator: true).pop();
        popFunction();
      }
      if (map != null && map.containsKey("winner") && map["winner"] == widget.secondUser) {
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
                _dialogContext = dialogContext;
              return DoubleOptionDialogBox(title: 'Aww', text: "You've lost the game",
                firstFunction: () {}, secondFunction: () {}, firstOptionText: "Play again",
                secondOptionText: "Exit",);
            });
      }
    });
  }

  void popFunction() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => PlayScreen()), (Route route) => false);
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
                    if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      bool isFirstUser = snapshot.data!.docs[0].data()["firstUser"] == widget.firstUser
                          ? true
                          : false;
                      bool isFirstUserTurn = snapshot.data!.docs[0].data()["isFirstUserTurn"];
                      return BlocProvider(
                        create: (context) => BoardCubit(user: widget.firstUser, gameroomId: widget.gameroomId),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: Board(snapshot: snapshot.data!.docs[0].data(), firstUser: widget.firstUser,
                                    secondUser: widget.secondUser, isFirstUser: isFirstUser, isFirstUserTurn:
                                    isFirstUserTurn, gameroomId: widget.gameroomId),
                              ),
                            ),
                            Text(
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
                            )
                          ],
                        ),
                      );
                    }
                  }
              )
    );
  }
}

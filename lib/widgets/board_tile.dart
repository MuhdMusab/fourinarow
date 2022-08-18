import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:four_in_a_row/screens/play_screen.dart';
import 'package:four_in_a_row/services/database.dart';
import 'package:flutter/material.dart';
import 'package:four_in_a_row/models/tile.dart';
import 'package:four_in_a_row/widgets/cancellable_dialog_box.dart';
import 'package:four_in_a_row/widgets/double_option_dialog_box.dart';

class BoardTile extends StatefulWidget {
  final int boardIndex;
  final Map<String, dynamic> map;
  final String firstUser;
  final String secondUser;
  final bool isFirstUser;
  final bool isFirstUserTurn;
  final String gameroomId;

  const BoardTile({
    super.key,
    required this.map,
    required this.boardIndex,
    required this.firstUser,
    required this.secondUser,
    required this.isFirstUser,
    required this.isFirstUserTurn,
    required this.gameroomId,
  });

  @override
  State<BoardTile> createState() => _BoardTileState();
}

class _BoardTileState extends State<BoardTile> {
  void listenToDoc() {
    FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).snapshots(includeMetadataChanges: true).listen((DocumentSnapshot<Map<String, dynamic>> event) {
      print("hello");
      print(event);
      print(event.data());
    });
  }

  void popFunction() async {
    final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
    db.update({
      "isAboutToDelete": true
      });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => PlayScreen()), (Route route) => false);
    // int count = 0;
    // Navigator.popUntil(context, (route) {
    //   return count++ == 2;
    // });
    await Future.delayed(const Duration(seconds: 5));
    FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).delete();

  }

  Color getTileColor(String player) {
    if (player == "unknown") {
      return Colors.white;
    } else if (player == widget.firstUser) {
      return Colors.red;
    } else {
      return Colors.blue.shade900;
    }
  }

  Future<bool> didWinVertical(int tileIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('gamerooms')
        .doc(widget.gameroomId).get();
    int row = (tileIndex / 7).floor();
    int col = tileIndex - row * 7 + 1 == 0 ? 7 : tileIndex - row * 7 + 1;
    for (int i = -3; i <= 0; i++) {
      if (row + i < 0 || row + i + 3 > 5) {
        continue;
      } else {
        bool totalBool = true;
        for (int j = 0; j < 4; j++) {
          int currRow = row + i + j;
          int currIndex = currRow * 7 + col - 1;
          if (snapshot.data() == null) {
            totalBool = false;
            return false;
          } else {
            bool isTrue = snapshot.data()![currIndex.toString()]["player"] == widget.firstUser;
            if (isTrue) {
            } else {
              totalBool = false;
            }
          }
        }
        if (totalBool) {
          final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
          db.update({
            "winner": widget.firstUser,
            "isFirstUserTurn": !widget.isFirstUserTurn,
            widget.boardIndex.toString(): {
              "index": widget.boardIndex,
              "player": widget.firstUser,
            }});
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> didWinDiagonal(int tileIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance.collection('gamerooms')
        .doc(widget.gameroomId).get();
    int row = (tileIndex / 7).floor();
    int col = tileIndex - row * 7 + 1 == 0 ? 7 : tileIndex - row * 7 + 1;
    print("Row: " + row.toString() +" Col: " + col.toString());
    print("\n");
    for (int i = -3; i <= 0; i++) {
      if (col + i < 1 || col + i + 3 > 7 || row + i < 0 || row + i + 3 > 5) {
        continue;
      } else {
        bool totalBool = true;
        for (int j = 0; j < 4; j++) {
          int currCol = col + i + j;
          int currRow = row + i + j;
          int currIndex = currRow * 7 + currCol - 1;
          if (snapshot.data() == null) {
            totalBool = false;
            return false;
          } else {
            bool isTrue = snapshot.data()![currIndex.toString()]["player"] == widget.firstUser;
            if (isTrue) {
            } else {
              totalBool = false;
            }
          }
        }
        if (totalBool) {
          final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
          db.update({
            "winner": widget.firstUser,
            "isFirstUserTurn": !widget.isFirstUserTurn,
            widget.boardIndex.toString(): {
              "index": widget.boardIndex,
              "player": widget.firstUser,
            }});
          return true;
        }
      }
    }
    for (int i = -3; i <= 0; i++) {
      if (col + i < 1 || col + i + 3 > 7 || row - i > 5 || row - i - 3 < 0) {
        continue;
      } else {
        bool totalBool = true;
        for (int j = 0; j < 4; j++) {
          int currCol = col + i + j;
          int currRow = row - i - j;
          int currIndex = currRow * 7 + currCol - 1;
          if (snapshot.data() == null) {
            totalBool = false;
            return false;
          } else {
            bool isTrue = snapshot.data()![currIndex.toString()]["player"] == widget.firstUser;
            if (isTrue) {
            } else {
              totalBool = false;
            }
          }
        }
        if (totalBool) {
          final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
          db.update({
            "winner": widget.firstUser,
            "isFirstUserTurn": !widget.isFirstUserTurn,
            widget.boardIndex.toString(): {
              "index": widget.boardIndex,
              "player": widget.firstUser,
            }});
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> didWinHorizontal(int tileIndex) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('gamerooms')
                                                            .doc(widget.gameroomId).get();
    int row = (tileIndex / 7).floor();
    int col = tileIndex - row * 7 + 1 == 0 ? 7 : tileIndex - row * 7 + 1;
    for (int i = -3; i <= 0; i++) {
      if (col + i - 1 < 0 || col + i + 3 > 7) {
        continue;
      } else {
        bool totalBool = true;
        for (int j = 0; j < 4; j++) {
          int currCol = col + i - 1 + j;
          int currIndex = row * 7 + currCol;
          if (snapshot.data() == null) {
            totalBool = false;
            return false;
          } else {
            bool isTrue = snapshot.data()![currIndex.toString()]["player"] == widget.firstUser;
            if (isTrue) {
            } else {
              totalBool = false;
            }
          }
        }
        if (totalBool) {
          final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
          db.update({
            "winner": widget.firstUser,
            "isFirstUserTurn": !widget.isFirstUserTurn,
            widget.boardIndex.toString(): {
              "index": widget.boardIndex,
              "player": widget.firstUser,
            }});
          return true;
        }
      }
    }
    return false;
  }

  // bool didWin(int tileIndex) async {
  //
  // }

  @override
  Widget build(BuildContext context) {
    int tileIndex = widget.map["index"];
    return InkResponse(
        onTap: () async {
          final db = FirebaseFirestore.instance.collection('gamerooms').doc(widget.gameroomId);
          DocumentSnapshot<Map<String, dynamic>> snapshot = await db.get();
          if (snapshot.data() != null && snapshot.data()!.containsKey(widget.boardIndex.toString())
              && (snapshot.data()![widget.boardIndex.toString()] as Map<String, dynamic>)["player"] == "unknown") {
            if (widget.isFirstUser && widget.isFirstUserTurn || !widget.isFirstUser && !widget.isFirstUserTurn) {
              db.update({
                "isFirstUserTurn": !widget.isFirstUserTurn,
                widget.boardIndex.toString(): {
                  "index": widget.boardIndex,
                  "player": widget.firstUser,
                }});
              if (await didWinDiagonal(tileIndex) || await didWinVertical(tileIndex)
                  || await didWinHorizontal(tileIndex)) {
                print("Yes correct diagonal");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DoubleOptionDialogBox(
                        title: 'Congratulations!',
                        text: "You've won the game",
                        firstFunction: () {},
                        secondFunction: popFunction,
                        firstOptionText: "Play again",
                        secondOptionText: "Exit",);
                    });
              }
              // if (await didWinVertical(tileIndex)) {
              //   print("Yes correct vertical");
              //   showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return DoubleOptionDialogBox(
              //           title: 'Congratulations!',
              //           text: "You've won the game",
              //           firstFunction: () {},
              //           secondFunction: popFunction,
              //           firstOptionText: "Play again",
              //           secondOptionText: "Exit",);
              //       });
              // }
              // if (await didWinHorizontal(tileIndex)) {
              //   print("Yes correct horizontal");
              //   showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return DoubleOptionDialogBox(
              //           title: 'Congratulations!',
              //           text: "You've won the game",
              //           firstFunction: () {},
              //           secondFunction: popFunction,
              //           firstOptionText: "Play again",
              //           secondOptionText: "Exit",);
              //       });
              // }
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            color: Colors.blue,
            child: Container(
                    margin: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: getTileColor(widget.map['player']),
                      shape: BoxShape.circle,
                    ),
                    //child: Center(child: Text(tile.toString())),
                  ),
          ),
        ));
  }
}
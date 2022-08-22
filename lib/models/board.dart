import 'package:flutter/material.dart';
import 'package:four_in_a_row/widgets/board_tile.dart';

class Board extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final String firstUser;
  final String secondUser;
  final bool isFirstUser;
  final bool isFirstUserTurn;
  final String gameroomId;

  const Board({
    Key? key,
    required this.snapshot,
    required this.firstUser,
    required this.secondUser,
    required this.isFirstUser,
    required this.isFirstUserTurn,
    required this.gameroomId,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    // print(widget.snapshot);
    // for (int i=0; i < 7 * 6; i++) {
    //   print(widget.snapshot[i.toString()]);
    // }
    return GridView.count(
      crossAxisCount: 7,
      children: [
        for (int i=0; i < 7 * 6; i++)
          BoardTile(map: widget.snapshot[i.toString()], firstUser: widget.firstUser,
            secondUser: widget.secondUser, isFirstUser: widget.isFirstUser, isFirstUserTurn:
              widget.isFirstUserTurn, gameroomId: widget.gameroomId, boardIndex: i,)
      ],
    );
  }
}

// class Board {
//   QuerySnapshot<Map<String, dynamic>> snapshot;
//
//   Board({
//     required this.snapshot,
//   }) {
//   }
// }

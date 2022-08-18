import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_in_a_row/blocs/internet_cubit.dart';
import 'package:four_in_a_row/blocs/internet_cubit.dart';
import 'package:four_in_a_row/models/gameroom.dart';
import 'package:four_in_a_row/models/user.dart';
import 'package:four_in_a_row/services/database.dart';
import 'package:four_in_a_row/style/palette.dart';
import 'package:four_in_a_row/widgets/board_tile.dart';
import 'package:four_in_a_row/widgets/cancellable_dialog_box.dart';
import 'package:four_in_a_row/widgets/uncancellable_dialog_box.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

final usernameFormKey = GlobalKey<FormState>();
final opponentFormKey = GlobalKey<FormState>();

class _PlayScreenState extends State<PlayScreen> {
  bool _isUsernameRequired = false;
  bool _isOpponentRequired = false;
  BuildContext? dialogContext;
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController _opponentUsernameEditingController = TextEditingController();
  String? Function(String?) usernameValidator = (val) {
    return val!.isEmpty || val.length < 4
        ? "Please provide a longer username"
        : null;
  };

  @override
  Widget build(BuildContext context) {
    //BlocListener<InternetCubit, InternetState>(

    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Gameroom gameroom = Gameroom("musab", "musab2");
          // gameroom.getGameroomId();
          // gameroom.generateBoard();
        },
        child: Text(
            "Hello"
        ),
      ),
      backgroundColor: Palette().backgroundLevelSelection,
      body: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is InternetConnected && (state.connectionType == ConnectionType.WIFI
              || state.connectionType == ConnectionType.MOBILE)) {
            if (dialogContext != null) {
              Navigator.pop(dialogContext!);
            }
            //ScaffoldMessenger.of(context).removeCurrentSnackBar();
          } else if (state is InternetDisconnected) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  dialogContext = context;
                  return UncancellableDialogBox(title: 'Error', text: 'You do not have internet access');
                });
            // ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text("You are not connected to Wifi or Mobile!"),
            //       duration: Duration(days: 1000),
            //     )
            // );
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'FourInARow',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 55,
                      fontFamily: 'Watermelon Days'
                  ),
                ),
              ),
              _isUsernameRequired
                  ? _isOpponentRequired
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Form(
                  key: opponentFormKey,
                  child: TextFormField(
                    controller: _opponentUsernameEditingController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    validator: usernameValidator,
                    decoration: InputDecoration(
                      labelText: "Opponent's Username",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0)
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red, width: 0.0)
                      ),
                    ),
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Form(
                  key: usernameFormKey,
                  child: TextFormField(
                    controller: usernameEditingController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    validator: usernameValidator,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0)
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red, width: 0.0)
                      ),
                    ),
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isUsernameRequired = true;
                    });
                  },
                  child: const Text('Play'),
                ),
              ),
              _isUsernameRequired
                  ? _isOpponentRequired
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isOpponentRequired = false;
                      });
                    },
                    child: Container(
                        width: 50,
                        child: Center(child: const Text('Back'))
                    ),
                  ),
                  SizedBox(width: 30.0,),
                  ElevatedButton(
                    onPressed: () {
                      callback() {
                        setState(() {
                          _isOpponentRequired = true;
                        });
                      }
                      checkOpponent(opponentFormKey, usernameEditingController.text, _opponentUsernameEditingController, callback, context);
                      setState(() {
                        _isOpponentRequired = true;
                      });
                    },
                    child: Container(
                        width: 50,
                        child: Center(child: const Text('Submit'))
                    ),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isUsernameRequired = false;
                      });
                    },
                    child: Container(
                        width: 50,
                        child: Center(child: const Text('Back'))
                    ),
                  ),
                  SizedBox(width: 30.0,),
                  ElevatedButton(
                    onPressed: () {
                      callback() {
                        setState(() {
                          _isOpponentRequired = true;
                        });
                      }
                      signIn(usernameFormKey, usernameEditingController, callback);
                    },
                    child: Container(
                        width: 50,
                        child: Center(child: const Text('Submit'))
                    ),
                  ),
                ],
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

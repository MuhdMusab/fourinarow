import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UncancellableDialogBox extends StatefulWidget {
  final String title, text;

  const UncancellableDialogBox({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  _UncancellableDialogBoxState createState() => _UncancellableDialogBoxState();
}

class _UncancellableDialogBoxState extends State<UncancellableDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                maxLines: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black45,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );
  }
}
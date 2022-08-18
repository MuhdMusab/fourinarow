import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoubleOptionDialogBox extends StatefulWidget {
  final String title, text, firstOptionText, secondOptionText;
  final Function firstFunction;
  final Function secondFunction;

  const DoubleOptionDialogBox({
    Key? key,
    required this.title,
    required this.text,
    required this.firstFunction,
    required this.secondFunction,
    required this.firstOptionText,
    required this.secondOptionText,
  }) : super(key: key);

  @override
  _DoubleOptionDialogBoxState createState() => _DoubleOptionDialogBoxState();
}

class _DoubleOptionDialogBoxState extends State<DoubleOptionDialogBox> {
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
              SizedBox(height: 20,),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black45,
                ),
                maxLines: 1,
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      onPressed: () {
                        widget.firstFunction();
                      },
                      child: Text(
                        widget.firstOptionText,
                        style: TextStyle(fontSize: 24),
                      )),
                  FlatButton(
                      onPressed: () {
                        widget.secondFunction();
                      },
                      child: Text(
                        widget.secondOptionText,
                        style: TextStyle(fontSize: 24),
                      )),
                ],
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ],
    );
  }
}
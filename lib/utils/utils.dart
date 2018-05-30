import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lol_joke/model/user.dart';

void showMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    child: Dialog(
        child: Container(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          // new CircularProgressIndicator(),
          Container(
            // margin: const EdgeInsets.only(top: 10.0),
            child: Text(message),
          ),
        ],
      ),
    )),
  );

  new Future.delayed(new Duration(seconds: 1), () {
    Navigator.pop(context); //pop dialog
  });
}

void showSnackBarMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: new Text(message),
    backgroundColor: Colors.brown[900],
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

void toast(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Container(
        height: 100.0,
        color: Colors.transparent,
        child: Center(
          child: Container(
            color: Colors.transparent,
            child: Text(message),
          ),
        )),
    backgroundColor: Colors.transparent,
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

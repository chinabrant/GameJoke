import 'package:flutter/material.dart';

class GameJokeTheme {
  static final ThemeData themeBrown = ThemeData(
      primarySwatch: Colors.brown,
      scaffoldBackgroundColor: Colors.brown[50],
      indicatorColor: Colors.transparent,
      inputDecorationTheme: new InputDecorationTheme(
          isDense: false,
          isCollapsed: false,
          border: new OutlineInputBorder(
              borderRadius: new BorderRadius.all(Radius.zero),
              gapPadding: 2.0,
              borderSide: new BorderSide(
                color: Colors.brown[200],
                width: 0.5,
              ))));
}

import 'package:flutter/material.dart';
import './common/game_joke_theme.dart';
import './common/router_define.dart';
import './common/root_tab_page.dart';
import './model/user.dart';

void main() {

  

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: '游戏段子',
      theme: GameJokeTheme.themeBrown,
      home: RootTabPage(),
      routes: RouterDefine.routers,
    );
  }
}

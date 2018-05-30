import 'package:flutter/material.dart';
import 'package:lol_joke/home/home_page.dart';
import 'package:lol_joke/game/game_list_page.dart';
import 'package:lol_joke/me/mine_page.dart';
import 'package:lol_joke/model/game.dart';
import 'package:lol_joke/square/square_page.dart';
import 'dart:async';
import './widgets/image_tab.dart';

class RootTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RootTabPageState();
  }
}

class RootTabPageState extends State<RootTabPage> {
  int currentIndex = 0;
  final GlobalKey<GameListPageState> _gameListKey =
      GlobalKey<GameListPageState>();
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  @override
  Widget build(BuildContext context) {
    Widget root = Container(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  Offstage(
                    offstage: currentIndex != 0,
                    child: HomePage(
                      key: _homeKey,
                    ),
                  ),
                  Offstage(
                    offstage: currentIndex != 1,
                    child: SquarePage(),
                  ),
                  Offstage(
                    offstage: currentIndex != 2,
                    child: GameListPage(
                      key: _gameListKey,
                      callback: (Game game) {
                        setState(() {
                          currentIndex = 0;
                        });

                        HomePageState state = _homeKey.currentState;
                        if (state != null) {
                          state.switchGame(game);
                        } else {
                          print('state 为空');
                        }
                      },
                    ),
                  ),
                  Offstage(
                    offstage: currentIndex != 3,
                    child: MinePage(),
                  ),
                ],
              )),
          Container(
              height: 44.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                      top: const BorderSide(color: Color(0xffeaeaea)))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          tapTab(0);
                        },
                        child: Container(
                            child: ImageTab(
                          icon: Icons.home,
                          selected: this.currentIndex == 0,
                        ))),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          tapTab(1);
                        },
                        child: Container(
                            child: ImageTab(
                          icon: Icons.fiber_new,
                          selected: this.currentIndex == 1,
                        ))),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          tapTab(2);
                        },
                        child: Container(
                            child: ImageTab(
                          icon: Icons.videogame_asset,
                          selected: this.currentIndex == 2,
                        ))),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          tapTab(3);
                        },
                        child: Container(
                            child: ImageTab(
                          icon: Icons.supervisor_account,
                          selected: this.currentIndex == 3,
                        ))),
                  ),
                ],
              )),
        ],
      ),
    );

    return root;
  }

  void tapTab(int index) {
    setState(() {
      this.currentIndex = index;
    });
  }
}

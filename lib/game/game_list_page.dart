import 'package:flutter/material.dart';
import 'package:lol_joke/api/game_api.dart';
import 'dart:async';
import 'package:lol_joke/model/game.dart';
import './widgets/game_item_widget.dart';
import 'package:lol_joke/create_joke/joke_list_page.dart';

// 定义一个callback
typedef void GameListCallBack(Game game);

class GameListPage extends StatefulWidget {
  GameListPage({Key key, this.callback}) : super(key: key);

  GameListCallBack callback;

  @override
  State<StatefulWidget> createState() {
    return GameListPageState();
  }
}

class GameListPageState extends State<GameListPage> {
  ScrollController _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool isRefreshing = true;
  bool isNoMoreData = false;
  int page = 0;
  List<Game> list = <Game>[];

  @override
  void initState() {
    super.initState();

    _getData();

    // 加载更多控制
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !this.isRefreshing &&
          !this.isNoMoreData) {
        // 滑动到最底部了
        _getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, int index) => GameWidget(
              game: this.list[index],
              callback: widget.callback,
              detailCallBack: openJokeList),
          itemCount: this.list.length,
          controller: _scrollController,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('游戏列表'),
      ),
      body: body,
    );
  }

  // 下拉刷新 
  Future<Null> _refreshData() {
    this.page = 0;
    return _getData();
  }

  // 请求首页数据
  Future<Null> _getData() {
    this.isRefreshing = true;
    Completer<Null> completer = new Completer<Null>();
    GameApi.gameList(this.page).then((gameList) {
      if (this.page == 0) {
        list.removeRange(0, list.length);
      }

      this.page++;
      this.isRefreshing = false;

      if (gameList.length < GameApi.pageCount) {
        this.isNoMoreData = true;
      } else {
        this.isNoMoreData = false;
      }

      setState(() {
        list.addAll(gameList.getRange(0, gameList.length));
      });

      completer.complete(null);
    });

    return completer.future;
  }

  // 打开指定游戏的笑话列表页面
  void openJokeList(Game game) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return JokeListPage(
        game: game,
      );
    }));
  }
}

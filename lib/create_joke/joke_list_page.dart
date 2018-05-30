import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lol_joke/model/joke.dart';
import 'dart:async';
import 'package:lol_joke/api/joke_api.dart';
import '../model/user.dart';
import 'package:lol_joke/home/widgets/joke_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_joke/model/game.dart';
import 'package:lol_joke/home/widgets/no_game_widget.dart';
import 'package:lol_joke/common/router_define.dart';

/**
 * 首页
 */
class JokeListPage extends StatefulWidget {
  final Game game;
  JokeListPage({Key key, this.game}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new JokeListPageState();
  }
}

class JokeListPageState extends State<JokeListPage>
    with SingleTickerProviderStateMixin {
  List<Joke> list = <Joke>[];
  ScrollController _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool isRefreshing = true;
  bool isNoMoreData = false;
  int page = 0;

  // 请求首页数据
  Future<Null> _getData() {
    Completer<Null> completer = new Completer<Null>();

    this.isRefreshing = true;

    JokeApi.jokeList(this.page, widget.game).then((jokeList) {
      if (this.page == 0) {
        list.removeRange(0, list.length);
      }

      this.page++;
      this.isRefreshing = false;

      if (jokeList.length < 10) {
        this.isNoMoreData = true;
      } else {
        this.isNoMoreData = false;
      }

      setState(() {
        list.addAll(jokeList.getRange(0, jokeList.length));
      });

      completer.complete(null);
    });

    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _getData();

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

  Future<Null> _refreshData() {
    this.page = 0;
    return _getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = new Scaffold(
      appBar: new AppBar(
        title: Text(widget.game.name),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.create), onPressed: _onPressedCreate),
        ],
      ),
      body: new Container(
        child: new RefreshIndicator(
          key: _refreshIndicatorKey,
          child: new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, int index) => _createItem(index),
            itemCount: this.list.length + 1,
            controller: _scrollController,
          ),
          onRefresh: _refreshData,
        ),
      ),
    );

    return scaffold;
  }

  _createItem(int index) {
    if (index >= this.list.length) {
      String text = '- 游戏段子 -';
      if (!this.isNoMoreData) {
        text = '加载中...';
      }

      return new Container(
        height: 60.0,
        child: new Center(
          child: new Text(
            text,
            style: new TextStyle(color: Color(0xff999999)),
          ),
        ),
      );
    }

    Joke joke = this.list[index];

    return JokeWidget(joke: joke);
  }

  // 点击创建
  void _onPressedCreate() {
    
      if (!User.isLogin()) {
        Navigator.of(context).pushNamed('/login/login');
      } else {
        RouterDefine.pushCreateJoke(context, widget.game);
      }

  }
}

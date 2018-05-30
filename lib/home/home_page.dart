import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../model/joke.dart';
import 'dart:async';
import '../api/joke_api.dart';
import '../model/user.dart';
import './widgets/joke_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/game.dart';
import './widgets/no_game_widget.dart';
import 'package:lol_joke/common/widgets/refresh_list_view.dart';
import 'package:lol_joke/common/widgets/joke_empty_widget.dart';
import 'package:lol_joke/common/widgets/no_more_data_widget.dart';
import 'package:lol_joke/common/widgets/loading_more_widget.dart';
import 'package:lol_joke/common/router_define.dart';

/**
 * 首页
 */
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Joke> list = <Joke>[];

  final GlobalKey<RefreshListViewState> _refreshListViewKey =
      GlobalKey<RefreshListViewState>();
  final ScrollController scrollController = ScrollController();

  bool isRefreshing = true;
  bool isNoMoreData = false;
  int page = 0;
  Game currentGame;
  bool noGame = false;

  // 切换游戏
  void switchGame(Game game) {
    game.save();
    this.currentGame = game;
    setState(() {
      this.noGame = false;
      this.isNoMoreData = false;
    });
    // print('切换游戏');

    // _refreshListViewKey.currentState.beginRefresh();
    _refreshData();
  }

  // 请求首页数据
  Future<Null> _getData() {
    Completer<Null> completer = new Completer<Null>();

    this.isRefreshing = true;
    // print('开始读取首页数据 ');
    JokeApi.jokeList(this.page, this.currentGame).then((jokeList) {
      if (this.page == 0) {
        list.removeRange(0, list.length);
      }

      // print('首页数据返回成功${jokeList}');

      this.page++;
      this.isRefreshing = false;
      this.isNoMoreData = jokeList.length < 10;

      setState(() {
        list.addAll(jokeList.getRange(0, jokeList.length));
      });

      completer.complete(null);
    });

    return completer.future;
  }

  void _loadMoreData() {
    if (!this.isNoMoreData && !this.isRefreshing) {
      _getData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    User.loadUserFromCache().then((user) {
    if (user != null && user.objectId != null) {
      User.currentUser = user;
    }
  });

    Game.currentGame().then((game) {
      if (game != null && game.objectId != null) {
        this.currentGame = game;
        print('有选择：${game.objectId}');
        _getData();
      } else {
        print('没有选择');
        // 没有选择游戏
        setState(() {
          this.noGame = true;
        });
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
          titleSpacing: 8.0, // title左边的间隔
          title: createTitle(),
          // elevation: 0.0,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.create),
              onPressed: () {
                // 创建段子

                if (!User.isLogin()) {
                  Navigator.of(context).pushNamed('/login/login');
                } else {
                  // Navigator.of(context).pushNamed('/joke/create');
                  RouterDefine.pushCreateJoke(context, this.currentGame);
                }

                // Navigator.of(context).pushNamed('/login/login');
              },
            ),
          ],
        ),
        body: body());

    if (this.noGame) {
      return NoGameWidget();
    } else {
      return scaffold;
    }
  }

  Widget body() {
    return Container(
      child: RefreshListView(
        key: _refreshListViewKey,
        onRefreshCallback: _refreshData,
        loadMoreCallback: () {
          _loadMoreData();
        },
        listView: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, int index) => _createItem(index),
          itemCount: list.length + 1,
          controller: scrollController,
        ),
        // onRefresh: _refreshData,
      ),
    );
  }

  _createItem(int index) {
    if (this.isNoMoreData && list.length == 0) {
      // 如果没有更多数据了，且列表数据为空，则显示空页面

      return JokeEmptyWidget();
    } else if (this.isNoMoreData && index == this.list.length - 1) {
      // 没有更多数据了。要显示底部的无更多数据view
      Joke joke = this.list[index];
      return Column(
        children: <Widget>[
          JokeWidget(
            joke: joke,
          ),
          NoMoreDataWidget(),
        ],
      );
    } else if (index == this.list.length - 1 && this.page != 0) {
      // 不是第一页的时候，最后一条数据，要显示正在加载更多
      Joke joke = this.list[index];
      return Column(
        children: <Widget>[
          JokeWidget(
            joke: joke,
          ),
          LoadingMoreWidget(),
        ],
      );
    } else if (index == list.length) {
      // 最后一行
      return Divider(
        height: 0.5,
        color: Theme.of(context).scaffoldBackgroundColor,
      );
    }

    Joke joke = this.list[index];
    return JokeWidget(joke: joke);
  }

  Widget createTitle() {
    if (this.currentGame != null) {
      return Container(
          child: Row(
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            color: Color(0xffefefef),
            margin: const EdgeInsets.only(right: 10.0),
            child: CachedNetworkImage(
              imageUrl: this.currentGame.logo.url,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            this.currentGame.name,
            style: TextStyle(fontSize: 15.0),
          )
        ],
      ));
    } else {
      return Text('首页');
    }
  }

  // 点击创建
  void _onPressedCreate() {
    if (!User.isLogin()) {
      Navigator.of(context).pushNamed('/login/login');
    } else {
      RouterDefine.pushCreateJoke(context, this.currentGame);
    }
  }
}

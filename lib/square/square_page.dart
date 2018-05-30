import 'package:flutter/material.dart';
import 'package:lol_joke/common/widgets/refresh_list_view.dart';
import 'package:lol_joke/common/widgets/joke_empty_widget.dart';
import 'package:lol_joke/common/widgets/no_more_data_widget.dart';
import 'package:lol_joke/common/widgets/loading_more_widget.dart';
import 'dart:async';
import 'package:lol_joke/home/widgets/joke_widget.dart';
import 'package:lol_joke/model/joke.dart';
import 'package:lol_joke/api/joke_api.dart';

/// 第二个tab，广场页面
class SquarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SquarePageState();
  }
}

class SquarePageState extends State<SquarePage> {

  final GlobalKey<RefreshListViewState> _refreshListViewKey =
     GlobalKey<RefreshListViewState>();

  final ScrollController scrollController = ScrollController();

  bool isNoMoreData = false;  // 是否还有下一页
  bool isRefreshing = false;  // 是否正在刷新 
  List<Joke> list = List<Joke>();   // 列表数据 
  int page = 0;               // 当前页码 

  @override
  void initState() {
    super.initState();

    // _refreshListViewKey.currentState.beginRefresh();
    _refreshData();
  }

  /// 下拉刷新 
  Future<Null> _refreshData() {
    this.page = 0;
    return _getData();
  }

  // 请求列表数据
  Future<Null> _getData() {
    this.isRefreshing = true;
    Completer<Null> completer = Completer<Null>();
    JokeApi.allJokeList(this.page).then((jokeList) {
      if (jokeList != null) {
        // 下拉刷新，要清掉原来的数据 
        if (this.page == 0) {
          list.removeRange(0, list.length);
        }

        this.page++;

        if (jokeList.length < JokeApi.pageCount) {
          this.isNoMoreData = true;
        } else {
          this.isNoMoreData = false;
        }

        setState(() {
          list.addAll(jokeList.getRange(0, jokeList.length));
        });
      }

      this.isRefreshing = false;
      completer.complete(null);
    });

    return completer.future;
  }

  // 加载更多
  void _loadMoreData() {
    if (!this.isNoMoreData && !this.isRefreshing) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }

  Widget appBar() {
    return AppBar(
      title: Text('广场'),
    );
  }

  Widget body() {
    return new Container(
      child: RefreshListView(
        key: _refreshListViewKey,
        onRefreshCallback: _refreshData,
        loadMoreCallback: _loadMoreData,
        listView: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, int index) => createItem(list[index], index),
          itemCount: list.length,
          controller: scrollController,
        ),
      ),
    );
  }

  Widget createItem(Joke joke, int index) {
    if (this.isNoMoreData && list.length == 0) {
      // 如果没有更多数据了，且列表数据为空，则显示空页面
      return JokeEmptyWidget();
    } else if (this.isNoMoreData) {
      // 没有更多数据了。要显示底部的无更多数据view
      return Column(
        children: <Widget>[
          JokeWidget(
            joke: joke,
          ),
          NoMoreDataWidget()
        ],
      );
    } else if (index == this.list.length - 1) {
      // 最后一条数据，要显示正在加载更多
      return Column(
        children: <Widget>[
          JokeWidget(
            joke: joke,
          ),
          LoadingMoreWidget()
        ],
      );
    }

    return JokeWidget(joke: joke, game: joke.game,);
  }
}

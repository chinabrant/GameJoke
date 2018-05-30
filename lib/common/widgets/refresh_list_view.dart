import 'package:flutter/material.dart';
import 'dart:async';

typedef Future<Null> RefreshListViewOnRefreshCallback();
typedef void LoadMoreCallback(); // 滑动到达底部了

/// 传进来的ListView初始化时，必须指定一个Controller
class RefreshListView extends StatefulWidget {
  RefreshListView(
      {Key key,
        @required this.listView,
      this.onRefreshCallback,
      this.offset,
      this.loadMoreCallback,
      this.pullToRefresh = true}): super(key: key);

  ListView listView;
  double offset = 0.0; // 距离底部还有多少距离时开始刷新，默认为0，要完全到底部才开始刷新
  bool pullToRefresh = true; // 是否开启下拉刷新, 默认为true

  RefreshListViewOnRefreshCallback onRefreshCallback;
  LoadMoreCallback loadMoreCallback;

  @override
  State<StatefulWidget> createState() {
    return RefreshListViewState();
  }
}

class RefreshListViewState extends State<RefreshListView> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  void beginRefresh() {
    refreshIndicatorKey.currentState.show();
  }

  @override
  void initState() {
    // 监听ListView是否滑动到底部
    widget.listView.controller.addListener(() {

      if (widget.listView.controller.position.pixels ==
          widget.listView.controller.position.maxScrollExtent) {

        // 滑动到最底部了
        if (widget.loadMoreCallback != null) {
          widget.loadMoreCallback();
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pullToRefresh) {
      // 开启下拉刷新时，onRefreshCallback不能为空
      // assert(widget.onRefreshCallback != null);
      return RefreshIndicator(
        key: refreshIndicatorKey,
        child: widget.listView,
        onRefresh: widget.onRefreshCallback,
      );
    } else {
      return widget.listView;
    }
  }
}



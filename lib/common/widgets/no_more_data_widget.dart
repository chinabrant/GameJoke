import 'package:flutter/material.dart';

/// 列表没有更多数据了，底部显示的view
class NoMoreDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String text = '- 游戏段子 -';

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
}

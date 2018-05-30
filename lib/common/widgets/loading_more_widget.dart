import 'package:flutter/material.dart';

class LoadingMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String text = '正在加载...';

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
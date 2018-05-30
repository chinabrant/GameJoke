import 'package:flutter/material.dart';

class LogoutCell extends StatelessWidget {
  VoidCallback logoutCallback;

  LogoutCell({this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: this.logoutCallback,
            child: Container(
              height: 50.0,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
              color: Colors.brown,
              child: Center(
                  child: Text(
                '退出登录',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              )),
            )));
  }
}

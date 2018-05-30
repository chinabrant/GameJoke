import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/user.dart';

class UserInfoCell extends StatefulWidget {
  VoidCallback onTap;

  UserInfoCell({this.onTap});

  @override
  State<StatefulWidget> createState() {
    return UserInfoCellState();
  }
}

class UserInfoCellState extends State<UserInfoCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String nick = '点击登录';
    if (User.isLogin()) {
      nick = User.currentUser.nick == null
          ? User.currentUser.username
          : User.currentUser.nick;
    }

    Widget con = Container(
      color: Colors.brown,
      height: 150.0,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 20.0),
            width: 80.0,
            height: 80.0,
            child: avatar(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 15.0, top: 50.0),
                  child: Text(nick,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          decoration: TextDecoration.none)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15.0, top: 5.0),
                  child: Text(
                    '游戏人生',
                    style: TextStyle(color: Color(0xff999999), fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      child: con,
      onTap: widget.onTap,
    );
  }

  // 头像
  Widget avatar() {
    if (User.isLogin()) {
      // 登录了
      if (User.currentUser.avatar != null) {
        return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            child: CachedNetworkImage(
              imageUrl: User.currentUser.avatar.url,
              fit: BoxFit.fill,
            ));
      } else {
        return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            child: Container(
              color: Colors.brown[300],
              child: Center(
                child: Text('无头像'),
              ),
            ));
      }
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
          child: Container(
            color: Colors.brown[300],
            child: Center(
              child: Text('未登录'),
            ),
          ));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_joke/model/game.dart';
import 'package:lol_joke/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 定义一个callback
typedef void GameListCallBack(Game game);
// 打开笑话 列表
typedef void GameDetailCallBack(Game game);

/// 首页joke的widget
class GameWidget extends StatelessWidget {
  Game game;

  GameWidget({this.game, this.callback, this.detailCallBack });
  GameListCallBack callback;
  GameDetailCallBack detailCallBack;

  @override
  Widget build(BuildContext context) {
    // 图片
    Widget image = null;
    if (game.logo != null) {
      image = Container(
        color: Color(0xffefefef),
        child: CachedNetworkImage(
          imageUrl: game.logo.url,
          fit: BoxFit.fill,
        ),
      );
    }

    // 文字
    Widget text = null;
    if (game.name != null && game.name != '') {
      text = Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Text(
          '${game.name}',
          style: TextStyle(fontSize: 17.0, color: Colors.brown[700]),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // this.callback(this.game);
        if (this.detailCallBack != null) {
          this.detailCallBack(this.game);
        }
      },
      child: Card(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child:  Container(
          width: 50.0,
          height: 80.0,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                height: 50.0,
                width: 50.0,
                margin: const EdgeInsets.only(left: 10.0),
                child: image,
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 17.0, left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        game.name,
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        game.desc,
                        style:
                            TextStyle(fontSize: 12.0, color: Color(0xff999999)),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: FlatButton(
                  onPressed: () {
                    this.callback(this.game);
                  },
                  color: Colors.brown[500],
                  child: Text('设为首页', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          )),
    ));
  }
}

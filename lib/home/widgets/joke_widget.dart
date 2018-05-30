import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lol_joke/model/joke.dart';
import 'package:lol_joke/model/user.dart';
import 'package:lol_joke/model/game.dart';

/// 首页joke的widget
class JokeWidget extends StatelessWidget {
  Joke joke;
  Game game;

  JokeWidget({this.joke, this.game});

  @override
  Widget build(BuildContext context) {
    // 图片
    Widget image = null;
    if (joke.image != null) {
      image = Container(
        color: Color(0xffefefef),
        child: AspectRatio(
          aspectRatio: joke.image.imageRatio(),
          child: CachedNetworkImage(
            imageUrl: joke.image.url,
            fit: BoxFit.fill,
          ),
        ),
      );
    }

    // 文字
    Widget text = null;
    if (joke.content != null && joke.content != '') {
      text = Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Text(
          '${joke.content}',
          style: TextStyle(fontSize: 17.0, color: Colors.brown[700]),
        ),
      );
    }

    // 时间
    DateTime date = joke.createdAt;
    // yyyy-MM-dd HH:mm:ss
    String timestamp =
        "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    if (image == null && text == null) {
      return Text('...');
    } else if (image == null) {
      // 只有文字
      return this.container([
        this.userHeader(joke.user, timestamp),
        text,
        Divider(
          height: 10.0,
          color: Colors.white,
        ),
      ]);
    } else if (text == null) {
      // 只有图片
      return this.container([this.userHeader(joke.user, timestamp), image]);
    } else {
      // 有图片也有文字
      return this.container([
        this.userHeader(joke.user, timestamp),
        image,
        Divider(
          height: 10.0,
          color: Colors.white,
        ),
        text,
        Divider(
          height: 10.0,
          color: Colors.white,
        ),
      ]);
    }
  }

  Widget gameLogo() {
    if (this.game != null && this.game.logo != null) {
      return Container(
        color: Colors.brown,
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0, bottom: 3.0),
        // height: 20.0,
        child: Text(this.game.name, style: TextStyle(color: Colors.white, fontSize: 12.0),),
        // CachedNetworkImage(
        //   imageUrl: this.game.logo.url != null ? this.game.logo.url : '',
        //   fit: BoxFit.fill,
        // ),
      );
    } else {
      return Text('');
    }
  }

  Widget userHeader(User user, String time) {
    if (user == null) {
      user = User();
    }

    if (user.nick == null) {
      user.nick = user.username == null ? '无名小编' : user.username;
    }

    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      height: 60.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 头像
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            width: 40.0,
            height: 40.0,
            child: avatar(),
          ),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      user.nick,
                      style: TextStyle(color: Colors.brown, fontSize: 16.0),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.white,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${time}',
                        style: TextStyle(
                            color: Color(0xff999999), fontSize: 12.0)),
                  ),
                ],
              ),
            ),
          ),
          gameLogo()
        ],
      ),
    );
  }

  Widget avatar() {
    if (joke.user != null && joke.user.avatar != null) {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: CachedNetworkImage(
            imageUrl: joke.user.avatar.url,
            fit: BoxFit.fill,
          ));
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color: Colors.brown[300],
            child: Center(
              child: Text('^V^'),
            ),
          ));
    }
  }

  Widget container(List<Widget> widgets) {
    return Card(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child:  Container(
      color: Colors.white,
      
      child: Column(
        children: widgets,
      ),
    ));
  }
}

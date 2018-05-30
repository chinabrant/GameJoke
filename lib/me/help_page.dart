import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * 关于我们页面
 */
class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('关于LOL段子'),
          // elevation: 0.0,
        ),
        body: new Builder(builder: (BuildContext context) {
          return new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new Text(
                        '游戏的欢乐只有我们自己懂',
                        // '开发中...', //'LOL段子是一个记录LOL相关搞笑段子的APP，作者也是一个LOL有好者，如果大家有什么好的建议或意见可以发送到我的邮箱。\n\n',
                        style: new TextStyle(
                            fontSize: 18.0, color: Colors.brown[600]),
                      )),
                  _qun(context),
                  _line(),
                  _version(context),
                ],
              ));
        }));
  }

  Widget _qun(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          Clipboard.setData(new ClipboardData(text: '97039265'));
          Scaffold.of(context).showSnackBar(new SnackBar(
                backgroundColor: Colors.brown[500],
                content: new Text("97039265\n复制成功"),
              ));
        },
        child: Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 15.0),
                // padding: const EdgeInsets.only(top: 7.0),
                color: Colors.white,
                height: 35.0,
                child: Container(
                  margin: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'QQ群：97039265 (点击复制QQ群号)',
                    style:
                        new TextStyle(fontSize: 15.0, color: Colors.brown[600]),
                  ),
                ))));
  }

  Widget _version(BuildContext context) {
    return Card(
        child: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15.0),
      // padding: const EdgeInsets.only(top: 7.0),
      color: Colors.white,
      height: 35.0,
      child: Container(
          margin: const EdgeInsets.only(
            left: 15.0,
          ),
          child: Text(
            'v1.0.0',
            style: new TextStyle(fontSize: 15.0, color: Colors.brown[600]),
          )),
    ));
  }

  Widget _email(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(new ClipboardData(text: '812662025@qq.com'));
        Scaffold.of(context).showSnackBar(new SnackBar(
              backgroundColor: Colors.brown[500],
              content: new Text("812662025@qq.com\n复制成功"),
            ));
      },
      child: new Text(
        '我的邮箱：812662025@qq.com (点击复制邮箱) \n\n',
        style: new TextStyle(fontSize: 18.0, color: Colors.brown[600]),
      ),
    );
  }

  Widget _line() {
    return Divider(
      color: Color(0xffefefef),
      height: 0.5,
    );
  }
}

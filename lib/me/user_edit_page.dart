import 'package:flutter/material.dart';
import 'package:lol_joke/model/user.dart';
import '../api/user_api.dart';
import 'package:lol_joke/utils/utils.dart';
import 'package:lol_joke/api/response_result.dart';
import 'dart:async';

/// 编辑修改用户信息的页面
/// 后面修改的类型增加，可能得添加一个修改的类型传进来
class UserEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserEditPageState();
  }
}

class UserEditPageState extends State<UserEditPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (User.isLogin()) {
      textEditingController.text = User.currentUser.nick;
    } else {
      print('当前用户为空');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: AppBar(
        title: Text('修改用户名'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: () {
              if (User.currentUser.nick != textEditingController.text &&
                  textEditingController.text.length >= 3 &&
                  textEditingController.text.length <= 12) {
                UserApi
                    .updateUserNick(textEditingController.text)
                    .then((result) {
                  if (result.status == HttpStatus.ok) {
                    showMessage(context, '修改成功');
                    new Future.delayed(new Duration(seconds: 1), () {
                      Navigator.pop(context); //pop dialog
                    });
                  }
                });
              } else {
                showMessage(context, '昵称必须在3到12个字符之间');
              }
            },
          ),
        ],
      ),
      body: _body(),
    );

    return scaffold;
  }

  Widget _body() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 150.0),
          child: TextField(
            controller: textEditingController,
          ),
        ));
  }
}

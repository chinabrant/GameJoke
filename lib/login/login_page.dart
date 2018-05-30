import 'package:flutter/material.dart';
import '../api/user_api.dart';
import 'package:lol_joke/utils/utils.dart';
import '../model/user.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 50.0, right: 50.0, top: 50.0),
                        child: TextField(
                            controller: _usernameController,
                            maxLength: 12,
                            decoration: InputDecoration(
                                labelText: '用户名',
                                contentPadding: const EdgeInsets.all(12.0))),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 50.0, right: 50.0, top: 30.0),
                        child: TextField(
                          controller: _pwdController,
                          maxLength: 20,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: '密码',
                              contentPadding: const EdgeInsets.all(12.0)),
                        ),
                      ),
                      Container(
                        child: new Row(
                          children: <Widget>[
                            // 注册
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 44.0,
                                margin: const EdgeInsets.only(
                                    left: 50.0, right: 20.0, top: 30.0),
                                color: Colors.brown[500],
                                child: FlatButton(
                                  onPressed: register,
                                  child: Center(
                                      child: Text('注 册',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0))),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: // 登录
                                  Container(
                                height: 44.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 50.0, top: 30.0),
                                color: Colors.brown[500],
                                child: FlatButton(
                                  onPressed: () {
                                    login(context);
                                  },
                                  child: Center(
                                      child: Text('登 录',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }

  void register() {
    Navigator.of(context).pushNamed('/login/reg');
  }

  void login(BuildContext context) {
    UserApi
        .login(this._usernameController.text, this._pwdController.text)
        .then((user) {
      if (user != null) {
        print('登录返回数据: $user');

        // showSnackBarMessage(context, '登录成功');
        showMessage(context, '登录成功');
        new Future.delayed(new Duration(seconds: 1), () {
          Navigator.pop(context); //pop dialog
        });
      }
      else {
        showMessage(context, '登录失败');
      }
    });
  }
}

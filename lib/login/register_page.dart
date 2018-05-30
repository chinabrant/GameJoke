import 'package:flutter/material.dart';
import 'package:lol_joke/api/user_api.dart';
import 'package:lol_joke/utils/utils.dart';
import 'dart:async';
import '../api/response_result.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('注册'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
                  child: TextField(
                      controller: _usernameController,
                      maxLength: 12,
                      decoration: InputDecoration(
                          labelText: '用户名',
                          contentPadding: const EdgeInsets.all(12.0))),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0),
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
                  height: 50.0,
                  margin:
                      const EdgeInsets.only(left: 50.0, right: 50.0, top: 30.0),
                  color: Colors.brown[500],
                  child: FlatButton(
                    onPressed: register,
                    child: Center(
                        child: Text('注 册',
                            style: TextStyle(
                                color: Colors.white, fontSize: 17.0))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // 点击注册
  void register() {
    if (_usernameController.text.length < 6 || _pwdController.text.length < 6) {
      // 用户名和密码必须大于6位
      showMessage(context, '用户名和密码必须大于6位');
      return;
    }

    UserApi
        .register(_usernameController.text, _pwdController.text)
        .then((result) {
      if (result.status == HttpStatus.ok) {
        // 注册成功
        showMessage(context, '注册成功,请登录');
        new Future.delayed(new Duration(seconds: 1), () {
          Navigator.pop(context); //pop dialog
        });
      }
      else {
        showMessage(context, '注册失败');
      }

    });
  }
}

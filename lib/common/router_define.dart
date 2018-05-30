import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lol_joke/home/home_page.dart';
import 'package:lol_joke/me/help_page.dart';
import 'package:lol_joke/create_joke/create_joke_page.dart';
import 'package:lol_joke/login/register_page.dart';
import 'package:lol_joke/login/login_page.dart';
import 'package:lol_joke/create_joke/joke_list_page.dart';
import 'package:lol_joke/model/game.dart';
import 'package:lol_joke/me/user_settings_page.dart';
import 'package:lol_joke/common/image_edit_page.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:lol_joke/me/user_edit_page.dart';

// 路由管理类
class RouterDefine {
  // 首页
  static final home = '/home';
  // 关于我们
  static final aboutus = '/me/aboutus';
  // 创建笑话
  static final createJoke = '/joke/create';
  // 注册
  static final register = '/login/reg';
  // 登录
  static final login = '/login/login';
  // 游戏列表
  static final gameList = '/game/index';
  // 笑话列表
  static final jokeList = '/joke/list';
  // 用户信息
  static final userInfo = '/me/userinfo';
  // 修改用户信息
  static final userEdit = '/me/useredit';

  static final routers = <String, WidgetBuilder>{
    RouterDefine.home: (_) => HomePage(),
    RouterDefine.aboutus: (_) => HelpPage(),
    // RouterDefine.createJoke: (_) => CreateJokePage(),
    RouterDefine.register: (_) => RegisterPage(),
    RouterDefine.login: (_) => LoginPage(),
    RouterDefine.userInfo: (_) => UserSettingsPage(),
    RouterDefine.userEdit: (_) => UserEditPage(),
  };

  static pushCreateJoke(BuildContext context, Game game) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return CreateJokePage(game: game);
    }));
  }

  static Future<ui.Image> pushImageEidt(BuildContext context, File imageFile) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return ImageEditPage(image: FileImage(imageFile));
    }));
  }
}

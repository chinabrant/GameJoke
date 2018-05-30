import 'av_object.dart';
import 'user.dart';
import 'av_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

/*
* 游戏 model
* */
class Game extends AVObject {

  static Game _currentGame;

  static final String gameNameKey = 'current_game_name';
  static final String gameDescKey = 'current_game_desc';
  static final String gameLogoUrlKey = 'current_game_logo_url';
  static final String gameObjectIdKey = 'current_game_objectid';

  String name;       // 标题
  AVFile logo;       // 封面图片
  String desc;  /// 一句话描述

  Game({
    this.name,
    this.logo,
  });

  Game.fromMap(Map<String, dynamic> map) : super.fromMap(map) {

    if (map == null) {
      return;
    }
    
    this.logo = map['logo'] != null ? new AVFile.fromMap(map['logo']) : null;
    this.name = map['name'];
    this.desc = map['desc'];
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(gameObjectIdKey, this.objectId);
    prefs.setString(gameNameKey, this.name);
    prefs.setString(gameDescKey, this.desc);
    prefs.setString(gameLogoUrlKey, this.logo.url);
  }

  static Future<Game> currentGame() async {

    if (Game._currentGame != null) {
      return Game._currentGame;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Game game = Game();
    game.objectId = prefs.getString(gameObjectIdKey);
    game.name = prefs.getString(gameNameKey);
    game.desc = prefs.getString(gameDescKey);
    String url = prefs.getString(gameLogoUrlKey);
    if (url != null) {
      AVFile file = AVFile(url: url);
      game.logo = file;

    }

    if (game.objectId != null) {
      Game._currentGame = game;
    }
    
    return Game._currentGame;
  }
}
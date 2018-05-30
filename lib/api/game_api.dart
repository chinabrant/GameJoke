import 'package:flutter/material.dart';
import 'base_api.dart';
import 'dart:async';
import 'package:lol_joke/model/game.dart';

class GameApi extends BaseApi {

  // 每一页的数量 
  static final int pageCount = 10;

  /*
  * 读取列表
  * */
  static Future<List> gameList(int page) {
    String path = '/1.1/classes/Game';
    Map<String, String> params = {
      'include': 'logo',
      'limit': '${GameApi.pageCount}',
      'skip': '${page * GameApi.pageCount}',
      'order': '-createdAt'
    };
    return BaseApi.get(path, params).then((result) {
      List<Game> list = <Game>[];

      Map map = result.jsonResult;
      List arr = map['results'];
      for (var i = 0; i < arr.length; i++) {
        Game model = new Game.fromMap(arr[i]);
        list.add(model);
      }

      return list;
    });
  }
}
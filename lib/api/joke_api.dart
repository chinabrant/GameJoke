import 'dart:convert';
import 'dart:async';
import 'base_api.dart';
import 'package:lol_joke/model/joke.dart';
import 'package:lol_joke/model/user.dart';
import 'package:lol_joke/model/game.dart';
import './response_result.dart';

class JokeApi extends BaseApi {
  // 每一页的数量
  static final int pageCount = 10;

  /*
  * 读取详情
  * */
  static Future<Joke> jokeDetail(String objectId) {
    String path = "/1.1/classes/Joke/${objectId}";
    return BaseApi.get(path, null).then((result) {
      Map map = result.jsonResult;
      Joke model = new Joke.fromMap(map);
      return model;
    });
  }

  static Future<List> updateJoke(Joke joke) {
    String path = '/1.1/classes/Joke/${joke.objectId}';
    String params = '\{\"hidden\":false\}';
    BaseApi.put(path, params, '');
  }

  /*
  * 读取列表
  * */
  static Future<List> allJokeList(int page) {
    String path = '/1.1/classes/Joke';
    Map<String, String> params = {
      'include': 'image,game,user',
      'limit': '10',
      'skip': '${page*10}',
      'order': '-createdAt',
      'where': '\{\"hidden\":false\}'
    };
    return BaseApi.get(path, params).then((result) {
      List<Joke> list = <Joke>[];
      Map map = result.jsonResult;
      List arr = map['results'];
      for (var i = 0; i < arr.length; i++) {
        Joke model = new Joke.fromMap(arr[i]);
        // list.insert(0, model);
        // updateJoke(model);
        list.add(model);
      }

      return list;
    });
  }

  /*
  * 读取列表
  * */
  static Future<List> jokeList(int page, Game game) {
    String path = '/1.1/classes/Joke';
    Map<String, String> params = {
      'include': 'image,user',
      'limit': '10',
      'skip': '${page*10}',
      'order': '-createdAt',
      // 'where': BaseApi.whereDesc('game', 'Game', game.objectId)
      'where': '\{\"game\":${BaseApi.objectDesc('Game', game.objectId)}, \"hidden\":false\}'
    };
    return BaseApi.get(path, params).then((result) {
      List<Joke> list = <Joke>[];
      Map map = result.jsonResult;
      List arr = map['results'];
      for (var i = 0; i < arr.length; i++) {
        Joke model = new Joke.fromMap(arr[i]);
        // list.insert(0, model);
        list.add(model);
      }

      return list;
    });
  }

  /**
   * 创建段子
   */
  static Future createJoke(String content, String imageObjectId, Game game) {
    String path = '/1.1/classes/Joke';
    String params;
    if (content != null && imageObjectId != null) {
      params =
          '\{\"content\" : \"${content}\", \"game\":${BaseApi.objectDesc('Game', game.objectId)} , \"image\":\{ \"id\": \"${imageObjectId}\", \"__type\": \"File\"\}, \"type\": 1, \"user\":${BaseApi.objectDesc('_User', User.currentUser.objectId)}\}';
    } else if (content != null) {
      params =
          '\{\"content\" : \"${content}\", \"game\":${BaseApi.objectDesc('Game', game.objectId)} , \"type\": 0, \"user\":${BaseApi.objectDesc('_User', User.currentUser.objectId)} \}';
    } else {
      params =
          '\{ \"game\":${BaseApi.objectDesc('Game', game.objectId)} ,\"image\": \{ \"id\": \"${imageObjectId}\", \"__type\": \"File\"\}, \"type\": 1, \"user\":${BaseApi.objectDesc('_User', User.currentUser.objectId)} }';
    }

    return BaseApi.post(path, params).then((result) {
      return result.jsonResult;
    });
  }
}

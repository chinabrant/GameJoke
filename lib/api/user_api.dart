import 'base_api.dart';
import 'dart:convert';
import 'dart:async';
import '../model/user.dart';
import './response_result.dart';

class UserApi extends BaseApi {
  /// 注册用户
  static Future register(String username, String password) {
    String path = '/1.1/users';
    String params =
        '\{\"username\":\"${username}\",\"password\":\"${password}\"\}';

    return BaseApi.post(path, params).then((result) {
      return result;
    });
  }

  /// 用户登录
  static Future<User> login(String username, String password) {
    String path = '/1.1/login';
    String params =
        '\{\"username\":\"${username}\",\"password\":\"${password}\"\}';

    return BaseApi.post(path, params).then((result) {
      if (result.status == HttpStatus.ok) {
        User user = User.fromMap(result.jsonResult);
        // 把用户数据缓存一下
        User.saveUserBody(result.body);
        User.currentUser = user;
        return user;
      }
      else {
        return null;
      }
      
    });
  }

  /// 更新用户昵称
  static Future<ResponseResult> updateUserNick(String nick) {
    String path = '/1.1/users/${User.currentUser.objectId}';
    String params = '\{\"nick\":\"${nick}\"\}';
    return BaseApi
        .put(path, params, User.currentUser.sessionToken)
        .then((result) {
      if (result.status == HttpStatus.ok) {
        User.currentUser.nick = nick;
        refreshUserInfo();
      }
      return result;
    });
  }

  /// 更新用户头像
  static Future updateUserAvatar(
      String userid, String imageObjectId, String session) {
    print('====================');
    print('userId: $userid  session: $session');
    String path = '/1.1/users/$userid';
    String params =
        '\{\"avatar\":\{ \"id\": \"${imageObjectId}\", \"__type\": \"File\"\}\}';
    return BaseApi.put(path, params, session).then((result) {
      return result.jsonResult;
    });
  }

  static Future refreshUserInfo() {
    String path = '/1.1/users/me';

    print('刷新：${User.currentUser.sessionToken}');
    return BaseApi
        .get(path, null, User.currentUser.sessionToken)
        .then((result) {
      if (result.status == HttpStatus.ok) {
        print('用户数据刷新成功:${result.jsonResult}');
        // 请求成功
        User user = User.fromMap(result.jsonResult);
        if (user != null && user.objectId != null) {
          User.saveUserBody(result.body);
          User.currentUser = user;
        }

        return user;
      }

      print('用户数据刷新失败${result.body}    ${result.response.statusCode}');
      return null;
    });
  }

  /// 刷新用户的登录session
  static Future<User> refreshSessionToken() {
    try {
      String path =
          '/1.1/users/${User.currentUser.objectId}/refreshSessionToken';
      String params = '';
      return BaseApi
          .put(path, params, User.currentUser.sessionToken)
          .then((result) {
        print('刷新的用户数据：${result.jsonResult}');
        User currentUser = User.fromMap(result.jsonResult);
        print('token刷新成功');

        return currentUser;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

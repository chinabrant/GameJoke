import 'av_object.dart';
import 'av_file.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/*
"nick": "爱家",
"sign": "一个爱家的人",
"ACL": {
  "*": {
    "read": true,
    "write": true
  }
},
"username": "222222",
"emailVerified": false,
"mobilePhoneVerified": false,
"objectId": "5a22767c570c350067033b36",
"createdAt": "2017-12-02T09:46:36.367Z",
"updatedAt": "2017-12-02T09:47:47.251Z"
*/

class User extends AVObject {
  static User currentUser;

  static const String currentUserJsonCacheKey = 'currentUserJsonCacheKey';

  User({this.nick, this.sign});

  String nick;
  String sign;
  AVFile avatar;
  String username;
  String sessionToken;
  bool emailVerified;

  // 把当前登录用户的json数据做存到文件 
  static void saveUserBody(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(currentUserJsonCacheKey, body);
  }

  // 从文件缓存加载当用登录用户
  static Future<User> loadUserFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String body = prefs.getString(currentUserJsonCacheKey);
    Map map = json.decode(body);
    User user = User.fromMap(map);
    print('缓存的用户数据：$body');
    print('用户id:${user.objectId}');
    User.currentUser = user;
    return user;
  }

  static Future clearUserCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(currentUserJsonCacheKey);
  }

  static bool isLogin() {
    if (User.currentUser == null) {
      return false;
    }

    return true;
  }

  static void logout() {
    User.currentUser = null;
    User.clearUserCache();
  }

  User.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (map == null) {
      return;
    }

    this.nick = map['nick'];
    this.avatar =
        map['avatar'] != null ? new AVFile.fromMap(map['avatar']) : null;
    this.username = map['username'];
    this.emailVerified = map['emailVerified'];
    this.sign = map['sign'] ?? '这货好懒，什么都没有写';
    this.sessionToken = map['sessionToken'];
  }
}

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

enum HttpStatus {
  ok,
  faile
}

/// 网络返回结果类
class ResponseResult {

  ResponseResult({this.response});

  HttpStatus get status {
    if (response.statusCode >= 200 && response.statusCode < 400) {
        return HttpStatus.ok;
      } else {
        
        return HttpStatus.faile;
      }
  }

  Response response;

  // json
  Map get jsonResult {
    return json.decode(response.body);
  }

  String get body => response.body; // 这个可以用来做缓存 

}
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:http/http.dart' as http;
import './response_result.dart';

class BaseApi {
  static const String kLeancloudId = 'a4h8AfUwvYJFsiwl0JBv9Fu5';
  static const String kLeancloudKey = '4ywjc0gCkPxkEQMImhSjKurf';
  static const String kMasterKey = 'b6RUPMplH7Tn8IKBJOOTArOq';
  static const String kBaseUrl = 'a4h8afuw.api.lncld.net';
  static const String kCQLPath = '/1.1/cloudQuery';

  /// 发送get请求
  /// path: 路径
  /// params: 参数
  static Future<ResponseResult> get(String path, Map params,
      [String session = '']) async {
    try {
      final uri = new Uri.https(kBaseUrl, path, params);
      print('请求的url: ${uri}');
      final headers = {
        "Content-Type": "application/json",
        "X-LC-Id": kLeancloudId,
        "X-LC-Key": kLeancloudKey,
        "X-LC-Session": session,
      };

      final response = await http.get(uri, headers: headers);
      ResponseResult result = ResponseResult(response: response);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  // {"content": "每个 Java 程序员必备的 8 个开发工具","pubUser": "LeanCloud官方客服","pubTimestamp": 1435541999}
  static Future<ResponseResult> post(String path, dynamic params) async {
    final uri = new Uri.https(kBaseUrl, path, null);
    print('请求的url: ${uri}');
    final headers = {
      "Content-Type": "application/json",
      "X-LC-Id": kLeancloudId,
      "X-LC-Key": kLeancloudKey
    };

    final response = await http.post(uri, headers: headers, body: params);
    ResponseResult result = ResponseResult(response: response);
    return result;
  }

  static Future<ResponseResult> put(
      String path, dynamic params, String session) async {
    try {
      final uri = new Uri.https(kBaseUrl, path, null);
      print('请求的session: ${session}');
      print('请求的url: ${uri}');
      final headers = {
        "Content-Type": "application/json",
        "X-LC-Session": session,
        "X-LC-Id": kLeancloudId,
        "X-LC-Key": kLeancloudKey
      };

      final response = await http.put(uri, headers: headers, body: params);

      ResponseResult result = ResponseResult(response: response);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Map> uploadImage(Image image) async {
    final uri = new Uri.https(kBaseUrl, '/1.1/files/test.png', null);
    // print('请求的url: ${uri}');
    final headers = {
      "Content-Type": "image/png",
      "X-LC-Id": kLeancloudId,
      "X-LC-Key": kLeancloudKey
    };

    final response = await http.post(uri, body: image, headers: headers);
    var data = json.decode(response.body);

    return data;
  }

  static Future<Map> cqlGet(String cql) async {
    final headers = {
      "Content-Type": "application/json",
      "X-LC-Id": kLeancloudId,
      "X-LC-Key": kLeancloudKey
    };

    final response = await http.get(
        "https://" + kBaseUrl + kCQLPath + '?cql=' + cql,
        headers: headers);
    var data = json.decode(response.body);
    // print("接口返回数据：$data");

    return data;
  }

  /*
  * 条件查询时，如果条件为对象，返回对象的描述
  * */
  static String objectDesc(String objectName, String objectId) {
    // return '\{\"$fieldName\":\{\"__type\":\"Pointer\"\,\"className\":\"$objectName\"\,\"objectId\":\"$objectId\"\}\}';

    return '\{\"__type\":\"Pointer\"\,\"className\":\"$objectName\"\,\"objectId\":\"$objectId\"\}';
  }

  /*
  * 条件查询时，如果条件为对象，返回对象的描述
  * */
  static String whereDesc(
      String fieldName, String objectName, String objectId) {
    return '\{\"$fieldName\":\{\"__type\":\"Pointer\"\,\"className\":\"$objectName\"\,\"objectId\":\"$objectId\"\}\}';
  }
}

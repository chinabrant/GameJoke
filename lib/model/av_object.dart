import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AVObject {
  static const String OBJECT_ID_KEY = 'objectId';

  AVObject({this.objectId, this.createdAt, this.updatedAt});

  String objectId;
  DateTime createdAt;
  DateTime updatedAt;

  AVObject.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }
    objectId = map['objectId'] ?? null;

    if (map['createdAt'] != null) {
      createdAt = DateTime.parse(map['createdAt']);
    }
    
    if (map['updatedAt'] != null) {
      updatedAt = DateTime.parse(map['updatedAt']);
    }
    
  }
}

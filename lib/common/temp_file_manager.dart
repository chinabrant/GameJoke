import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

// 获取本地文件目录
Future<File> getTempFile(String fileName) async {
  // 获取本地文档目录
  String dir = (await getTemporaryDirectory()).path;
  // 返回本地文件目录
  return new File('$dir/$fileName').create();
}

Future<String> writeTempAvatar(ui.Image image) async {
   ByteData data = await image.toByteData(format: ui.ImageByteFormat.png);
   File file = await getTempFile('avatar.png');
   await file.writeAsBytes(data.buffer.asUint8List());
   
   return file.path;
}
  
import 'av_object.dart';

/*
* 文件类型
* */
class AVFile extends AVObject {
  final String name;
  final String url;
  final String mimeType;
  final String bucket;
  Map<String, dynamic> metaData;

  AVFile({this.name, this.url, this.mimeType, this.bucket, this.metaData});

  AVFile.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        url = map['url'],
        mimeType = map['mime_type'],
        bucket = map['bucket'],
        metaData = map['metaData'],
        super.fromMap(map);

  double imageRatio() {
    // print('metaData: ${this.metaData}');

    if (this.metaData != null) {
      
      double width = this.metaData['width'].toDouble();
      double height = this.metaData['height'].toDouble();
      if (width > 0 && height > 0) {
        return width / height;
      }
    }

    return 1.0;
  }
}

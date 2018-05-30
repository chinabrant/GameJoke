import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:lol_joke/api/joke_api.dart';
import 'package:lol_joke/model/game.dart';

class CreateJokePage extends StatefulWidget {
  Game game;

  CreateJokePage({@required this.game});

  @override
  State<StatefulWidget> createState() {
    return new CreateJokeState();
  }
}

class CreateJokeState extends State<CreateJokePage> {
  final TextEditingController _textEditingController =
      new TextEditingController();
      final FocusNode focusNode = FocusNode();

  static const platform = const MethodChannel('joke.brant.com/upload');

  File _image;
  String _imageObjectId;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('${image.path}');

    setState(() {
      _image = image;
    });
  }

  Future saveImage(String path) async {
    try {
      final String result = await platform.invokeMethod('uploadImage', path);
      print('objectId: ${result}');
      _imageObjectId = result;

      _createJoke();
    } on PlatformException catch (e) {
      print('error: ${e.message}');
      Navigator.pop(context);
      _showMessage('出错了，请重试!');
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
          child: new Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: new Text("发表中..."),
            ),
          ],
        ),
      )),
    );
  }

  _createJoke() {
    JokeApi
        .createJoke(_textEditingController.text, _imageObjectId, widget.game)
        .then((map) {
      Navigator.pop(context);
      _showMessage("创建成功");

      new Future.delayed(new Duration(seconds: 2), () {
        Navigator.pop(context); //pop dialog
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('发表段子'),
          elevation: 0.0,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {
                if ((_textEditingController.text == null ||
                        _textEditingController.text == '') &&
                    _image == null) {
                  _showMessage('内容和图片不能都为空');
                  return;
                }

                print('开始创建');

                // 开始创建，显示loading view
                _onLoading();

                if (_image != null) {
                  saveImage(this._image.path);
                } else {
                  _createJoke();
                }
              },
            )
          ],
        ),
        body: new GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: // 内容
                Container(
                    color: Colors.brown[50],
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: new Text(
                            '内容',
                            style: new TextStyle(
                              color: Colors.brown[300],
                            ),
                          ),
                        ),

                        // 内容输入框
                        new Container(
                          margin: const EdgeInsets.all(10.0),
                          child: new TextField(
                            focusNode: focusNode,
                            controller: _textEditingController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 6,
                          ),
                        ),
                        // 图片
                        new Container(
                            margin: const EdgeInsets.all(10.0),
                            child: new Text(
                              '图片',
                              style: new TextStyle(
                                color: Colors.brown[300],
                              ),
                            )),

                        new GestureDetector(
                          onTap: () {
                            // 选择图片
                            getImage();
                          },
                          child: new Container(
                              height: 180.0,
                              color: Color(0xffefefef),
                              margin: const EdgeInsets.all(10.0),
                              child: _image == null
                                  ? new Center(
                                      child: new Text(
                                      '点击选择图片',
                                      style: new TextStyle(
                                          color: Colors.brown[700]),
                                    ))
                                  : new Image.file(_image)),
                        ),

                        // tips
                        new Container(
                            child: new Text(
                          '提示：内容和图片必须有一个不为空',
                          style: new TextStyle(color: Colors.brown[200]),
                        )),
                      ],
                    ))));
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
          child: new Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            // new CircularProgressIndicator(),
            new Container(
              // margin: const EdgeInsets.only(top: 10.0),
              child: new Text(message),
            ),
          ],
        ),
      )),
    );

    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
    });
  }
}

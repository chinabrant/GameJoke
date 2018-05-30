import 'package:flutter/material.dart';
import './widgets/normal_cell.dart';
import './widgets/avatar_cell.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:lol_joke/common/router_define.dart';
import 'dart:ui' as ui;
import '../common/temp_file_manager.dart';
import 'package:flutter/services.dart';
import '../api/user_api.dart';
import '../model/user.dart';
import './widgets/logout_cell.dart';

/// 用户信息页面
class UserSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserSettingsPageState();
  }
}

class UserSettingsPageState extends State<UserSettingsPage> {
  static const platform = const MethodChannel('joke.brant.com/upload');
  String avatarUrl;

  @override
  void initState() {
    if (User.currentUser != null && User.currentUser.avatar != null) {
      this.avatarUrl = User.currentUser.avatar.url;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户信息'),
      ),
      body: _body(),
    );
  }

  Widget _body() {

    String nick = '未设置';
    if (User.isLogin() && User.currentUser.nick != null) {
      nick = User.currentUser.nick;
    }

    return Container(
      child: ListView(
        children: <Widget>[
          AvatarCell(
            avatarUrl: avatarUrl,
            onTap: () {
              getImage();
            },
          ),
          Divider(
            height: 8.0,
            color: Color(0xffefefef),
          ),
          NormalCell(
            title: '昵称',
            action: Icon(Icons.chevron_right),
            rightTitle: nick,
            onTap: () {
              // 编辑昵称
              Navigator.of(context).pushNamed(RouterDefine.userEdit);
            },
          ),
          LogoutCell(logoutCallback: (){
            User.logout();
            Navigator.of(context).pop();
          }),
        ],
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // print('${image.path}');

    RouterDefine.pushImageEidt(context, image).then((ui.Image image) {
      if (image != null) {
        // 将图片写到临时文件
        writeTempAvatar(image).then((path) {
          print('文件路径：$path');

          saveImage(path);
        });
      }
    });
  }

  // 上传图片到leancloud
  Future saveImage(String path) async {
    try {
      final String objectid = await platform.invokeMethod('uploadImage', path);
      if (objectid != null) {
        print('上传成功，objectid: $objectid');

        User user;
        try {
          user = User.currentUser;
          print('session: ${user.sessionToken}');
        } catch (e) {
          print('出错了：${e.toString()}');
        }

        final String userid = user.objectId;
        UserApi
            .updateUserAvatar(userid, objectid, user.sessionToken)
            .then((map) {

          // 刷新用户信息
          UserApi.refreshUserInfo().then((user){
            if (user != null && user.avatar != null) {
              setState(() {
                this.avatarUrl = user.avatar.url;
              });
            }
          });
        });
      } else {
        print('上传图片的objectid为空');
      }
    } on PlatformException catch (e) {
      print('error: ${e.message}');
      // Navigator.pop(context);

    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/mine_item_widget.dart';
import 'package:lol_joke/common/router_define.dart';
import './widgets/user_info_cell.dart';
import '../model/user.dart';

/**
 * 关于我们页面
 */
class MinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context, nullOk: true);

    Widget root = Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            Container(
                height: mediaQuery.padding.top,
                color: Colors.brown // Color(0xffffffff),
                ),
            UserInfoCell(onTap: () {
              if (User.isLogin()) {
                Navigator.of(context).pushNamed(RouterDefine.userInfo);
              }
              else {
                Navigator.of(context).pushNamed(RouterDefine.login);
              }
              
            },),
            Divider(
              height: 8.0,
              color: Color(0xffeaeaea),
            ),
            MineNormalItemWidget(
              title: '关于我们',
              leading: Icon(Icons.help, color: Colors.brown[700]),
              callback: () {
                Navigator.of(context).pushNamed(RouterDefine.aboutus);
              },
            ),
            Divider(
              height: 0.5,
              color: Color(0xffeaeaea),
            ),
            
          ],
        ));

    return Scaffold(
      body: root,
    );
  }
}

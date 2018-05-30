import 'package:flutter/material.dart';

class MineNormalItemWidget extends StatelessWidget {
  String title;
  Icon leading;
  Icon rightAction;

  VoidCallback callback;

  MineNormalItemWidget({this.title, this.callback, this.leading, this.rightAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.callback != null) {
          this.callback();
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15.0),
        height: 50.0,
        child: Row(
          children: <Widget>[
            Container(
              child: leading,
              margin: const EdgeInsets.only(right: 10.0),
            ),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontSize: 15.0, color: Colors.brown),
            )),
            Icon(
              Icons.chevron_right,
              color: Colors.brown[700],
            )
          ],
        ),
      ),
    );
  }
}

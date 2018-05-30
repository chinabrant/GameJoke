import 'package:flutter/material.dart';

class NormalCell extends StatelessWidget {
  VoidCallback onTap;
  String title; // 标题
  Icon leading; // 前面的图标 ，不传就不显示
  Icon action; // 后面的图标，不传不显示
  String rightTitle; // 右边显示的文字，不传不显示

  NormalCell(
      {this.title, this.leading, this.action, this.rightTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
        child: Container(
      color: Colors.white,
      height: 50.0,
      child: Row(
        children: _rows(),
      ),
    ));
  }

  List<Widget> _rows() {
    List<Widget> list = List<Widget>();
    if (this.leading != null) {
      Widget left = Container(
        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
        child: this.leading,
      );
      list.add(left);
    }

    if (title != null) {
      Widget titleWidget = Container(
        margin: const EdgeInsets.only(left: 15.0),
        child: Text(
          this.title,
          style: TextStyle(fontSize: 17.0),
        ),
      );

      if (rightTitle == null) {
        titleWidget = Expanded(
          child: titleWidget,
        );
      }

      list.add(titleWidget);
    }

    if (rightTitle != null) {
      Widget right = Expanded(
        child: Text(
          rightTitle,
          textAlign: TextAlign.end,
        ),
      );
      list.add(right);
    }

    if (action != null) {
      Widget rightAction = Container(
        child: action,
        margin: const EdgeInsets.only(right: 15.0),
      );
      list.add(rightAction);
    }

    return list;
  }
}

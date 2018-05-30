import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarCell extends StatelessWidget {
  String avatarUrl;

  VoidCallback onTap;

  AvatarCell({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onTap,
        child: Container(
          color: Colors.white,
          height: 100.0,
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                width: 70.0,
                height: 70.0,
                child: _avatar(),
              ),
              Expanded(
                flex: 1,
                child: Text(''),
              ),
              Container(
                child: Icon(Icons.chevron_right),
                margin: const EdgeInsets.only(right: 15.0),
              )
            ],
          ),
        ));
  }

  Widget _avatar() {
    if (this.avatarUrl != null) {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            fit: BoxFit.fill,
          ));
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color: Colors.brown,
            child: Center(
              child: Text(
                '头像',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ));
    }
  }
}

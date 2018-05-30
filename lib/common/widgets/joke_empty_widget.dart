import 'package:flutter/material.dart';

class JokeEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              '这里还没有段子',
              style: TextStyle(fontSize: 15.0, color: Color(0xff999999)),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  '！！！！！！',
                  style: TextStyle(fontSize: 15.0, color: Color(0xff999999)),
                )),
          ],
        ),
      ),
    );
  }
}

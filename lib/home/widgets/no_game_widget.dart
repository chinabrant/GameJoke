import 'package:flutter/material.dart';

class NoGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('请先选择游戏',
          style: TextStyle(

            fontSize: 20.0,
            
          ),
        ),
      ),
    );
  }
}

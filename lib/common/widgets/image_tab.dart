import 'package:flutter/material.dart';

class ImageTab extends StatelessWidget {

  bool selected;
  IconData icon;

  ImageTab({this.selected, this.icon});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.brown;
    if (!this.selected) {
      color = Color(0xff999999);
    }

    return Center(
      child: Icon(this.icon, color: color,),
    );
  }

}

// class ImageTabState extends State<ImageTab> {

  

//   @override
//   Widget build(BuildContext context) {
//     Color color = Colors.brown;
//     if (!this.selected) {
//       color = Color(0xff999999);
//     }

//     return Center(
//       child: Icon(this.icon, color: color,),
//     );
//   }

// }
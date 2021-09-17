import 'package:flutter/material.dart';
import 'package:handover/widget/circle_painter.dart';

class CircleButton extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final String text;
  final double fontSize;

  CircleButton({this.width , this.height , this.color , this.text , this.fontSize});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: (){},
        child: Text('$text' , style: TextStyle(color: Colors.white , fontSize: fontSize)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(const CircleBorder())),
      ),
    );
  }
}


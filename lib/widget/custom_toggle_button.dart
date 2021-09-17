import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomToggleButton extends StatefulWidget{
   String buttonText;
  final IconData icon;
  bool toggle = false;

  CustomToggleButton({@required this.buttonText , @required this.icon });

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {

  @override
  Widget build(BuildContext context) {

    return RawMaterialButton(
        fillColor: widget.toggle ? Colors.green : Colors.grey,
        splashColor: Colors.greenAccent,
        child : Padding(
          padding: EdgeInsets.all(10.0),
          child : Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
            Icon(
              Icons.person,
              color : Colors.amber
            ),
            SizedBox(
              width : 10.0,
            ),
            Text(
              '켜짐',
              maxLines:1,
              style : TextStyle(color : Colors.white70)
            )
            ],
          )
        ),
        onPressed: (){
          setState(() {
            widget.toggle = !widget.toggle;
          });
        },
        shape: const StadiumBorder(),
    );
  }
}
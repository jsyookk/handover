import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class OneMessageDialog extends StatefulWidget {

  final String question;
  final String btnText;
  final Function btnFnc;

  @override
  _OneMessageDialogState createState() => _OneMessageDialogState();

  OneMessageDialog( this.question , this.btnText , this.btnFnc);
}

class _OneMessageDialogState extends State<OneMessageDialog> {


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: Container(
            margin: EdgeInsets.only(left : 0.0 , right : 0.0),
            width: screenSize.width * 0.6,
            height: screenSize.height * 0.3,

            child: Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    padding: EdgeInsets.only(top : 25.0 ),
                    margin: EdgeInsets.only(top : 13.0 , right : 8.0 , left : 8.0 , bottom: 13.0),
                    child: Column(
                        children: [

                          Text('${widget.question}' , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.w300)),
                          SizedBox(
                            height: 50.0,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 160,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text('${widget.btnText}' , style:kSendButtonTextStyle),
                                  onPressed: ()=> widget.btnFnc ),
                            ),
                          ),

                        ]),
                  ),
                  Positioned(
                    top : -5,
                    right: -5,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color : Colors.amber,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Icon(
                            Icons.close,
                            size : 30.0,
                            color : Colors.white
                        ),
                      ),
                    ),
                  )
                ])));
  }
}

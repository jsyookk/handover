import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SingoDialog extends StatefulWidget {
  @override
  _SingoDialogState createState() => _SingoDialogState();
}

class _SingoDialogState extends State<SingoDialog> {
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
            height: screenSize.height * 0.4,

            child: Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    padding: EdgeInsets.only(top : 25.0 ),
                    margin: EdgeInsets.only(top : 13.0 , right : 8.0 , left : 8.0 , bottom: 13.0),
                    child: Column(
                        children: [

                          Text('이 이미지를 신고하시겠어요?' , style: TextStyle(fontSize: 15.0 , fontWeight: FontWeight.w300)),
                          SizedBox(
                            height: 25.0,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0 , horizontal: 15.0),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                labelText: '신고 사유를 입력해 주세요'
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 180,
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text('신고하기' , style:kSendButtonTextStyle),
                                  onPressed: () {
                                    print('신고!!!!');
                                  } ),
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

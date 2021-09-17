import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import 'package:handover/model/game_next.dart';

class CompleteScreen extends StatelessWidget {


  var arg = Get.arguments as GameNext;


  List<String> userNicknames(){

    List<String> nicknames = List<String>();
    arg?.finishedUsers.forEach((element) { nicknames.add(element.nickname); });

    return nicknames;
  }

  @override
  Widget build(BuildContext context) {

    var isCompletedGame = arg.gameInfo.currentTurn == arg.gameInfo.maximumTurn ? true : false;

    return Scaffold(
      backgroundColor:  backgroundColour,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget> [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(236, 236, 236, 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget> [
                        Padding(
                            padding : EdgeInsets.only(left: 15.0 , right: 10.0),
                            child: Icon(Icons.announcement , size: 25 , color: Color(0xffd2d2d2))),

                        RichText(text: TextSpan(
                            style: DefaultTextStyle.of(context).style,

                            children: !isCompletedGame ? <TextSpan> [
                              TextSpan(text :'${arg.nextUser.nickname}',style: kRegularTextStyle),
                              TextSpan(text :'에게 다음 차례를 넘겼습니다.',style: kRegularTextStyle),
                            ]:
                            <TextSpan> [
                              TextSpan(text :'${arg.finishedUsers.last.nickname} 님이 마지막 턴 입니다.',style: kRegularTextStyle),
                            ]
                          )),
                      ],
                    ),
                  ),
              SizedBox(
                height: 30.0,
              ),
              RichText(text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan> [
                    TextSpan(text :'총 ',style: kRegularTextStyle),
                    TextSpan(text :'${arg.gameInfo.maximumTurn}',style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.black)),
                    TextSpan(text :' 턴 중 ',style: kRegularTextStyle),
                    TextSpan(text :'${arg.gameInfo.currentTurn}',style: TextStyle(fontSize : 20 ,fontWeight: FontWeight.bold , color: Colors.black)),
                    TextSpan(text :' 번째 턴을 완료 하였습니다.',style: kRegularTextStyle),
                  ]
              )),
              RichText(text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: !isCompletedGame ? <TextSpan> [
                    TextSpan(text :'${arg.finishedUsers.last.nickname}',style: kRegularTextStyle),
                    TextSpan(text :'님이 지목하신 ',style: kRegularTextStyle),
                    TextSpan(text :'${arg.nextUser.nickname}',style: kRegularTextStyle),
                    TextSpan(text :'는 ',style: kRegularTextStyle),
                    TextSpan(text :'${arg.nextUser.turnNum}',style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color: Colors.black)),
                    TextSpan(text :'번째 턴을 이이서 진행하게 됩니다.',style: kRegularTextStyle),
                  ]:
                  <TextSpan> [
                    TextSpan(text :'${userNicknames()}님이 이번 게임에 참여 하였습니다.',style: kRegularTextStyle)
                  ]
              )),
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                     color: activeButtonColour,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget> [
                        !isCompletedGame ?
                        Text('게임이 끝나기까지 예상 완료 시간',style :TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.white)):
                        Text('게임 완료 시간',style :TextStyle(fontSize: 16 , fontWeight: FontWeight.w500 , color: Colors.white)),

                      Text('02:55',style: TextStyle(fontSize: 55 , fontWeight: FontWeight.bold , color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child:  FlatButton(
                  height: 50,
                  minWidth: double.infinity,
                  color: activeButtonColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text('확인' , style: kSendButtonTextStyle),
                  onPressed: (){
                    Get.reset();
                    Get.offAllNamed('/');

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


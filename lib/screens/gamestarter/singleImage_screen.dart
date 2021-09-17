import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handover/model/game_next.dart';

class SingleImageScreen extends StatelessWidget {

  var gameNext = Get.arguments as GameNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : SafeArea(
              child: Column(
                children:<Widget> [
                  Expanded(
                    flex:1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        gameNext.finishedUsers.isEmpty ?
                        Text('${gameNext.gameInfo.keyword}을 보고 그림을 그려주세요.'):
                        Text('${gameNext.finishedUsers.last.nickname} 님은 이걸 이렇게 생각했네요.'),
                        IconButton(icon: Icon(Icons.send , size: 25,),
                          onPressed: (){
                            Get.offNamed('/game/draw' , arguments: gameNext);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child:

                    gameNext.finishedUsers.isEmpty ?
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: const Radius.circular(15.0),
                            bottomLeft: const Radius.circular(15.0),
                          ),
                      ),
                      padding:EdgeInsets.all(15.0),
                      child: Center(
                        child : Text('${gameNext.gameInfo.keyword}' , style: TextStyle(fontSize: 35))
                      ),
                    ):
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                        ),
                        image : DecorationImage(
                          image : NetworkImage(gameNext != null ? gameNext?.finishedUsers?.last?.imgUrl :
                          "http://cdn.sketchpan.com/member/r/ri9904/draw/1218415839531/0.png"
                          ),
                          fit: BoxFit.fill
                        )
                      ),
                      padding:EdgeInsets.all(15.0),
                    ),
                  )
                ],
              ),
        ));
  }
}

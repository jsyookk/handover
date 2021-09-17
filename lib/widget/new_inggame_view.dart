import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/time_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


enum GAME_STATE {
  MY_TURN,
  PREV_TURN,
  LATE_PREV_TURN,
  ETC
}

class NewIngGameView extends StatefulWidget {

  final String imgUrl;
  final int maxTurn;
  final int currentTurn;
  final String createdTime;
  final bool isMyTurn;
  final bool isReceivedTurn;
  final Function onTap;
  final String nextUserName;
  final GameNext game;
  final String userId;
  GAME_STATE state = GAME_STATE.ETC;

  NewIngGameView(
      {this.imgUrl, this.maxTurn, this.currentTurn, this.createdTime, this.isMyTurn, this.isReceivedTurn , this.onTap, this.nextUserName , this.game , this.userId});

  @override
  _NewIngGameViewState createState() => _NewIngGameViewState();
}

class _NewIngGameViewState extends State<NewIngGameView> with SingleTickerProviderStateMixin {

  Timer _timer;
  var _createdTime;
  var _elapsedTime = "";
  int _elapsedHour = 0;
  AnimationController _animationController;
  Animation _animation;


  void _init(){
    if(widget.isMyTurn){
      _animationController = AnimationController(vsync:this , duration: Duration(seconds: 1));
      _animationController.repeat(reverse: true);
      _animation = Tween(begin:  1.0 , end : 4.5).animate(_animationController)..addListener(() {
        setState(() {

        });
      });
    }

    _createdTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(this.widget.createdTime));
    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if(_animationController != null && _animationController.isAnimating){
      _animationController.dispose();
    }
    super.dispose();
  }

  void _startTimer(){
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        var elapsedTime = DateTime.now().millisecondsSinceEpoch - int.parse(this.widget.createdTime);

        //_elapsedTime = TimeUtils.elapsedTimeHHMMSS(elapsedTime);


        var timeMap = TimeUtils.mapElapsedTimeHHMMSS(elapsedTime);
        _elapsedTime = '${timeMap['hours']}h ${timeMap['min'] % 60}m ${timeMap['sec'] % 60}s';
        _elapsedHour = timeMap['hours'];

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0 , horizontal: 15.0),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 150
      ),
      decoration: BoxDecoration(
        /*
          boxShadow: [
            BoxShadow(
                color: widget.isMyTurn? Color.fromARGB(255, 225, 38, 38) : Colors.white,
                spreadRadius: widget.isMyTurn? _animation.value : 0.0,
                blurRadius: widget.isMyTurn? _animation.value : 0.0,
                offset: Offset(0, 3)
            )
          ],*/
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(this.widget.imgUrl , fit: BoxFit.fill),
                  /*
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),

                      side: BorderSide(
                          color: Colors.white38.withOpacity(0.1),
                          width: 1
                      )
                  ),*/
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0 , horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      getButtonArea(widget.state),

                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Stack(
                          children: [
                            LinearPercentIndicator(
                              animation: true,
                              lineHeight : 15.0,
                              percent: widget.currentTurn / widget.maxTurn,
                              progressColor: Colors.blue,
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                child: Center(child: Text('${widget.currentTurn}/${widget.maxTurn}'))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right : 15.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text('${'game is over'} $_elapsedTime',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
          widget.isReceivedTurn ?
          Positioned(
            top : -55,
            right: -30,
            child: Container(
                color: Colors.transparent,
                child: Lottie.asset('ani/arrow-down.json',
                    width: 84,
                    height: 84,
                    fit: BoxFit.fill
                ),
            ),
          ) : Container()
      ]),
    );
  }


  Widget getButtonArea(GAME_STATE state){

    if( widget.isMyTurn){
      widget.state = GAME_STATE.MY_TURN;
    }else if( widget.game.finishedUsers.last.id == widget.userId && (_elapsedHour < 24)) {
      widget.state = GAME_STATE.PREV_TURN;
    }
    else if( widget.game.finishedUsers.last.id == widget.userId && (_elapsedHour >= 24)){
      widget.state = GAME_STATE.LATE_PREV_TURN;
    }else{
      widget.state = GAME_STATE.ETC;
    }

    switch(widget.state){
      case GAME_STATE.MY_TURN :
        return Container(
          child : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children : [
              FlatButton(
                minWidth: 80,
                height: 35,
                //padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                color: !widget.isMyTurn ? activeButtonColour : greenButtonColour,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(
                    '참여하기', style: kCategoryButtonTextStyle),
                onPressed: () =>
                      widget.onTap()),

              FlatButton(
                  minWidth: 80,
                  height: 35,
                  //padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                  color: tossiButtonColour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child:Text(
                      '넘기기', style: kCategoryButtonTextStyle),
                  onPressed: () {
                    widget.onTap();
                  }),

          ])
        );


      case GAME_STATE.PREV_TURN :
        return Container(
            child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children : [
                  Text('${'wait'}'),

                  FlatButton(
                      minWidth: 80,
                      height: 35,
                      padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                      color: !widget.isMyTurn ? activeButtonColour : greenButtonColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child:Text(
                          '조르기(1시간)', style: kCategoryButtonTextStyle),
                      onPressed: () {

                      }),

                ])
        );
      case GAME_STATE.LATE_PREV_TURN :
        return Container(
            child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children : [
                  FlatButton(
                      minWidth: 80,
                      height: 35,
                      padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                      color: !widget.isMyTurn ? activeButtonColour : greenButtonColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                          '조르기', style: kCategoryButtonTextStyle),
                      onPressed: () {

                      }),

                  FlatButton(
                      minWidth: 80,
                      height: 35,
                      padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                      color: tossiButtonColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child:Text(
                          '넘기기', style: kCategoryButtonTextStyle),
                      onPressed: () {

                      }),

                ])
        );
      case GAME_STATE.ETC:
        return Container(
            child : Center(
                child:
                  Text('게임이 진행중이예요..'),
                )
        );
    }
  }


}
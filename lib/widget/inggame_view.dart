import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:handover/utils/time_utils.dart';

class IngGameView extends StatefulWidget {
  final String imgUrl;
  final int maxTurn;
  final int currentTurn;
  final String createdTime;
  final bool isMyTurn;
  final bool isReceivedTurn;
  final Function onTap;
  final String nextUserName;

  IngGameView(
      {this.imgUrl, this.maxTurn, this.currentTurn, this.createdTime, this.isMyTurn, this.isReceivedTurn , this.onTap, this.nextUserName});

  @override
  _IngGameViewState createState() => _IngGameViewState();
}

class _IngGameViewState extends State<IngGameView> {

  Timer _timer;
  var _createdTime;
  var _elapsedTime = "";

  @override
  void initState() {
    // TODO: implement initState
    _createdTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(this.widget.createdTime));
    _startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(){
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
         var elapsedTime = DateTime.now().millisecondsSinceEpoch - int.parse(this.widget.createdTime);

        _elapsedTime = TimeUtils.elapsedTimeDDHHMMSS(elapsedTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      width: double.infinity,
      child: Stack(
        overflow: Overflow.visible,
        children:[
          Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 80,
                      height: 100,
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(this.widget.imgUrl),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Colors.white38.withOpacity(0.2),
                                width: 1
                            )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 80,
                      transform: Matrix4.translationValues(-1.5, 0.0, 0.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 3)
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0))
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DotsIndicator(
                                    axis: Axis.horizontal,
                                    dotsCount: (widget.maxTurn >= 10) ? 10 : widget.maxTurn,
                                    position: widget.currentTurn - 1.0,
                                    decorator: DotsDecorator(
                                      shape: const Border(),
                                      activeColor: widget.isMyTurn ? Colors.redAccent : Colors.lightGreen ,
                                      activeSize: const Size(18.0 , 9.0),
                                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                    ),
                                  ),
                                ),
                                Text('(${widget.currentTurn}/${widget.maxTurn})'),
                              ],
                            ),
                            Text('게임 경과 시간 : $_elapsedTime',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: !widget.isMyTurn ? Text('${widget.nextUserName}님이 엄청 신중하신 성격인가봐요.',
                          style: TextStyle(color: Colors.grey, fontSize: 12)
                      ) : Text('내 차례입니다.게임에 참여하세요!.',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                      child: FlatButton(
                          minWidth: 72,
                          height: 24,
                          padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                          color: !widget.isMyTurn ? activeButtonColour : greenButtonColour,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: !widget.isMyTurn ? Text(
                              '조르기', style: kCategoryButtonTextStyle) : Text(
                              '내 차례', style: kCategoryButtonTextStyle),
                          onPressed: () {
                            widget.onTap();
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
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
      ]),
    );
  }
}
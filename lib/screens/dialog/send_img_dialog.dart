
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/widget/new_profile_area.dart';

import '../../constants.dart';

class SendImgDialog extends StatefulWidget {

  GameNext gameNext;
  bool isReceived;

  SendImgDialog(GameNext gameNext , bool isReceived){
    this.gameNext = gameNext;
    this.isReceived = isReceived;
  }

  @override
  _SendImgDialogState createState() => _SendImgDialogState();


}

class _SendImgDialogState extends State<SendImgDialog> {
  BannerAd _bannerAd;
  AdWidget _adWidget;

  @override
  void initState(){
    super.initState();
    _bannerAd = _createBannerAD();
    _adWidget = AdWidget(ad : _bannerAd);
  }

  BannerAd _createBannerAD(){

    return BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        size : AdSize.banner,
        request : AdRequest(),
        listener: AdListener(
          onAdLoaded: (Ad ad) => print('AD Loaded'),
          onAdFailedToLoad: (Ad ad , LoadAdError error){

          },
          onAdOpened: (Ad ad) => print('Ad opended'),
          onAdClosed: (Ad ad) => print('Ad closed'),
        )
    )..load();

  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
                elevation: 0.0,
                backgroundColor: Colors.white,
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0)
              ),
              //margin: EdgeInsets.only(top : 13.0 , right: 8.0),
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0 , horizontal: 15.0),
                    child: Column(
                      children: [
                      Expanded(
                        flex:2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            NewProfileArea(
                              context: context ,
                              radius: 85.0,
                              width: 80.0,
                              height: 80.0,
                              lv_percent: 0.0,
                              nickname: 'test',
                              profileImageUrl:'https://imgur.com/I80W1Q0.png' ,
                            ),

                            widget.gameNext.finishedUsers.isEmpty ?
                            Text('${widget.gameNext.gameInfo.keyword}을 보고 그림을 그려주세요.'):
                            Text('${widget.gameNext.finishedUsers.last.nickname} 님이 보내온 \n 그림입니다.'),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Expanded(
                        flex: 7,
                        child:
                        widget.gameNext.finishedUsers.isEmpty ?
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(const Radius.circular(15.0)
                            ),
                          ),
                          padding:EdgeInsets.all(15.0),
                          child: Center(
                              child : Text('${widget.gameNext.gameInfo.keyword}' , style: TextStyle(fontSize: 35))
                          ),
                        ):
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color : Colors.white38,
                              width : 1
                            ),
                              borderRadius: BorderRadius.all(const Radius.circular(15.0)
                              ),
                              image : DecorationImage(
                                  image : NetworkImage(widget.gameNext != null ? widget.gameNext?.finishedUsers?.last?.imgUrl :
                                  "http://cdn.sketchpan.com/member/r/ri9904/draw/1218415839531/0.png"
                                  ),
                                  fit: BoxFit.fill
                              )
                          ),
                          padding:EdgeInsets.all(15.0),
                        ),
                      ),

                        widget.isReceived ?
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text('그리러 가기', style: kSendButtonTextStyle),
                              onPressed: () async {

                                if(Get.currentRoute == '/game/draw'){
                                  Get.offNamed('/game/draw' , arguments: widget.gameNext);
                                }else{
                                  Get.toNamed('/game/draw' , arguments: widget.gameNext);
                                }
                              }),
                        ):
                        Expanded(
                          flex : 2,
                          child:
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                alignment: Alignment.center,
                                child: _adWidget,
                                width: _bannerAd.size.width.toDouble(),
                                height: _bannerAd.size.height.toDouble()
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top : -5,
                    right: -5,
                    child: Align(
                      alignment: Alignment.topRight,
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
                              size : 25.0,
                              color : Colors.white
                          ),
                        ),
                      ),
                    ),
                  )

                ]),
            ),
          );
  }

}

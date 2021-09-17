import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/constants.dart';
import 'package:get/get.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/model/game_info.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/utils/admob_manager.dart';
import 'package:provider/provider.dart';

class ReceiveScreen extends StatefulWidget {

  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {

  var gameNext = Get.arguments as GameNext;
  String mainTitle;
  RewardedAd _completeRewardMob;
  AdListener _completeRewardListener;
  bool _isReadyReward = false;
  bool animation = false;
  bool isCompletedGame = false;
  bool isDataLoad = false;


  void createTurnAdmob(){

    _completeRewardMob = RewardedAd(
        adUnitId: AdHelper.turnRewardAdUnitId,
        request: AdRequest(),
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              print('Ad loaded');
              _isReadyReward = true;
            },
            onAdFailedToLoad: (Ad ad , LoadAdError error){
              ad.dispose();
              _isReadyReward = false;
              print('RewardAd failed to load : $error');
            },
            onAdOpened: (Ad ad) => print('RewardAd opened.'),
            onAdClosed : (Ad ad) async{
              ad.dispose();

              print('RewardAd closed.');
              createTurnAdmob();
            },
            onApplicationExit: (Ad ad) => print('Left application.'),
            onRewardedAdUserEarnedReward: (RewardedAd ad , RewardItem reward){
              print(reward.type);
              print(reward.amount);
              print('Reward earned : $reward');
            }
        )
    )..load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createTurnAdmob();
  }

  @override
  Widget build(BuildContext context) {

    if(gameNext.gameInfo.currentTurn >= gameNext.gameInfo.maximumTurn && (gameNext.gameInfo.progress == 'finished'))
    {
      isCompletedGame = true;
    }

    mainTitle = isCompletedGame ? '완료된 게임이 있습니다. 확인해 보세요.' :
    '${gameNext.finishedUsers.last.nickname} 님이 보내온 그림이 있네요.';

    return Scaffold(
      body: SafeArea(
          child: Container(
            width: double.infinity,
              height: double.infinity,
              child:
                 Column(
                  children: <Widget>[
                    Text(
                      mainTitle,
                      style: kTitleTextStyle),
                     Expanded(
                        child: Center(
                            child: animation ?
                            Container(
                                child: Image.asset('images/received_mail.gif')) :
                            IconButton(
                              icon: Icon(Icons.email),
                              iconSize: 100,
                              onPressed: () async{
                                //게임 완료 시
                                if(isCompletedGame){
                                  //광고
                                  //admob.showRewardAd();
                                  if(_isReadyReward){
                                    _completeRewardMob.show();
                                  }else{
                                    _completeRewardMob.load();
                                  }
                                  Get.offNamed('/history/multiImg', arguments: gameNext );
                                }else{
                                  //admob.showInterstitialAd();
                                  Get.offNamed('/game/singleImg', arguments: gameNext );
                                }
                              },
                            ),
                          ),
                        )]
                      )
                ),
              ),
      );
  }
}

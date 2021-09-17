import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:handover/constants.dart';
import 'package:get/get.dart';
import 'package:handover/widget/profile_area.dart';
import 'package:handover/utils/admob_manager.dart';

class UserScreen extends StatefulWidget {

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  AdMobManager admob = AdMobManager();

  bool _isLoading = false;

  @override
  void initState() {
    admob.init(rewardListener,rewardListener);
    // TODO: implement initState
    super.initState();
  }

  final AdListener rewardListener = AdListener(
      onAdLoaded: (Ad ad) => print('Ad loaded'),
      onAdFailedToLoad: (Ad ad , LoadAdError error){
        ad.dispose();
        print('RewardAd failed to load : $error');
      },
      onAdOpened: (Ad ad) => print('RewardAd opened.'),
      onAdClosed : (Ad ad){
        ad.dispose();
        print('RewardAd closed.');
      },
      onApplicationExit: (Ad ad) => print('Left application.'),
      onRewardedAdUserEarnedReward: (RewardedAd ad , RewardItem reward){
        print(reward.type);
        print(reward.amount);

        print('Reward earned : $reward');
      }
  );

  @override
  Widget build(BuildContext context) {

    var box = GetStorage();
    var userId = box.read('userid');

    return Scaffold(
        backgroundColor: backgroundColour,
              body: SafeArea(
                child: ModalProgressHUD(
                  inAsyncCall: _isLoading,
                  color: backgroundColour,
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                            child: Text('내 정보' , style: kAppbarTextStyle)),
                        Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<UserController>(context , listen: false).logout();
                              },
                                child: Text('로그아웃' , style: kRegularTextStyle))),
                        SizedBox(
                          height: 20
                        ),
                        //Avatar Image + nickname + lv + progress
                          Consumer<UserController>(
                            builder: (context , userController , child ) =>
                                ProfileArea(context: context ,
                                  nickname: userController.user.kakaoAccount.profile.nickname,
                                  profileImageUrl: userController.user.kakaoAccount.profile.profileImageUrl.toString()),
                          ),
                        SizedBox(
                          height: 46,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          decoration: BoxDecoration(
                            color: boxBackgroundColour,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  GameList list = await Provider.of<GameController>(context , listen: false).getGameList('mine', userId.toString() , '0');

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  Get.toNamed('/history/grid' , arguments: list);
                                  },
                                child: Container(
                                  child: Column(
                                  children: [
                                  Text('16',style: boxNumberTextStyle),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                      child: Text('만든 게임' , style: boxDescTextStyle))
                                  ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                   GameList list = await Provider.of<GameController>(context , listen: false).getGameList('others', userId.toString() , '0');

                                  setState(() {
                                    _isLoading = false;
                                  });

                                   Get.toNamed('/history/grid' , arguments: list);
                                   },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text('32',style: boxNumberTextStyle),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text('참여했던 게임' ,style:boxDescTextStyle))
                                    ],
                                  ),
                                ) ,
                              ),
                              GestureDetector(
                                onTap: () async{
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  GameList list = await Provider.of<GameController>(context , listen: false).getGameList('ing', userId.toString(),'0');

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  Get.toNamed('/history/progress' , arguments: list);
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text('8',style: boxNumberTextStyle),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text('진행중인 게임' , style:boxDescTextStyle))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                                Expanded(
                                    flex: 8,
                                  child: Text('게임 참여 허용',style: TextStyle(
                                      color: Color(0xff1d1d1f),
                                      fontSize: 16,
                                      fontFamily: 'AppleSDGothicNeo'
                                  ))
                                ),
                                Expanded(
                                    flex : 2,
                                    child: Switch(value: true, onChanged: (bool){
                                  }),
                                ),
                          ],
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.white38,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                                Expanded(
                                    flex: 8,
                                    child: Text('조르기 허용',style: TextStyle(
                                      color: Color(0xff1d1d1f),
                                      fontSize: 16,
                                      fontFamily: 'AppleSDGothicNeo'
                                    ))
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Switch(value: false, onChanged: (bool){
                                  }),
                                ),
                          ],
                          ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.white38,
                        ),
                        Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    flex: 8,
                                    child: Text('닉네임 노출 허용',style: TextStyle(
                                        color: Color(0xff1d1d1f),
                                        fontSize: 16,
                                        fontFamily: 'AppleSDGothicNeo'
                                    ))
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Switch(value: false, onChanged: (bool){
                                  }),
                                ),
                              ],
                            ),
                        ],
                    ),
                  ]),
              ),
                ),
          )
    );
  }
}





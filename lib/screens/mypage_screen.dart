import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/history_pic_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/widget/inggame_view.dart';
import 'package:handover/widget/new_profile_area.dart';
import 'package:handover/widget/profile_area.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants.dart';
import 'dart:io';

class MypageScreen extends StatefulWidget {
  @override
  _MypageScreenState createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {

  bool _isLoading = false;
  GameList list;
  var listSize = 0;
  final box = GetStorage();
  var userId;

  RefreshController _ingRefreshController = RefreshController(initialRefresh: true);

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefreshIngGameList();
  }

  void _onRefreshIngGameList() async{

    userId = box.read('userid').toString();

    setState(() {
      _isLoading = true;
    });

    await Provider.of<HistoryPicController>(context , listen: false).requestIngChainList('0');

    setState(() {
      _isLoading = false;
    });

    _ingRefreshController.refreshCompleted();

  }

  void _onLoadIngGameList() async{

    await Provider.of<HistoryPicController>(context , listen: false).requestIngAddChainList();

    _ingRefreshController.loadComplete();

  }

  @override
  Widget build(BuildContext context) {

   bool randomAccept = false;
   bool jorukiAccept = false;
   bool nicknameShow = false;

    void showSettingDialog(){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                width: 300,
                height: 380,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0 , right: 25.0 , top : 5.0 , bottom: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () =>{  Navigator.pop(context) } ,
                          icon: Icon(Icons.clear , size: 20, color: Colors.black),
                        ),
                      ),

                      Center(
                        child: Text('셋팅' , style : TextStyle(fontSize: 20 ,  fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(height: 15),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('모르는 사람 게임 참여 허용'),
                         Switch(
                           value: randomAccept,
                           onChanged: (value){
                             setState(() {
                               randomAccept=value;
                               print(randomAccept);
                             });
                           },
                           activeTrackColor: Colors.lightGreenAccent,
                           activeColor: Colors.green,
                         ),
                       ],
                     ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text('조르기 받기 허용'),
                          Switch(
                            value: jorukiAccept,
                            onChanged: (value){
                              setState(() {
                                jorukiAccept=value;
                                print(jorukiAccept);
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text('닉네임 노출 허용'),
                          Switch(
                            value: nicknameShow,
                            onChanged: (value){
                              setState(() {
                                nicknameShow=value;
                                print(nicknameShow);
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),

                      FlatButton(
                          onPressed: () => {},
                          child: Text('게임 탈퇴')),

                      GestureDetector(
                        onTap: ()  {
                           WebView.platform = SurfaceAndroidWebView();
                           WebView(
                             initialUrl: 'https://flutter.dev',
                           );
                        },
                          child: Text('이용약관',style: TextStyle(fontWeight: FontWeight.w500 , fontStyle: FontStyle.italic)))
                    ],
                  ),
                ),
              ),
            );
          });
    }



    return Scaffold(
        backgroundColor: backgroundColour,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
          color:Colors.black
          ),
          backgroundColor: backgroundColour,
          title: Text('my page', style: kAppbarTextStyle)
        )),
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () async{
                              bool isSuccess = await Provider.of<UserController>(context , listen: false).logout();

                              if(isSuccess)
                                Get.toNamed('/login');
                            },
                            child: Text('로그아웃' , style: kRegularTextStyle))),
                    SizedBox(
                        height: 20
                    ),
                    //Avatar Image + nickname + lv + progress
                    Consumer<UserController>(
                      builder: (context , userController , child ) =>
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              NewProfileArea(
                                  context: context ,
                                  radius: 145.0,
                                  width: 120.0,
                                  height: 120.0,
                                  lv_percent: 0.6,
                                  nickname: userController.user.kakaoAccount.profile.nickname,
                                  profileImageUrl: userController.user.kakaoAccount.profile.profileImageUrl.toString()),
                              IconButton(
                                  icon: Icon(Icons.settings , size: 25),
                                  onPressed: () {
                                    showSettingDialog();
                                  }
                              ),
                            ],
                          )
                    ),
                    SizedBox(
                      height: 46,
                    ),
                    Text('진행중인 게임 현황'),
                    Expanded(
                           child: ModalProgressHUD(
                              inAsyncCall: _isLoading,
                              color: backgroundColour,
                              child:
                                 Consumer<HistoryPicController>(
                                   builder:(context , hs , child ) =>
                                   hs.ingList.isEmpty ? Center(child: Text('진행중인 게임이 없습니다.')) :
                                   SmartRefresher(
                                     scrollDirection: Axis.vertical,
                                     enablePullDown: true,
                                     enablePullUp: true,
                                     controller: _ingRefreshController,
                                     onRefresh: _onRefreshIngGameList,
                                     onLoading: _onLoadIngGameList,
                                     header: ClassicHeader(
                                       iconPos: IconPosition.top,
                                       outerBuilder: (child) {
                                         return Container(
                                           width: 180.0,
                                           child: Center(
                                             child: child,
                                           ),
                                         );
                                       },
                                     ),
                                     footer: ClassicFooter(
                                       iconPos: IconPosition.top,
                                       outerBuilder: (child) {
                                         return Container(
                                           width: 180.0,
                                           child: Center(
                                             child: child,
                                           ),
                                         );
                                       },
                                     ),
                                     child: ListView.builder(
                                     scrollDirection: Axis.vertical,
                                     itemBuilder: (context , index){
                                       return IngGameView(
                                           imgUrl : hs.ingList[index].finishedUsers.last.imgUrl ,
                                           maxTurn: hs.ingList[index].gameInfo.maximumTurn,
                                           currentTurn: hs.ingList[index].gameInfo.currentTurn,
                                           isMyTurn: hs.ingList[index].nextUser.id == userId? true : false,
                                           nextUserName : hs.ingList[index].nextUser.nickname,
                                           onTap: () {
                                             //나의 턴이라면
                                             if(hs.ingList[index].nextUser.id == userId){
                                               //admob.showInterstitialAd();
                                               Get.offNamed('/game/singleImg', arguments: hs.ingList[index] );
                                             }else{

                                             }
                                           },
                                           createdTime : hs.ingList[index].gameInfo.createdTime);
                                     },
                                     itemCount: hs.ingList.length,
                                     ),
                                   ),
                                 ),
                               ),
                         ),
                        ],
                      ),
                    ),
                  ),
        );
  }
}

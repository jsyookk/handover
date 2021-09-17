import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/controllers/history_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/widget/inggame_view.dart';
import 'package:handover/widget/new_inggame_view.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import '../../constants.dart';

class StarterScreen extends StatefulWidget {
  @override
  _StarterScreenState createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  final HistoryController histroyCtrl = Get.find();
  var arg = Get.arguments as GameNext;

  bool _isLoading = false;
  final box = GetStorage();
  var userId;

  RefreshController _ingRefreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userId = box.read('userid').toString();

    _onRefreshIngGameList();

  }

  void _onRefreshIngGameList() async{

    setState(() {
      _isLoading = true;
    });

    await histroyCtrl.fetchIngChainList();

    setState(() {
      _isLoading = false;
    });

    _ingRefreshController.refreshCompleted();

  }

  void _onLoadIngGameList() async{
    await histroyCtrl.fetchAddIngChainList();

    _ingRefreshController.loadComplete();

  }

  @override
  Widget build(BuildContext context) {

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
              title: Text('${'start game'.tr}', style: kAppbarTextStyle)
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 50
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text('${'new game'.tr}' , style:kSendButtonTextStyle),
                      onPressed: (){
                            Get.offNamed('/game/select');
                      })
                ),
              ),
              SizedBox(
                  height: 50
              ),
              Center(
                child: Text('${'progress game'.tr}' , style: TextStyle(
                    fontFamily: 'AppleSDGothicNeo-ExtraBold',
                    fontSize: 23,
                    color :  Colors.blue , fontWeight: FontWeight.bold
                )),
              ),

          Obx(() {
            return Expanded(
              child: histroyCtrl.ingList.isEmpty ?
              Center(
                  child: Text('${'no games'.tr}'))
                  :
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
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  itemBuilder: (context, index) {
                    return NewIngGameView(
                        imgUrl: histroyCtrl.ingList[index].finishedUsers
                            .last.imgUrl,
                        maxTurn: histroyCtrl.ingList[index].gameInfo
                            .maximumTurn,
                        currentTurn: histroyCtrl.ingList[index].gameInfo
                            .currentTurn,
                        isReceivedTurn: histroyCtrl.ingList[index].gameInfo.id == arg?.gameInfo?.id ? true : false,
                        isMyTurn: histroyCtrl.ingList[index].nextUser.id ==
                            userId ? true : false,
                        nextUserName: histroyCtrl.ingList[index].nextUser
                            .nickname,
                        onTap: () {
                          //나의 턴이라면
                          if (histroyCtrl.ingList[index].nextUser.id ==
                              userId) {
                            //admob.showInterstitialAd();
                            Get.offNamed('/game/draw',
                                arguments: histroyCtrl.ingList[index]);
                          }
                        },
                        userId: userId,
                        createdTime: histroyCtrl.ingList[index].gameInfo.createdTime,
                        game:histroyCtrl.ingList[index]);
                  },
                  itemCount: histroyCtrl.ingList.length,
                ),
              ),
            );})
            ],
          ),
        ),
      ),
    );
  }
}

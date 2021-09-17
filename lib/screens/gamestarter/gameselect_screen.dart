import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_button/group_button.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/utils/admob_manager.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameSelectScreen extends StatefulWidget {
  @override
  _GameSelectScreenState createState() => _GameSelectScreenState();
}

enum ConfirmAction { TURN , KEYWORD }

class _GameSelectScreenState extends State<GameSelectScreen> {


  List<String> gameTypeList = ['${'friendly'.tr}' , '${'random'.tr}'];
  List<String> gameTurnList = ['6','10','20','${'input'.tr}'];
  List<String> gameTurnNumList = ['6','10','20','${'input'.tr}'];

  bool _iskeywordLoading = false;
  var selectedGameType = 'friendly';
  var selectedTurn = '5';
  var selectedKeyword;
  AdListener turnRewardListener ;
  AdListener keywordRewardListener;
  RewardedAd _turnRewardMob;
  RewardedAd _keywordRewardMob;
  bool _isTurnRewardAdReady = false;
  bool _isKewordRewardAdReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //AdmobManager init
    createKeywordAdMob();
    createTurnAdmob();

    //request Keyword
    _requestKeywords();
  }

  void createTurnAdmob(){

    _turnRewardMob = RewardedAd(
        adUnitId: AdHelper.turnRewardAdUnitId,
        request: AdRequest(),
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              print('Ad loaded');
              _isTurnRewardAdReady = true;
            },
            onAdFailedToLoad: (Ad ad , LoadAdError error){
              ad.dispose();
              _isTurnRewardAdReady = false;
              print('RewardAd failed to load : $error');
            },
            onAdOpened: (Ad ad) => print('RewardAd opened.'),
            onAdClosed : (Ad ad) async{
              ad.dispose();

              selectedTurn = (await asyncInputDialog(
                  context,
                  '턴 수 입력',
                  '원하는 턴 수를 입력해주세요',
                  '너무 많은 턴 수는 영영 돌아오지 않을 수도..'
              ));

              setState(() {
                gameTurnList.last = selectedTurn;
              });

              print('Selected Turn : $selectedTurn');
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

  void createKeywordAdMob(){

    _keywordRewardMob = RewardedAd(
        adUnitId: AdHelper.keywordRewardAdUnitId,
        request: AdRequest(),
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              print('Ad loaded');
              _isKewordRewardAdReady = true;
            },
            onAdFailedToLoad: (Ad ad , LoadAdError error){
              ad.dispose();
              _isKewordRewardAdReady = false;
              print('RewardAd failed to load : $error');
            },
            onAdOpened: (Ad ad) => print('RewardAd opened.'),
            onAdClosed : (Ad ad) async{
              ad.dispose();

              selectedKeyword = await asyncInputDialog(
                  context,
                  '제시어 입력',
                  '제시어를 입력해주세요.',
                  ''
              );

              await Provider.of<GameController>(context , listen: false).changeCustomKeyword(selectedKeyword);

              print('Selected Keyword: $selectedKeyword');
              print('RewardAd closed.');
              createKeywordAdMob();
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


  void _requestKeywords() async{
    //keywords 호출
    setState(() {
      _iskeywordLoading = true;
    });

    await Provider.of<GameController>(context , listen: false).getKeywords('Sports', 5);
    setState(() {
      //첫번째 키워드 선택
      selectedKeyword = Provider.of<GameController>(context , listen: false).words.first;
      _iskeywordLoading = false;
    });
  }

  Future<String> asyncInputDialog(BuildContext context  , String title , String labelText , String hintText) async {
    String inputValue = '';
    return inputValue = await showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: labelText , hintText: hintText),
                    onChanged: (value) {
                      inputValue = value;
                    },
                  ))
            ],
          ),
          actions: [
            FlatButton(onPressed: (){
              Navigator.of(context).pop(inputValue);
            }, child: Text('OK')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    GameController controller = Get.put(GameController());

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(
            color:Colors.black
            ),
            backgroundColor: backgroundColour,
            title: Text('New Chain', style: kAppbarTextStyle),
            ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(25.0),
            child :
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Text('${'play with'.tr}' , style: kGameStartTextStyle),
                    GroupButton(
                        unselectedTextStyle: kKeywordButtonTextStyle,
                        selectedTextStyle: kKeywordButtonTextStyle,
                        unselectedColor: Colors.white,
                        selectedColor: activeButtonColour,
                        borderRadius: BorderRadius.circular(20.0),
                        spacing: 15,
                        isRadio: true,
                        direction: Axis.horizontal,
                        buttons: gameTypeList,
                        onSelected: (index , isSelected)=> selectedGameType = gameTypeList[index]
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    Text('${'how turn'.tr}' , style: kGameStartTextStyle),
                    GroupButton(
                        unselectedTextStyle: kKeywordButtonTextStyle,
                        selectedTextStyle: kKeywordButtonTextStyle,
                        unselectedColor: Colors.white,
                        selectedColor: activeButtonColour,
                        borderRadius: BorderRadius.circular(20.0),
                        spacing: 15,
                        isRadio: true,
                        direction: Axis.horizontal,
                        buttons: gameTurnList,
                        onSelected: (index , isSelected) {
                          if(index == gameTurnList.length -1){
                             if(!_isTurnRewardAdReady)
                               _turnRewardMob.load();
                             else
                               _turnRewardMob.show();
                          }else{
                            selectedTurn = gameTurnList[index];
                          }
                        }
                    ),

                    SizedBox(
                      height: 25,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${'choose keyword'.tr}' , style: kGameStartTextStyle),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.refresh), onPressed: () =>{ _requestKeywords() }),
                            Container(
                                transform: Matrix4.translationValues(-13.5, -15.5, 0.0),
                                child: Text('(3/5)' ,style: TextStyle(fontSize: 10.0),))
                          ],
                        )
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child:  ModalProgressHUD(
                            color: backgroundColour,
                            inAsyncCall: _iskeywordLoading,
                            child: _keywordGroupButton()
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 45,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('${'start game'.tr}' , style:kSendButtonTextStyle),
                          onPressed: () async{

                                  GameNext gameNext;
                                  final box = GetStorage();
                                  final userId = box.read('userid');

                                  Map<String , dynamic> gameData ={
                                  'gameType' : "everyone",
                                  'maximumTurn' : selectedTurn,
                                  'keyword' : selectedKeyword,
                                  'userid' : userId
                                  };

                                  //게임 생성 API 호출
                                  gameNext = await Provider.of<GameController>(context , listen: false).createChain(gameData);
                                  gameNext.gameInfo.currentTurn=1;
                                  gameNext.finishedUsers.clear();
                                  Get.toNamed('/game/draw' , arguments: gameNext);
                                  })
                    )


                  ],
                )
            )
          ),
        ));
  }

  Widget _keywordGroupButton(){

    return Consumer<GameController>(
      builder: (context , gameController , child) =>
          Container(
            child: gameController.words.length <= 0 ?
            Container():
            Center(
              child:
              GroupButton(
                  unselectedTextStyle: kKeywordButtonTextStyle,
                  selectedTextStyle: kKeywordButtonTextStyle,
                  unselectedColor: Colors.white,
                  selectedColor: activeButtonColour,
                  borderRadius: BorderRadius.circular(20.0),
                  spacing: 15,
                  isRadio: true,
                  direction: Axis.horizontal,
                  buttons: gameController.words,
                  onSelected: (index , isSelected) {
                    if(index == gameController.words.length - 1){
                      if(_isKewordRewardAdReady)
                        _keywordRewardMob.show();
                      else
                        _keywordRewardMob.load();
                    }else{
                      selectedKeyword = gameController.words[index];
                    }
                  }
              ),
            ),
          ),
    );
  }
}

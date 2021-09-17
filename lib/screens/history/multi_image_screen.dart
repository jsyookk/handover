import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/constants.dart';
import 'package:handover/model/user_obj.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/utils/time_utils.dart';
import 'package:handover/widget/new_profile_area.dart';
import 'package:http/http.dart' show get;
import 'package:share/share.dart';


class MultiImageScreen extends StatefulWidget {
  MultiImageScreen({Key key}) : super(key : key);
  @override
  _MultiImageScreenState createState() => _MultiImageScreenState();
}

class _MultiImageScreenState extends State<MultiImageScreen> {

  var arg = Get.arguments as GameNext;
  var currentIndex = 0;
  bool _showProgress = false;
  var elapsedTimeStr ="";
  UserObj _currUserObj;
  BannerAd _bannerAd;
  AdWidget _adWidget;
  List<String> imgList =[];
  List<String> assetList = [
    'https://cdn.sketchpan.com/member/2/20112418/1322714949828/0.png',
    'https://www.artinsight.co.kr/data/news/1704/606566022_45hezJX3_3551661523_voEi3JNR_EC95A0EB8B88EBA994EC9DB4EC8598_EC9B90EBA6AC.gif',
    'https://item.kakaocdn.net/do/e39ff57de7ed86792f135107f241dbd8f43ad912ad8dd55b04db6a64cddaf76d',
    'https://item.kakaocdn.net/do/e8eb9681326f897a2c4864ab895b9d649f17e489affba0627eb1eb39695f93dd',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT183yeSGXOp5qB3cjwey3R8NN7tPckLjRhjg&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPdWSBvYGaCoQpz2EOFAt5mxmsZ9TjrkIibQ&usqp=CAU'
  ];

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

  void _setImageList(){
    if(arg != null){
      arg?.finishedUsers?.forEach((userObj) { imgList.add(userObj.imgUrl); });
    }else{
      imgList = assetList;
    }
  }

  void sharedPicture(List<String> paths) async{
    final RenderBox box = context.findRenderObject() as RenderBox;

      Share.shareFiles(
          paths ,
          text: ' ʕ•ﻌ•ʔ ♡ ${arg.gameInfo.keyword}는 ${arg.finishedUsers.length}명의 사람을 거쳐 이렇게 변했습니다. (▰˘◡˘▰) ' ,
          subject: '지금 참여해보세요.' ,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }

  Future<List<String>> _convertFilePaths() async {

    List<String> urlPaths = List<String>();

    for( int i=0; i < arg.finishedUsers.length; i++){
      try{
        var response = await get(Uri.parse(arg.finishedUsers[i].imgUrl));
        var documentDirectory = await getApplicationDocumentsDirectory();
        var path = documentDirectory.path + "/images";
        var filePath = documentDirectory.path + "/images/$i.jpg";
        await Directory(path).create(recursive: true);
        File file = new File(filePath);
        file.writeAsBytesSync(response.bodyBytes);
        urlPaths.add(filePath);
        print('document share url : ${filePath}');
      }catch(e){
        e.printError(e);
      }finally{

      }
    };

    return urlPaths;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setImageList();
    _bannerAd = _createBannerAD();
    _adWidget = AdWidget(ad : _bannerAd);

    //게임 완료까지 걸린 시간
    var elapsedTime = DateTime.now().millisecondsSinceEpoch - int.parse(arg.gameInfo.createdTime);
    var timeMap = TimeUtils.mapElapsedTimeDDHHMMSS(elapsedTime);
    elapsedTimeStr = '${timeMap['day']}${'days'.tr} ${timeMap['hours']}${'hours'.tr} ${timeMap['min']}${'min'.tr} 동안';
    _currUserObj = arg.finishedUsers[0];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
              color:Colors.black
          ),
          backgroundColor: backgroundColour,
          title: arg!= null ?
                Text('${arg.gameInfo.keyword}',style: kAppbarTextStyle):
                Text('그림', style: kAppbarTextStyle),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>
              [
                //Title
                Text('$elapsedTimeStr ${arg.gameInfo.maximumTurn}${'peoples draw'.tr}'),
                //Icon
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                icon : Icon(Icons.favorite)
                            ),
                            Text('25')
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon : Icon(Icons.wb_sunny)
                            ),
                            Text('5')
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon : Icon(Icons.announcement_rounded)
                          ),
                            Text('20')
                          ]
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async{
                              setState(() {
                                _showProgress = true;
                              });
                              await _convertFilePaths().then((value) => sharedPicture(value));

                              setState(() {
                                _showProgress = false;
                              });
                              //sharedPicture(paths);
                            },
                            icon : Icon(Icons.share_outlined)

                          ),
                        )
                      ]
                    ),
                  ),
                ),
                if (_showProgress) Expanded(
                    flex : 8,
                    child: Center(child: CircularProgressIndicator())) else Expanded(
                  flex : 8,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color : Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                        [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children : [
                                GestureDetector(
                                  onTap : () => Get.toNamed('/history/gridImg?id=${_currUserObj.id}&nickname=${_currUserObj.nickname}'),
                                  child: NewProfileArea(
                                    context: context,
                                    radius: 80.0,
                                    width: 75,
                                    height: 75,
                                    profileImageUrl:_currUserObj == null ? arg.finishedUsers[0].imgUrl : _currUserObj.imgUrl,
                                    nickname: _currUserObj == null ? arg.finishedUsers[0].nickname : _currUserObj.nickname,
                                    lv_percent: 0.0,
                                    level: 5,
                                  ),
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context).style,
                                        children: arg != null && arg.finishedUsers.length > 0 ? <TextSpan> [
                                          TextSpan(text :  _currUserObj == null ? '${arg.finishedUsers[0].ageRange}' : '${_currUserObj.ageRange} ' ,style: kImageViewTextStyle),
                                          TextSpan(text : _currUserObj == null ? '${arg.finishedUsers[0].gender}' : '${_currUserObj.gender} ',style: kImageViewTextStyle),
                                          TextSpan(text :' 양평사는 \n' ,style: kImageViewTextStyle),
                                          TextSpan(text :_currUserObj == null ? '${arg.finishedUsers[0].nickname}' : '${_currUserObj.nickname} 님이 \n',style: kImageViewTextStyle),
                                          TextSpan(text :' 발로 그린 그림입니다.',style: kImageViewTextStyle),
                                        ]:
                                        <TextSpan> [
                                          TextSpan(text :' ',style: kImageViewTextStyle),
                                        ]
                                    ))
                              ]
                          ),

                          Divider(),
                          Expanded(
                            child: Swiper(
                                onIndexChanged: (index)  {
                                  currentIndex = index;
                                  setState(() {
                                    _currUserObj = arg.finishedUsers[index];
                                  });

                                },
                                itemWidth: MediaQuery.of(context).size.width * 1.0,
                                itemHeight: MediaQuery.of(context).size.width * 1.0,
                                layout: SwiperLayout.STACK,
                                itemCount: imgList.length,
                                viewportFraction: 0.8,
                                scale: 1.0,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context , int index){

                                  return Container(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget> [
                                            Expanded(
                                              flex: 12,
                                              child:
                                              Center(
                                                child: Stack(
                                                  children :<Widget>[
                                                    Card(

                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          side: BorderSide(color : Colors.black  , width: 2.0)
                                                        ),
                                                        child: Image.network(
                                                            imgList[index],
                                                            fit: BoxFit.fill)),
                                                    /*
                                                    Container(
                                                      alignment: Alignment.topRight,
                                                      child: arg.finishedUsers[index].type == 'word' ?
                                                      RotationTransition(
                                                          turns: new AlwaysStoppedAnimation(25/360),
                                                          child: Text('Word',style: TextStyle(fontSize: 24 , fontWeight: FontWeight.w700))) :
                                                      RotationTransition(
                                                          turns: new AlwaysStoppedAnimation(25/360),
                                                          child: Text("Draw" , style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700))),
                                                    ),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                                child: Text('${currentIndex + 1} / ${arg.gameInfo.maximumTurn}'))
                                          ]));
                                }
                            ),
                          ),

                      ])
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      alignment: Alignment.center,
                      child: _adWidget,
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble()
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


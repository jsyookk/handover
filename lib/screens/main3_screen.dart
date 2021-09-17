import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/history_controller.dart';
import 'package:handover/screens/dialog/settitng_dialog.dart';
import 'package:handover/screens/dialog/one_message_dialog.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/utils/firebase_notification_handler.dart';
import 'package:handover/widget/card_view.dart';
import 'package:handover/widget/circle_button.dart';
import 'package:handover/widget/new_profile_area.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import '../constants.dart';
import 'dialog/singo_dialog.dart';

class Main3Screen extends StatefulWidget {
  @override
  _Main3ScreenState createState() => _Main3ScreenState();
}

class _Main3ScreenState extends State<Main3Screen> {

  final HistoryController histroyCtrl = Get.find();
  //final fcm = FirebaseMessaging.instance;
  FirebaseNotificationHandler firebaseNotificationHandler = new FirebaseNotificationHandler();
  bool _isBestPickLoading = false;
  int _bestPickIndex = 0;
  String _myId;
  String _nickname;
  BannerAd _bannerAd;
  AdWidget _adWidget;
  final List<Permission> _permissions = [
    Permission.manageExternalStorage ,
    Permission.storage,
    Permission.notification ,
    Permission.location];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotificationHandler.setupFirebase(context);
    });
    //_firebaseMessaging_Listener();
    _bannerAd = _createBannerAD();
    _adWidget = AdWidget(ad : _bannerAd);
    _initDynamicLinks();
    loadBestPickData();
    getMyTurnCnt();

    final box = GetStorage();
    _myId = box.read('userid').toString();
    _nickname = box.read('nickname').toString();
    _checkPermission(_permissions);
    //ever(histroyCtrl.myTurnCnt , (_) => print('myTurn count is ${histroyCtrl.myTurnCnt}'));
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

  /*
  void _firebaseMessaging_Listener() async{


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
          var gameUid = message.data['json'].toString();

        //3초 딜레이 후에 호출
        Future.delayed(const Duration(milliseconds: 1500), () async {
          GameNext gameNext = await Provider.of<GameController>(context , listen: false).getByGameUidGame(gameUid);

          print('on message background : ${gameNext.toString()}');
          Get.offNamed('/game/receive', arguments: gameNext);

        });
      }
    });

    // Initialize the [FlutterLocalNotificationsPlugin] package.
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    /*await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
     */
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      var gameUid = message.data['json'].toString();

      //3초 딜레이 후에 호출
      //Future.delayed(const Duration(milliseconds: 1500), () async {
      //GameNext gameNext = await Provider.of<GameController>(context , listen: false).getByGameUidGame(gameUid);

      //print('on message : ${gameNext.toString()}');
      //Get.offNamed('/game/receive', arguments: gameNext);
      Get.offNamed('/game/receive', arguments: gameUid);
      //});

      if( notification != null && android != null){
        /*
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));*/
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      var gameUid = message.data['json'].toString();

      //1초 딜레이 후에 호출
      //Future.delayed(const Duration(milliseconds: 1500), () async {
      //GameNext gameNext = await Provider.of<GameController>(context , listen: false).getIngGame(gameUid);
      //print('on message opened app : ${gameNext.toString()}');
      //Get.offNamed('/game/receive', arguments: gameNext);
      //});

      Get.offNamed('/game/receive', arguments: gameUid);
    });

    //Get fcm token
    fcm.getToken().then(_tokenRefresh , onError: (error){
      print("fcm Token get failure : $error");
    });

    //refreshToken
    fcm.onTokenRefresh.listen(_tokenRefresh , onError: (error){
      print("fcm Token refresh failure. : $error");
    });

    //if( Platform.isIOS) _ios_permission();
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    await Firebase.initializeApp();
    var gameUid = message.data['json'].toString();
    /*
    //1.5초 딜레이 후에 호출
    Future.delayed(const Duration(milliseconds: 1500), () async {
      GameNext gameNext = await Provider.of<GameController>(context , listen: false).getByGameUidGame(gameUid);

      print('on message background : ${gameNext.toString()}');
      Get.offNamed('/game/receive', arguments: gameNext);

    });*/
    Get.offNamed('/game/receive', arguments: gameUid);
    print('Handling a background message : ${message.messageId}');
  }

  void _tokenRefresh(String newToken) async{
    assert(newToken != null);

    print('fcm token: $newToken');
    final box = GetStorage();
    final userId = box.read('userid');
    final String oldToken = box.read('token');

    //register userid , token

    await box.write('token', newToken);
    print('register uuid : $userId');
    print('register fcm token: $newToken');

    Provider.of<GameController>(context , listen: false).registerUser({
      "userid" : userId,
      "token" : newToken
    });
  }*/

  void loadBestPickData() async{

    setState(() {
      _isBestPickLoading = true;
    });

    await histroyCtrl.fetchBestPickList();

    setState(() {
      _isBestPickLoading = false;
    });

  }

  void getMyTurnCnt() async{

    await histroyCtrl.fetchIngChainCnt();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex : 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () =>{
                                    Get.toNamed('/profile')
                                  },
                                  child: Text('${'no ads'.tr}' , style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic))),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Stack(
                                        children :[
                                          IconButton(icon : Icon(Icons.all_inbox_rounded , size: 35),
                                            onPressed: () {
                                              Get.toNamed('/history/gridImg?id=$_myId&nickname=$_nickname');
                                            }),
                                          Positioned(
                                              left: -0.3,
                                              child: CircleButton(
                                                  width: 25,
                                                  height: 25,
                                                  color: Colors.redAccent,
                                                  text: '3',
                                                  fontSize : 10.0
                                              ))

                                    ]),
                                    Text('${'gallery'.tr}'),
                                    IconButton(icon: Icon(Icons.settings , size : 35), onPressed: () {
                                      showDialog(context: context, builder: (BuildContext context) =>  SettingDialog());
                                    }),
                                    Text('${'setting'.tr}')
                                ]),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NewProfileArea(
                                  context: context ,
                                  radius: 130.0,
                                  width: 125.0,
                                  height: 125.0,
                                  lv_percent: 0.0,
                                  nickname: 'test',
                                  profileImageUrl:'https://imgur.com/I80W1Q0.png' ,
                                ),
                                Obx((){
                                  return Container(
                                  transform: Matrix4.translationValues(0.0, -28.0, 0.0),
                                  child: Stack(
                                      overflow: Overflow.visible,
                                      children:[
                                        SizedBox(
                                            width: 200,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                  ),
                                                ),
                                                child: Text('${'play'.tr}' , style:kSendButtonTextStyle),
                                                onPressed: (){
                                                  Get.toNamed('/game/starter');
                                                })
                                        ),

                                          Positioned(
                                              top: -10,
                                              right: 8,
                                              child: CircleButton(
                                                width: 30,
                                                height: 30,
                                                color: Colors.amber,
                                                text: '${histroyCtrl.myTurnCnt}',
                                                fontSize: 15,
                                              ))

                                      ]),
                                  );},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          color : backgroundColour,
                          child:Row(
                            children: <Widget>[
                              Container(
                                child: Lottie.asset('ani/best_pick.json',
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill
                                ),
                              ),
                              Text('${'best week'.tr}' , style: TextStyle(
                                  fontFamily: 'AppleSDGothicNeo-ExtraBold',
                                  fontSize: 23,
                                  color :  Colors.blue , fontWeight: FontWeight.bold
                              ))
                            ],
                          ),
                        ),

                        Expanded(
                          flex : 3,
                          child:  Container(
                              padding: EdgeInsets.only(bottom: 10.0),
                              color: backgroundColour,
                              width: double.infinity,
                              child: Obx((){
                                    return ModalProgressHUD(
                                        color: backgroundColour,
                                        inAsyncCall: _isBestPickLoading,
                                        child: histroyCtrl.bestPickList.length > 0?
                                        new Swiper(
                                            autoplay: true,
                                            itemWidth: 80,
                                            itemHeight: 220,
                                            layout: SwiperLayout.DEFAULT,
                                            itemCount: histroyCtrl.bestPickList.length,
                                            viewportFraction: 0.4,
                                            scale: 1.0,
                                            scrollDirection: Axis.horizontal,
                                            //control: new SwiperControl(),
                                            pagination: SwiperPagination(
                                                alignment: Alignment.bottomCenter,
                                                builder: SwiperPagination.rect
                                            ),
                                            itemBuilder: (BuildContext context , int index){
                                              _bestPickIndex = index;
                                              return Container(
                                                  child: CardView(
                                                    title: histroyCtrl.bestPickList[index].gameInfo.keyword,
                                                    imageUrl: histroyCtrl.bestPickList[index].finishedUsers.last.imgUrl,
                                                    likeCnt: 10,
                                                    funnyCnt: 15,
                                                    declarationCnt: 25,
                                                    onTap: () {
                                                      Get.toNamed('/history/multiImg',
                                                          arguments: histroyCtrl.bestPickList[index]);
                                                    },
                                                  ));
                                            }
                                        ) : Container());
                                  }
                            )),
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
                      ])
              ),
            )));
  }




  // 딥 링크를 통해 실행 시
  void _initDynamicLinks() async{

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    //동적 링크로 앱을 실행한 경우
    if(deepLink != null){
      print(deepLink.path);
      Get.toNamed('/game/receive', arguments : deepLink.path);
    }

    //앱이 실행되어 있는 상태
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async{
          final Uri deepLink = dynamicLink?.link;
          if(deepLink != null){
            print(deepLink.path);
            Get.toNamed('/game/multiImg' , arguments: deepLink.path);
          }
        },
        onError: (OnLinkErrorException e) async{
          print('onLinkError : ${e.message}');
        }
    );

  }

  Future<bool> _checkPermission(List<Permission> permissions) async{

      permissions.forEach((permission) async{
          bool isGranted = await permission.isGranted;
          if(!isGranted){
            if(await permission.isDenied){
              //openAppSettings();
            }else{
              print('request permission : ${permission.toString()}');
              _requestPermission(permission);
            }
          }
      });
  }

  Future<bool> _requestPermission(Permission permission) async{

    final PermissionStatus status = await permission.request();
    if(status.isGranted){
      return true;
    }else{
      return false;
    }

  }

}



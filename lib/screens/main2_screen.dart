import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/history_pic_controller.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/firebase_notification_handler.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import '../constants.dart';

class Main2Screen extends StatefulWidget {
  @override
  _Main2ScreenState createState() => _Main2ScreenState();
}

class _Main2ScreenState extends State<Main2Screen> {

  //final fcm = FirebaseMessaging.instance;
  FirebaseNotificationHandler firebaseNotificationHandler = new FirebaseNotificationHandler();
  bool _isBestPickLoading = false;
  int _bestPickIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseNotificationHandler.setupFirebase(context);
    });
    //_firebaseMessaging_Listener();
    _initDynamicLinks();
    loadBestPickData();
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

    await Provider.of<HistoryPicController>(context , listen: false).requestBestPickList();

    setState(() {
      _isBestPickLoading = false;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    flex : 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () =>{},
                            child: Text('NO ADS' , style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic))),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.alternate_email_rounded),
                              Text('1500 Eggs')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color :  Color.fromRGBO(0, 0, 0, 0.85),
                    child:Row(
                      children: <Widget>[
                        Container(
                          child: Lottie.asset('ani/best_pick.json',
                              width: 64,
                              height: 64,
                              fit: BoxFit.fill
                          ),
                        ),
                        Text('금주의  \nBEST PICK' , style: TextStyle(
                            fontFamily: 'AppleSDGothicNeo-ExtraBold',
                            fontSize: 20,
                            color :  Colors.white , fontWeight: FontWeight.bold
                        ))
                      ],
                    ),
                  ),

                  Expanded(
                    flex : 3,
                    child:  Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        color: Color.fromRGBO(0, 0, 0, 0.85),
                        width: double.infinity,
                        height: 230,
                        child: Consumer<HistoryPicController>(
                            builder: (context , picsController , _){
                              return ModalProgressHUD(
                                  color: backgroundColour,
                                  inAsyncCall: _isBestPickLoading,
                                  child: picsController.bestPickList.length > 0?
                                  new Swiper(
                                      autoplay: false,
                                      itemWidth: 80,
                                      itemHeight: 220,
                                      layout: SwiperLayout.DEFAULT,
                                      itemCount: picsController.bestPickList.length,
                                      viewportFraction: 0.4,
                                      scale: 0.8,
                                      scrollDirection: Axis.horizontal,
                                      control: new SwiperControl(),
                                      pagination: SwiperPagination(
                                          alignment: Alignment.bottomCenter,
                                          builder: SwiperPagination.rect
                                      ),
                                      itemBuilder: (BuildContext context , int index){
                                        _bestPickIndex = index;
                                        return Container(
                                            child: GestureDetector(
                                              onTap: () => Get.toNamed('/history/gridImg' ,arguments: picsController.bestPickList[index]),
                                              child: Card(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  child: Image.network( picsController.bestPickList[index].finishedUsers.last.imgUrl , fit: BoxFit.fill)),
                                            ));
                                      }
                                  ) : Container());
                            }
                        )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget> [
                          Align(
                            alignment : Alignment.bottomLeft,
                            child : Container(
                              margin: EdgeInsets.only(bottom: 55.0),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: RaisedButton(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                   onPressed: () {
                                     Get.toNamed('/history/gridImg');
                                   },
                                   child: Text('Gallery'),
                                ),
                              ),
                            )),
                          Align(
                            alignment: Alignment.center,
                            child : SizedBox(
                              width: 120,
                              height: 120,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                onPressed: () {
                                  Get.toNamed('/gamestarter');
                                },
                                child: Text('New chain'),
                          ),
                       )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child : Container(
                              margin: EdgeInsets.only(bottom: 55.0),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                onPressed: () {
                                  Get.toNamed('/mypage');
                                },
                                child: Text('My Page'),
                          ),
                              ),
                            ))
                        ],
                      ),
                    ),
                  )
              ])
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

}

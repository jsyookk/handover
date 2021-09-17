import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/screens/dialog/send_img_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'notication_handler.dart';



enum APP_STATE { ON_OPEND_APP, BACKGROUND, TERMINATION }


class FirebaseNotificationHandler{


  FirebaseMessaging _messaging;
  static BuildContext myContext;

  void setupFirebase(BuildContext context){
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;

  }

  void firebaseCloudMessageListener(BuildContext context) async{

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');
    }else{
      print('User declined or has not accepted permission');
    }

    _messaging.getToken().then(_tokenRefresh , onError: (error){
      print('fcm token get failure : $error');
    });

    _messaging.onTokenRefresh.listen(_tokenRefresh , onError: (error){
        print('fcm token refresh failure : $error');
     });


    //termination
    FirebaseMessaging.instance.getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {

        var gameUid = message.data['json'].toString();
        moveToReceiveScreen(gameUid , APP_STATE.TERMINATION);
     }});

    //Foreground messages
    FirebaseMessaging.onMessage.listen((remoteMessage){
      print('receive $remoteMessage');

      //Navigator to receive screen
      var gameUid = remoteMessage.data['json'].toString();
      moveToReceiveScreen(gameUid , APP_STATE.ON_OPEND_APP );
    });

    //background
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('receive open app : $remoteMessage');

      var gameUid = remoteMessage.data['json'].toString();
      //Navigator to receive screen
      moveToReceiveScreen(gameUid , APP_STATE.BACKGROUND);
    });

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

    Provider.of<GameController>(myContext , listen: false).registerUser({
      "userid" : userId,
      "token" : newToken
    });
  }

   static void moveToReceiveScreen(String gameUid , APP_STATE state) async{
    //진행중인 게임 ID 받아오기
    GameNext gameNext = await Provider.of<GameController>(myContext , listen: false).getByGameUidGame(gameUid);
    if(gameNext != null){
      if(state == APP_STATE.ON_OPEND_APP){
        if(gameNext.gameInfo.currentTurn >= gameNext.gameInfo.maximumTurn && (gameNext.gameInfo.progress == 'finished')) {
          Get.toNamed('/game/receive', arguments: gameNext);
        }else {
            showDialog(context: myContext,
                builder: (BuildContext context) =>
                    SendImgDialog(gameNext , true));
        }
      }else{
        Get.toNamed('/game/starter' , arguments: gameNext);
      }
    }
  }

}
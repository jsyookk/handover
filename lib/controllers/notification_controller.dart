import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:handover/model/game_next.dart';
import 'package:provider/provider.dart';

import 'game_controller.dart';

class NotificationController extends GetxController{

  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  RxMap<String , dynamic> message = Map<String , dynamic>().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void _actionOnNotification(Map<String,dynamic> messageMap){
    message(messageMap);
  }

  void _initNotification(){
    _messaging.requestPermission(alert : true , sound : true , badge: true , provisional: true);
  }

}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/firestore_api_service.dart';
import 'package:handover/model/user_point.dart';

class UserPointController extends ChangeNotifier{

  var userId;
  FireStoreApiService api = FireStoreApiService();
  UserPointObj _pUser;

  UserPointController(){

    final box = GetStorage();
    userId = box.read('userid').toString();

  }

  void registerUser() async{
    //Point User 등록
    _pUser = await api.getUser(userId);
  }

  void addLvPoint(int point){
    _pUser.lv_point += point;
    api.addLvPoint(userId, _pUser.lv_point);
  }

  void addAdPoint(int point){
    _pUser.ad_point += point;
    api.updateAdPoint(userId, _pUser.ad_point);
  }

  void reduceAdPoint(int point){
    _pUser.ad_point -= point;
    api.updateAdPoint(userId, _pUser.ad_point);
  }



}
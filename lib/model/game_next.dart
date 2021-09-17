import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'game_info.dart';
import 'user_obj.dart';

class GameNext{
  GameInfo _gameInfo;
  List<UserObj> _finishedUsers;
  UserObj _nextUser;
  Sys _sys;
  int _timezone;

  GameInfo get gameInfo =>  _gameInfo;
  List<UserObj> get finishedUsers => _finishedUsers;
  UserObj get nextUser => _nextUser;
  Sys get sys => _sys;
  int get timezone => _timezone;

  GameNext(this._gameInfo , this._finishedUsers , this._nextUser , this._sys , this._timezone);

  factory GameNext.fromJson(Map<String , dynamic> json){

    var t_gameInfo = GameInfo.fromJson(json['gameInfo']);
    var t_userList = json['finishedUsers'] as List;
    var t_finishedUsers = t_userList.map((i) => UserObj.fromJson(i)).toList();
    var t_nextUser = UserObj.fromJson(json['nextUser']);
    var t_sys = Sys.fromJson(json['sys']);
    var t_timezone = json['timezone'];

    return GameNext(
         t_gameInfo,
         t_finishedUsers,
         t_nextUser,
         t_sys,
         t_timezone
    );
  }

  Map<String,dynamic> toJson(){

    return{
      "gameInfo" : _gameInfo.toJson(),
      "finishedUsers" : _finishedUsers.map((i) => (i).toJson()).toList(),
      "nextUser" : _nextUser.toJson(),
      "sys" : _sys.toJson(),
      "timezone" : _timezone
    };
  }


}

class Sys{
  String createdTimestamp;
  String endTimestamp;

  Sys({this.createdTimestamp , this.endTimestamp});

  factory Sys.fromJson(Map<String , dynamic> json){
    return Sys(
      createdTimestamp: json['createdTimestamp'],
        endTimestamp: json['endTimestamp']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "createdTimestamp" : createdTimestamp,
      "endTimestamp" : endTimestamp
    };
  }
}
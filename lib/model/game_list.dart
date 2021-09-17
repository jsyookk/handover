import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'game_info.dart';
import 'game_next.dart';
import 'user_obj.dart';

class GameList{

  List<GameNext> _listGame = List<GameNext>();

  List<GameNext> get listGame => _listGame;

  GameList(this._listGame);


  int length(){
    return _listGame.length;
  }

  factory GameList.fromJson(List<dynamic> json){

    List<GameNext> list = new List<GameNext>();

    json.forEach((element) {
      print(element['data']['json']);
      print('list length : ${list.length}');
      list.add(GameNext.fromJson(element['data']['json']));
    });

    return GameList(list);
  }

  Map<String,dynamic> toJson(){
    /*
    return{
      "gameInfo" : _gameInfo.toJson(),
      "finishedUsers" : _finishedUsers.map((i) => (i).toJson()).toList(),
      "nextUser" : _nextUser.toJson(),
      "sys" : _sys.toJson(),
      "timezone" : _timezone
    };*/
  }
}
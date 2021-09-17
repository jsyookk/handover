import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

enum GameProgress {
@JsonValue("created")
    CREATED,
@JsonValue("progress")
    PROGRESS,
@JsonValue('completed')
    COMPLETED,
    ETC
}

enum Gametype {
@JsonValue("everyone")
EVERYONE,
@JsonValue("friendly")
FRIENDLY,
UNKNOWN
}

@JsonSerializable()
class GameInfo{
  String id;
  String createdUserId;
  int currentTurn;
  int maximumTurn;
  String gameType;
  String keyword;
  String category;
  String progress;
  String createdTime;


  GameInfo({
    this.id,
    this.createdUserId,
    this.currentTurn,
    this.maximumTurn,
    this.gameType,
    this.keyword,
    this.category,
    this.progress,
    this.createdTime,

  });

  factory GameInfo.fromJson(Map<String , dynamic> json){
    return GameInfo(
      id : json['id'],
      createdUserId : json['createdUserId'],
      currentTurn : json['currentTurn'],
      maximumTurn : json['maximumTurn'],
      gameType : json['gameType'],
      keyword : json['keyword'],
      category:  json['category'],
      progress : json['progress'],
      createdTime : json['createdTime'],

    );
  }

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "createdUserId" : createdUserId,
      "currentTurn" : currentTurn,
      "maximumTurn" : maximumTurn,
      "gameType" : gameType,
      "keyword" : keyword,
      "category" : category,
      "progress" : progress,
      "createdTime" : createdTime,

    };
  }

}
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/game_api_service.dart';
import 'package:handover/controllers/notification_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/model/game_next.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class GameController extends ChangeNotifier{

  GameNext _gameNext;
  GameNext _receiveGame;
  GameNext get receiveGame => _receiveGame;
  GameNext get gameNext => _gameNext;
  List<String> words = List<String>().obs;


  //다음 게임 넘기기
  Future<bool> fetchGameNext(GameNext next) async => await GameApiServices.postNextChain(next).then(
          (value) => value);

  //유저 아이디 , 토큰 등록
  void registerUser(Map<dynamic , dynamic> data) async => await GameApiServices.postRegisterUser(data);

  //사용자 테이블 등록
  void createUser(String userId) async => await GameApiServices.getCreateUser(userId);

  //파일 업로드
  Future<String> fileUpload(File file , String gameUid) async{
    var url = await GameApiServices.getFileUpload(file , gameUid);

    return url;
  }

  //Keywords 받아오기
  Future<List<String>> getKeywords(String category , int cnt) async{
    words = await GameApiServices.getKeywords(category, cnt);
    words.add('직접입력');
   return words;
  }

  //Keywords 받아오기
  Future<List<String>> getFunnyKeywords() async{
    words = await GameApiServices.getFunnyKeywords();
    words.add('직접입력');
    return words;
  }

  void changeCustomKeyword(String keyword) async{
    words.last = keyword;
  }

  //GameList 받아오기
  Future<GameList> getGameList(String type , String userId , String timestamp) async{

    GameList list = await GameApiServices.getGameList(type, userId , timestamp);

    notifyListeners();
    return list;
  }

  //진행중 게 받아오기
  Future<GameNext> getByGameUidGame(String gameUid) async{

    _receiveGame = await GameApiServices.getIngGame(gameUid);
    return _receiveGame;
  }

  //게임 생성
  Future<GameNext> createChain(Map<dynamic , dynamic> data) async{
    _gameNext  = await GameApiServices.getCreateChain(data);
    return _gameNext;
  }

}
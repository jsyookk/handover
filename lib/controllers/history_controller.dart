
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/game_api_service.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/convert_url_path.dart';
import 'package:provider/provider.dart';

class HistoryController extends GetxController{

  List<GameNext> _bestPickList = List<GameNext>().obs;
  List<GameNext> _mylist = List<GameNext>().obs;
  List<GameNext> _joinList = List<GameNext>().obs;
  List<GameNext> _friendList = List<GameNext>().obs;
  List<GameNext> _ingList = List<GameNext>().obs;
  var _myTurnCnt = RxInt(0);

  String _lastMyListUid;
  String _lastJoinListUid;
  String _lastingListUid;
  String _lastAddJoinListUid;

  bool _bestPickLoading = false;
  bool _myListLoading = false;
  bool _joinListLoading = false;
  bool _friendListLoading = false;
  bool _ingListLoading = false;

  //친구 마지막 목록
  HashMap <String , String> _friendListUidMap = HashMap<String , String>();

  List<GameNext> get bestPickList => _bestPickList != null ? _bestPickList : fetchBestPickList();
  List<GameNext> get mylist => _mylist != null ? _mylist : fetchMakeChainList();
  List<GameNext> get joinList => _joinList != null ? _joinList : fetchJoinGameList();
  List<GameNext> get ingList => _ingList != null ? _ingList : fetchIngChainList();
  List<GameNext> get friendList => _friendList;
  RxInt get myTurnCnt => _myTurnCnt;

  bool get bestPickLoading => _bestPickLoading;
  bool get myListLoading => _myListLoading;
  bool get joinListLoading => _joinListLoading;
  bool get friendListLoading => _friendListLoading;
  bool get ingListLoading => _ingListLoading;

  set bestPickLoading(bool isLoading) => _bestPickLoading = isLoading;
  set myListLoading(bool isLoading) => _myListLoading = isLoading;
  set joinListLoading(bool isLoading) => _joinListLoading = isLoading;
  set friendListLoading(bool isLoading) => _friendListLoading = isLoading;
  set ingListLoading(bool isLoading) => _ingListLoading = isLoading;

  var userId;

  @override
  void onInit(){
    final box = GetStorage();
    userId = box.read('userid').toString();
  }

  Future<RxInt> fetchIngChainCnt() async {


    try {
      _ingListLoading = true;

      GameList list = await GameApiServices.getGameList(
          'ing', userId, '0');

      final myGame = list.listGame.where((f) => f.nextUser.id == userId);
      if( myGame.isNotEmpty){
        _myTurnCnt.value = myGame.length;
      }else{
        _myTurnCnt.value = 0;
      }

      _ingListLoading = false;
      return _myTurnCnt;
    } catch (e) {
      print(e.toString());
    }
  }

  //내 보관함용도 Refresh
  Future<List<GameNext>> fetchMyListRefreshAddJoinList({String id}) async {

    try{
      _myListLoading = true;
      GameList list;
      if(id.isBlank){
        list =  await GameApiServices.getGameList('others', userId , '0');
      }else{
        list =  await GameApiServices.getGameList('others', id , '0');
      }

      //생성된 시간 순 내림차순 정렬
      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
      _lastAddJoinListUid = ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id);

      for(var item in list.listGame){
        _mylist.add(item);
      }

      _myListLoading = false;

      return _mylist;
    }catch(e){
      print(e.toString());
    }

  }

  //내 보관함용도 Loading
  Future<List<GameNext>> fetchMyListAddJoinList({String id}) async {

    try{
      _myListLoading = true;
      GameList list;
      if(id.isBlank){
        list =  await GameApiServices.getGameList('others', userId , _lastAddJoinListUid);
      }else{
        list =  await GameApiServices.getGameList('others', id , _lastAddJoinListUid);
      }

      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
      _lastAddJoinListUid = ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id);

      for(var item in list.listGame){
        _mylist.add(item);
      }

      _myListLoading = false;
      return _mylist;
    }catch(e){
      print(e.toString());
    }
  }

  Future<List<GameNext>> fetchIngChainList() async {

    try {
      _ingListLoading = true;

      GameList list = await GameApiServices.getGameList(
          'ing', userId, '0');

      _ingList.clear();
      for (var item in list.listGame) {
        _ingList.add(item);
      }

      //시간순으로 정렬
      _ingList.sort((a, b) =>
          (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

      //제일 마지막 게임 Id 가져오기
      _lastingListUid = ConvertUrlPath.getLastgameId(_ingList.last.gameInfo.id);

      _ingListLoading = false;
      return _ingList;
    } catch (e) {
      print(e.toString());
    }

  }

  Future<List<GameNext>> fetchAddIngChainList({String timestamp}) async{

    try{
      _ingListLoading = true;

      GameList list = await GameApiServices.getGameList('ing', userId ,_lastingListUid);
      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
      //_mylist.clear();
      for(var item in list.listGame){
        _ingList.add(item);
      }

      //제일 마지막 게임 Id 가져오기
      _lastingListUid = ConvertUrlPath.getLastgameId(_ingList.last.gameInfo.id);

      _ingListLoading = false;
      return _ingList;
    }catch(e){
      print(e.toString());
    }
  }


  Future<List<GameNext>> fetchMakeChainList({String id}) async{

    try{

      _myListLoading = true;
      GameList list;

      if(id.isBlank) {
        list = await GameApiServices.getGameList('mine', userId, '0');
      }else {
        list = await GameApiServices.getGameList('mine', id, '0');
      }
        list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
        _lastMyListUid = ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id);
        //제일 마지막 게임 Id 가져오기
        print('lastMyListUid : $_lastMyListUid');

        _mylist.clear();
        for(var item in list.listGame){
          _mylist.add(item);
        }
      _myListLoading = false;

      return _mylist;

    }catch(e){
      print(e.toString());
    }

  }

  Future<List<GameNext>> fetchAddMakeChainList({String id, String timestamp}) async{

    try{
      _myListLoading = true;
      GameList list;
      if(id.isBlank){
        list = await GameApiServices.getGameList('mine', userId ,_lastMyListUid);
      }else{
        list = await GameApiServices.getGameList('mine', id ,_lastMyListUid);
      }

      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

      //제일 마지막 게임 Id 가져오기
      _lastMyListUid = ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id);

      //_mylist.clear();
      for(var item in list.listGame){
        _mylist.add(item);
      }

      _myListLoading = false;
      return _mylist;

    }catch(e){
      print(e.toString());
    }

  }



  Future<List<GameNext>> fetchJoinGameList() async{

    try{
      _joinListLoading = true;

      GameList list =  await GameApiServices.getGameList('others', userId , '0');

      _joinList.clear();
      for(var item in list.listGame){
        _joinList.add(item);
      }
      //생성된 시간 순 내림차순 정렬
      _joinList.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
      _lastJoinListUid = ConvertUrlPath.getLastgameId(_joinList.last.gameInfo.id);

      _joinListLoading = false;

      return _joinList;
    }catch(e){
      print(e.toString());
    }
  }

  Future<List<GameNext>> fetchAddJoinGameList({String timestamp}) async{


    try{
      _joinListLoading = true;

      GameList list =  await GameApiServices.getGameList('others', userId , _lastJoinListUid);
      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));


      for(var item in list.listGame){
        _joinList.add(item);
      }

      _lastJoinListUid = ConvertUrlPath.getLastgameId(_joinList.last.gameInfo.id);

      _joinListLoading = false;
      return _joinList;
    }catch(e){
      print(e.toString());
    }

  }


  Future<List<GameNext>> fetchFriendList(String friendUserId) async{

    try{
      _friendListLoading = true;

      GameList list =  await GameApiServices.getGameList('mine', friendUserId , '0');
      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

      _friendList.clear();

      for(var item in list.listGame){
        _friendList.add(item);
      }

      //HashMap update( key : userId , value : gameId)
      Map<String , String> map = {friendUserId: ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id)};
      _friendListUidMap.addAll(map);

      _friendListLoading = false;

      return _friendList;

    }catch(e){
      print(e.toString());
    }
  }

  Future<List<GameNext>> fetchAddFriendList(String friendUserId) async{

    try{

      _friendListLoading = false;

      GameList list;
      var lastUid = _friendListUidMap[friendUserId];
      print('friend lastuid : $lastUid');

      if(lastUid.isNotEmpty){
        list =  await GameApiServices.getGameList('mine', friendUserId , lastUid);
      }else{
        list = await GameApiServices.getGameList('mine', friendUserId, '0');
        _friendList.clear();
      }

      list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

      for(var item in list.listGame){
        _friendList.add(item);
      }

      //HashMap update( key : userId , value : gameId)
      _friendListUidMap.update(friendUserId, (value) => ConvertUrlPath.getLastgameId(_friendList.last.gameInfo.id));

      _friendListLoading = true;
      return _friendList;
    }catch(e){
      print(e.toString());
    }

  }

  Future<List<GameNext>>  fetchBestPickList() async{

    try{

      _bestPickLoading = true;

      GameList list  =  await GameApiServices.getBestPick();

      _bestPickList.clear();
      for(var item in list.listGame){
        _bestPickList.add(item);
      }

      _bestPickLoading = false;
      return _bestPickList;
    }catch(e){
      print(e.toString());
    }
  }

}


import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/game_api_service.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/model/game_list.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/convert_url_path.dart';
import 'package:provider/provider.dart';

class HistoryPicController with ChangeNotifier{

  List<GameNext> _bestPickList = List<GameNext>();
  List<GameNext> _mylist = List<GameNext>();
  List<GameNext> _joinList = List<GameNext>();
  List<GameNext> _friendList = List<GameNext>();
  List<GameNext> _ingList = List<GameNext>();

  String _lastMyListUid;
  String _lastJoinListUid;
  String _lastingListUid;

  //친구 마지막 목록
  HashMap <String , String> _friendListUidMap = HashMap<String , String>();

  BuildContext _context;

  List<GameNext> get bestPickList => _bestPickList != null ? _bestPickList : requestBestPickList();
  List<GameNext> get mylist => _mylist != null ? _mylist : requestMakeChainList('0');
  List<GameNext> get joinList => _joinList != null ? _joinList : requestJoinGameList('0');
  List<GameNext> get ingList => _ingList != null ? _ingList : requestIngChainList('0');
  List<GameNext> get friendList => _friendList;

  GameApiServices api = GameApiServices();

  HistoryPicController(BuildContext context){
    _context = context;
    print('history controller created.');
  }

  Future<List<GameNext>> requestIngChainList(String timestamp) async{

    final box = GetStorage();
    final userId = box.read('userid');

    GameList list = await GameApiServices.getGameList('ing', userId.toString() ,'0');

    _ingList.clear();
    for(var item in list.listGame){
      _ingList.add(item);
    }

    _ingList.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

    //제일 마지막 게임 Id 가져오기
    _lastingListUid = ConvertUrlPath.getLastgameId(_ingList.last.gameInfo.id);
    notifyListeners();
    return _ingList;

  }

  Future<List<GameNext>> requestIngAddChainList({String timestamp}) async{

    final box = GetStorage();
    final userId = box.read('userid');
    GameList list = await GameApiServices.getGameList('ing', userId.toString() ,_lastingListUid);
    list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
    //_mylist.clear();
    for(var item in list.listGame){
      _ingList.add(item);
    }

    //제일 마지막 게임 Id 가져오기
    _lastingListUid = ConvertUrlPath.getLastgameId(_ingList.last.gameInfo.id);

    notifyListeners();
    return _ingList;

  }


  Future<List<GameNext>> requestMakeChainList(String timestamp) async{

    final box = GetStorage();
    final userId = box.read('userid');

    GameList list = await GameApiServices.getGameList('mine', userId.toString() ,'0');

    _mylist.clear();
    for(var item in list.listGame){
        _mylist.add(item);
    }

    _mylist.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

    //제일 마지막 게임 Id 가져오기
    _lastMyListUid = ConvertUrlPath.getLastgameId(_mylist.last.gameInfo.id);
    print('lastMyListUid : $_lastMyListUid');
    notifyListeners();
    return _mylist;

  }

  Future<List<GameNext>> requestMakeAddChainList({String timestamp}) async{

    final box = GetStorage();
    final userId = box.read('userid');
    GameList list = await GameApiServices.getGameList('mine', userId.toString() ,_lastMyListUid);
    list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

    //_mylist.clear();
    for(var item in list.listGame){
      _mylist.add(item);
    }

    //제일 마지막 게임 Id 가져오기
    _lastMyListUid = ConvertUrlPath.getLastgameId(_mylist.last.gameInfo.id);

    notifyListeners();
    return _mylist;

  }



  Future<List<GameNext>> requestJoinGameList(String timestamp) async{

    final box = GetStorage();
    final userId = box.read('userid');

    GameList list =  await GameApiServices.getGameList('others', userId.toString() , '0');

    _joinList.clear();
    for(var item in list.listGame){
      _joinList.add(item);
    }
    //생성된 시간 순 내림차순 정렬
    _joinList.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));
    _lastJoinListUid = ConvertUrlPath.getLastgameId(_joinList.last.gameInfo.id);

    notifyListeners();

    return _joinList;
  }

  Future<List<GameNext>> requestJoinAddGameList({String timestamp}) async{

    final box = GetStorage();
    final userId = box.read('userid');

    GameList list =  await GameApiServices.getGameList('others', userId.toString() , _lastJoinListUid);
    list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));


    for(var item in list.listGame){
      _joinList.add(item);
    }

    _lastJoinListUid = ConvertUrlPath.getLastgameId(_joinList.last.gameInfo.id);

    notifyListeners();

    return _joinList;
  }


  Future<List<GameNext>> requestFriendList(String friendUserId, String timestamp) async{

    GameList list =  await GameApiServices.getGameList('mine', friendUserId , '0');
    list.listGame.sort((a,b) => (b.gameInfo.createdTime).compareTo(a.gameInfo.createdTime));

    _friendList.clear();

    for(var item in list.listGame){
      _friendList.add(item);
    }

    //HashMap update( key : userId , value : gameId)
    Map<String , String> map = {friendUserId: ConvertUrlPath.getLastgameId(list.listGame.last.gameInfo.id)};
    _friendListUidMap.addAll(map);

    notifyListeners();

    return _friendList;
  }

  Future<List<GameNext>> requestFriendAddList(String friendUserId) async{

    GameList list;
    var lastUid = _friendListUidMap[friendUserId];
    print('lastuid : $lastUid');

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

    notifyListeners();

    return _friendList;
  }

  Future<List<GameNext>>  requestBestPickList() async{

    GameList list  =  await GameApiServices.getBestPick();

    _bestPickList.clear();
    for(var item in list.listGame){
      _bestPickList.add(item);
    }

    notifyListeners();

    return _bestPickList;
  }
}

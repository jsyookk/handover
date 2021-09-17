import 'package:flutter/foundation.dart';
import 'package:handover/api/kakao_api_service.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'dart:io';

class UserController extends ChangeNotifier{

  final KakaoApi api = KakaoApi();

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  List<Friend> _friends = <Friend>[];
  User _kakaoUser;

  List<Friend> get friends => _friends != null ? _friends : requestFriends();
  User get user => _kakaoUser != null ? _kakaoUser : requestKakaoUser();

  //Kakao 인스톨 여부 확인
  bool get isKakaoInstalled => api.isKakaoInstalled;


  Future<bool> login() async {
    _isLogin = await api.login();

    if(_isLogin){
      await requestKakaoUser();
      await requestFriends();
    }

    return _isLogin;
  }

  Future<bool> autoLoginPossible() async{

    _isLogin = false;

    try{

      OAuthToken token = await AccessTokenStore.instance.fromStore();

      if( token.refreshToken != null ){
        _isLogin = true;
        await requestKakaoUser();
        await requestFriends();
      }else{
        _isLogin = false;
      }

    }catch(e){
      _isLogin = false;
      print(e);
    }

    return _isLogin;
  }

  Future<bool> logout() async{
    bool logoutSuccess = await api.logout();

    if(logoutSuccess){
      _isLogin = false;
    }

    return logoutSuccess;

  }

  Future<bool> needlogin() async{

    var needLogin = await api.needLogin();

    return needLogin;
  }

  Future<User> requestKakaoUser() async{

    if(_isLogin){
      _kakaoUser = await api.requestUser();
    }else{
      await login();
    }
    notifyListeners();
    return _kakaoUser;
  }

  Future<List<Friend>> requestFriends() async{
    if(_isLogin){
      _friends = await api.requestFriends();
    }else{
      await login();
    }
    notifyListeners();
    return _friends;
  }


}
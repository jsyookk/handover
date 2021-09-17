import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/game_api_service.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/controllers/user_point_controller.dart';
import 'package:http/http.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;
  var _autoLoginSuccess = false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    autoLoginCheck();
  }

  void autoLoginCheck() async{
    _autoLoginSuccess = await Provider.of<UserController>(
        context, listen: false).autoLoginPossible();

    if(_autoLoginSuccess){
      Get.offNamed('/');
    }
  }

  Future<UserCredential> signInWithFacebook() async{
    final LoginResult result = await FacebookAuth.instance.login();

    if(result.status == LoginStatus.success){
      print('Facebook Login success');
      final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
      return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    }
  }

  Future<UserCredential> signInWithApple() async {
    bool isAvailable = await AppleSignIn.isAvailable();
    if (!isAvailable) {
      print('apple login is not good');
      return null;
    }

    AuthorizationResult result;

    try{

      result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email , Scope.fullName])
      ]);

    }catch(e){
      print(e);
      return null;
    }

    switch(result.status){
      case AuthorizationStatus.authorized:

        final oAuthProvider = OAuthProvider('apple.com');
        final oAuthCredential = oAuthProvider.credential(
          idToken: String.fromCharCodes(result.credential.identityToken),
          accessToken: String.fromCharCodes(result.credential.authorizationCode)
        );

        try{
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
          return userCredential;
        }catch(e){
          return null;
        }
        break;

      case AuthorizationStatus.error:
        print('Sign in failed : ${result.error.localizedDescription}');
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }

    return null;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColour,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(
                  height: 150.0
              ),
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: 250.0,
                  height: 250.0,
                  child: Image.asset('images/combined-shape.png')
                ),
              ),
              Expanded(
                flex : 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:<Widget>[
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: Container(
                          child: Image.asset('images/google_login.png')

                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    GestureDetector(
                      onTap: () async{

                        if (!_autoLoginSuccess) {

                          bool loginSuccess = await Provider.of<UserController>(
                              context, listen: false).login();

                          if(loginSuccess){
                            final box = GetStorage();
                            final userId = box.read('userid');
                            final token = box.read('token');

                            //register userid , token
                            if (userId != null && token != null) {
                              print('register kakaoid : $userId');
                              print('register token: $token');

                              Provider.of<GameController>(
                                  context, listen: false).registerUser({
                                "userid": userId,
                                "token": token
                              });

                              Provider.of<GameController>(
                                  context, listen: false).createUser(userId.toString());
                              /*
                              Provider.of<UserPointController>(
                                context, listen: false).registerUser();*/
                            }
                            Get.offNamed('/');
                          }else{
                            Get.snackbar("로그인 실패","로그인에 실패 하였습니다.",snackPosition: SnackPosition.TOP);
                          }
                        }
                      },
                      child: Container(
                          child: Image.asset('images/kakao_login.png')
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: signInWithApple,
                      child: Container(
                          child: Image.asset('images/apple_login.png')

                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: signInWithFacebook,
                      child: Container(
                          child: Center(child: Text('${'sign in facebook'.tr}'))

                      ),
                    ),

                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
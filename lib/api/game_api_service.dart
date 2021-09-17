import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/model/game_list.dart';
import 'dart:convert';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/convert_url_path.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GameApiServices{
  static var client = http.Client();

  //register User account
  static Future<Response> postRegisterUser(Map data) async{
      var response = await client.post(Uri.parse(
        'https://nkack2n9cd.execute-api.ap-northeast-2.amazonaws.com/dev/handling-fcm-token'),
          headers: {"Content-Type": "application/json"}, body : json.encode(data));

      if(response.statusCode == 200){
        print('postRegisterUser is success.');
      }else{
        print('postRegisterUser is failed.');
        print(response.body);
      }

  }

  //push test
  static Future<Response> postPushTest(Map data) async{
    var response = await client.post(Uri.parse(
        'https://nkack2n9cd.execute-api.ap-northeast-2.amazonaws.com/toss_t1/toss-game')
     ,body : data);

    if(response.statusCode == 200){
      print('postPushTest is success.');
    }else{
      print('postPushTest is failed.');
      print(response.body);
    }
  }

  //create chain
  static Future<GameNext> getCreateChain(Map GameCreatedata) async {
    var response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/create-chain-v02?keyword=${GameCreatedata['keyword']}'
        '&userid=${GameCreatedata['userid']}&maxturn=${GameCreatedata['maximumTurn']}&gametype=${GameCreatedata['gameType']}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(responseBody);
      return GameNext.fromJson(responseBody);
    } else {
      print('getCreateChain request error');
      print(response.body);
    }
  }

  //create user table
  static Future<Response> getCreateUser(String userId) async {
    print('getCreateUserId : $userId');
    var response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/create-newuser-gametable?userid=$userId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody =
          jsonDecode(utf8.decode(response.bodyBytes));
      print(responseBody);
    } else {
      print('getCreateUser request error');
      print(response.body);
    }
  }

  //save file image
  static Future<String> getFileUpload(File file, String gameUid) async {
    var response = await client.get(Uri.parse(
        'https://8rhh41fcyd.execute-api.ap-northeast-2.amazonaws.com/default/sj0204_getPresignedURL'));

    if (response.statusCode == 200) {
      Map<String, dynamic> uploadUrl = jsonDecode(response.body);
      print(uploadUrl['uploadURL']);

      //upload url 추출
      var url = uploadUrl['uploadURL'].toString().split('?')[0];
      //final box = GetStorage();
      //final userId = box.read('userid');

      var newUrl = ConvertUrlPath.convertUrl(url, gameUid);
      var len = await file.length();
      var nDio = dio.Dio()
        ..interceptors.add(dio.LogInterceptor(
            requestBody: true, responseBody: true, error: true));

      var putResponse = await nDio.put(
          newUrl,
        //uploadUrl['uploadURL'],
        data: Stream.fromIterable(file.readAsBytesSync().map((e) => [e])),
        options: dio.Options(
          contentType: 'image/png',
          headers: {dio.Headers.contentLengthHeader: len},
        ),
      );

      if (putResponse.statusCode == 200) {
        return newUrl;
      } else {
        print('getFileUpload request error');
        print('error + ${putResponse.toString}');
      }
    }
  }

  static Future<GameList> getGameList(String type, String userId,String timeStamp) async {
    final response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/get-game-info-v02?userid=$userId&status=$type&timestamp=$timeStamp'));

    if (response.statusCode == 200) {
      //Map to List
      //var decode = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String , dynamic>;
      var decode = jsonDecode(utf8.decode(response.bodyBytes));
      //print('docode game list : $decode');
      return GameList.fromJson(decode);
    } else {
      print(utf8.decode(response.bodyBytes));
    }
  }

  static Future<GameList> getBestPick() async {
    final response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/retrieve-todays-best-v01'));

    if (response.statusCode == 200) {
      //Map to List
      //var decode = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String , dynamic>;
      var decode = jsonDecode(utf8.decode(response.bodyBytes));
      print('docode game list : $decode');
      return GameList.fromJson(decode);
    } else {
      print(utf8.decode(response.bodyBytes));
    }
  }

  static Future<GameNext> getIngGame(String chainUid) async {
    final response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/get-chain-json?chainuid=$chainUid'));

    if (response.statusCode == 200) {
      print(utf8.decode(response.bodyBytes));
      //Map to List
       var decode =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      //var wordsList = decode['keywords']['words'].cast<String>();
      print("getIng callback : $decode");
      return GameNext.fromJson(decode['data']['json']);
    } else {
      print(utf8.decode(response.bodyBytes));
    }
  }

  static Future<List<String>> getKeywords(String category, int cnt) async {
    final response = await client.get(Uri.parse(
        'https://7922dcnthe.execute-api.ap-northeast-2.amazonaws.com/dev/handle-words?category=$category&count=$cnt'));

    if (response.statusCode == 200) {
      //Map to List
      var decode =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      var wordsList = decode['keywords']['words'].cast<String>();
      print("words : $wordsList");
      return wordsList;
    } else {
      print(utf8.decode(response.bodyBytes));
    }
  }

  static Future<List<String>> getFunnyKeywords() async {
    final response = await client.get(Uri.parse(
        'https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/handle-keywords-v01'));

    if (response.statusCode == 200) {
      //Map to List
      var decode =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      var wordsList = decode['keywords']['words'].cast<String>();
      print("words : $wordsList");
      return wordsList;
    } else {
      print(utf8.decode(response.bodyBytes));
    }
  }

  static Future<bool> postNextChain(GameNext gamenext) async {
    print('finishedUser length : ${gamenext.finishedUsers.length}');
    print('finishedUser imgurl : ${gamenext.finishedUsers.last.imgUrl}');
    print('currentTurn / MaxTurn : ${gamenext.gameInfo.currentTurn} / ${gamenext.gameInfo.maximumTurn}');

    try {
      final response = await client.post(

        Uri.parse('https://l50b132rii.execute-api.ap-northeast-2.amazonaws.com/dev/toss-push-chain-v07')
        ,  headers: {"Content-Type": "application/json"}, body : json.encode(gamenext.toJson()));
      print('${json.encode(gamenext.toJson())}');
      if (response.statusCode == 200) {
        //print(response.body);
        return true;
      } else {
        print('failed nextchain request error');
        //print(response.body);
        return false;
      }
    } catch (e) {
      print('nextchain error : ${e.toString()}');
      return false;
    }
  }


}

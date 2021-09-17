import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:handover/model/game_next.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/template.dart';

class DynamicLinkShare{

  //To-friends
  static void shareWithKakao({String imgUrl , GameNext info}) async{

    try{
      var _deepLink = await getDynamicLink(info);
      print('deepLink ${_deepLink}');

      var _template = _getKakaoTemplate(' ʕ•ﻌ•ʔ 이 그림이 어떻게 변할지 궁금하지 않으세요? ',
          _deepLink.toString(),
          imgUrl?.isNotEmpty ?
          Uri.parse(imgUrl) :
          Uri.parse('https://sjtest0204-upload.s3.ap-northeast-2.amazonaws.com/1615646199558.png'));
      var uri = await LinkClient.instance.defaultWithTalk(_template);
      await LinkClient.instance.launchKakaoTalk(uri);

    }on KakaoAuthException catch(e){
      print(e.toString());
    }on Exception catch(e){
      print(e.toString());
    }

  }

  //To-me
  static void defaultMemo() async{

    FeedTemplate template = FeedTemplate(Content(
        "Default Feed Template",
        Uri.parse("http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png"),
        Link()
    ));

    try{
      await TalkApi.instance.defaultMemo(template);
    }on KakaoAuthException catch(e){
      print(e.toString());
    }on Exception catch(e){
      print(e.toString());
    }
  }

  static DefaultTemplate _getKakaoTemplate(String title , String deeplink , Uri imageUrl){

    Link link = Link(
      webUrl: Uri.parse(deeplink),
      mobileWebUrl: Uri.parse(deeplink)
    );

    Content content = Content(
      title ,
      imageUrl,
      link
    );

    final FeedTemplate template = FeedTemplate(
      content ,
      social: Social(likeCount: 286 , commentCount: 45 , sharedCount: 845),
      buttons: [
        Button('나도 참여하기' , Link(webUrl: Uri.parse(deeplink))),
      ]
    );

    return template;

  }

  static Future<Uri> getDynamicLink(GameNext gameNext) async{

    final DynamicLinkParameters _parameters = DynamicLinkParameters(
        uriPrefix: 'https://coglix.page.link/handover',
        link: Uri.parse('https://coglix.page.link/handover?game=${gameNext?.toJson()}'
        ),
        iosParameters: IosParameters(
            bundleId: 'com.coglix.handover',
            minimumVersion: '1.0.0',
            appStoreId: '1550716504'
        ),
        androidParameters: AndroidParameters(
          packageName: 'com.coglix.handover',
          minimumVersion: 1,
        ),
        googleAnalyticsParameters: GoogleAnalyticsParameters(
            campaign: 'handover-app',
            medium: 'social',
            source: 'orkut'
        ),
        itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
            providerToken: '123456',
            campaignToken: 'token?'
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: '넘겨',
            description: '내가 그린 그림이 전세계를 돌아..'
        )
    );

    try{
      Uri dynamicUrl = await _parameters.buildUrl();
      return dynamicUrl;
    }catch(error){
      print(error);
    }

  }
}
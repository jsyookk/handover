import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:get_storage/get_storage.dart';

class KakaoApi extends GetConnect{

   static const String KAKAO_RESTAPI_KEY='818a3e849b61df2d4c0ad0276c2e8150';

   bool _installed = false;
   bool get isKakaoInstalled => _installed;

   KakaoApi(){
      KakaoContext.clientId = 'bc60f7737e4db28ac9dbc1b0f6aec142';
   }

   String _getGener(Gender gender){
      switch(gender){
         case Gender.MALE: return "남성";
         case Gender.FEMALE : return "여성";
         case Gender.OTHER : return "??";
      }
   }

   String _getAgeRange(AgeRange age){
      switch(age){

         case AgeRange.TEEN: return "10대";
         case AgeRange.TWENTIES : return "20대";
         case AgeRange.THIRTIES : return "30대";
         case AgeRange.FORTIES : return "40대";
         case AgeRange.FIFTIES : return "50대";
         case AgeRange.SIXTIES : return "60대";
         case AgeRange.SEVENTIES : return "70대";
         case AgeRange.EIGHTEES : return "80대";
         case AgeRange.NINTIES_AND_ABOVE : return "90대";
         case AgeRange.UNKNOWN : return "??";

      }
   }

   Future<bool> needLogin() async {
      OAuthToken token = await AccessTokenStore.instance.fromStore();

      if(token.refreshToken == null){
         return true;
      }else{
         requestUser();
         return false;
      }
   }

   Future<bool> login() async {
      try {
         /*
         _installed = await isKakaoTalkInstalled();
         _installed ? await UserApi.instance.loginWithKakaoTalk()
             : await UserApi.instance.loginWithKakaoAccount();*/

         await UserApi.instance.loginWithKakaoAccount();
         await _issueAccessToken();

           var token =  await AccessTokenStore.instance.fromStore();

           if(token.refreshToken != null){
              print('refreshToken : ${token.refreshToken}');
              return true;
           }else{
              return false;
           }
      } on KakaoAuthException catch (e) {
         print(e.toString());
      } on KakaoClientException catch (e) {
         print(e.toString());
      }
      return false;
   }

   Future<bool> logout() async{

      try{

        final UserIdResponse response = await UserApi.instance.logout();
        //var unlinkUserIdResponse = await UserApi.instance.unlink();

        final box = GetStorage();
        final id = box.read('userid');

        if(id == response.id){
           return true;
        }else{
           return false;
        }

      }catch(e){
         print(e.toString());
      }
   }

   Future<bool> _issueAccessToken() async {
      try {
         String authCode = await AuthCodeClient.instance.request();
         AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);

         if (token != null) {
            print('kakao refresh Token ${token.refreshToken}');
            print('kakao access Token ${token.accessToken}');
            AccessTokenStore.instance.toStore(token);
            return true;
         }else{
            print('accessTokenResponse is null');
            return false;
         }
      } catch (e) {
         print(e);
         return false;
      }

   }

   Future<User> requestUser() async {
      try {
        var user = await UserApi.instance.me();

        if(user.kakaoAccount.emailNeedsAgreement || user.kakaoAccount.genderNeedsAgreement){
           await retryAfterUserAgress(['account_eamil' , 'gender']);
        }

         print("getUserAPI ${user.kakaoAccount.profile.nickname}");
         final box = GetStorage();
         box.write('nickname' , user.kakaoAccount.profile.nickname);
         box.write('userid' , user.id);
         box.write('gender' , _getGener(user.kakaoAccount.gender));
         box.write('ageRange',_getAgeRange(user.kakaoAccount.ageRange));

         return user;

      } on KakaoAuthException catch (e) {
            print(e.message);
            Get.toNamed('/login');
      }
   }

   Future<List<Friend>> requestFriends() async {
      try {
         Friends friends = await TalkApi.instance.friends();
         return friends.elements;
      } on KakaoAuthException catch (e) {
         if(e.error == AuthErrorCause.ACCESS_DENIED){
            Get.toNamed('/login');
         }else if(e.error == AuthErrorCause.INVALID_SCOPE){
            print('request friends INVALID_SCOPE');
            retryAfterUserAgress(['friends']);
         }
      } on Exception catch (e){
         retryAfterUserAgress(['friends']);
         print(e);
      }
   }

   Future<void> retryAfterUserAgress(List <String> requiredScopes) async{
      String authCode = await AuthCodeClient.instance.requestWithAgt(requiredScopes);
      AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      await requestUser();
   }


}
import 'dart:convert';

class UserInfo{
  String userUid;
  String fcmToken;
  String nickName;
  int ageRange;
  String region;
  int acceptJorugi;
  int acceptRandom;
  int isBlockedUser;
  int funUserScore;
  int goldHandScore;
  int userLevel;
  String originSNS;
  int reporting;
  int reported;
  int agreeTerms;
  int useSound;
  int userLevelScore;

  UserInfo({
    this.userUid,
    this.fcmToken,
    this.nickName,
    this.ageRange,
    this.region,
    this.acceptJorugi,
    this.acceptRandom,
    this.isBlockedUser,
    this.funUserScore,
    this.goldHandScore,
    this.userLevel,
    this.originSNS,
    this.reporting,
    this.reported,
    this.agreeTerms,
    this.useSound,
    this.userLevelScore
  });

  factory UserInfo.fromJson(Map<String , dynamic> json){
    return UserInfo(
        userUid : json['userUid'],
        fcmToken: json['fcmToken'],
        nickName: json['nickName'],
        ageRange: json['ageRange'],
        region : json['region'],
        acceptJorugi:  json['acceptJorugi'],
        acceptRandom: json['acceptRandom'],
        isBlockedUser: json['isBlockedUser'],
        funUserScore: json['funUserScore'],
        goldHandScore: json['goldHandScore'],
        userLevel: json['userLevel'],
        originSNS : json['originSNS'],
        reporting: json['reporting'],
        reported: json['reported'],
        agreeTerms: json['agreeTerms'],
        useSound : json['useSound'],
        userLevelScore: json['userLevelScore']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "userUid" : userUid,
      "fcmToken" : fcmToken,
      "nickName" : nickName,
      "ageRange" : ageRange,
      "region" : region,
      "acceptJorugi" : acceptJorugi,
      "acceptRandom" : acceptRandom,
      "isBlockedUser" : isBlockedUser,
      "funUserScore" : funUserScore,
      "goldHandScore" : goldHandScore,
      "userLevel" : userLevel,
      "originSNS" : originSNS,
      "reporting" : reporting,
      "reported" : reported,
      "agreeTerms" : agreeTerms,
      "useSound" : useSound,
      "userLevelScore" : userLevelScore
    };
  }
}
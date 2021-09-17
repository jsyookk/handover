import 'dart:convert';

class UserObj{
  String id;
  String nickname;
  String gender;
  String ageRange;
  String pushToken;
  String country;
  int turnNum;
  String type;
  String imgUrl;
  String tossTimestamp;
  String startTimestamp;
  String finishTimestamp;

  UserObj({
    this.id,
    this.nickname,
    this.gender,
    this.ageRange,
    this.pushToken,
    this.country,
    this.turnNum,
    this.type,
    this.imgUrl,
    this.tossTimestamp,
    this.startTimestamp,
    this.finishTimestamp
  });

  factory UserObj.fromJson(Map<String , dynamic> json){
    return UserObj(
        id : json['id'],
        nickname: json['nickname'],
        gender: json['gender'],
        ageRange: json['ageRange'],
        pushToken : json['pushToken'],
        country : json['country'],
        turnNum : json['turnNum'],
        type : json['type'],
        imgUrl : json['imgUrl'],
        tossTimestamp : json['tossTimestamp'],
        startTimestamp : json['startTimestamp'],
        finishTimestamp : json['finishTimestamp']
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "nickname" : nickname,
      "gender" : gender,
      "ageRange" : ageRange,
      "pushToken" : pushToken,
      "country" : country,
      "turnNum" : turnNum,
      "type" : type,
      "imgUrl" : imgUrl,
      "tossTimestamp" : tossTimestamp,
      "startTimestamp" : startTimestamp,
      "finishTimestamp" : finishTimestamp
    };
  }
}
import 'dart:convert';

class UserPointObj{
  String id;
  int level;
  int lv_point;
  int ad_point;
  bool isPaidMoney;
  List<dynamic> purchase_list;

  UserPointObj({
    this.id,
    this.level,
    this.lv_point,
    this.ad_point,
    this.isPaidMoney,
    this.purchase_list
  });

  factory UserPointObj.fromJson(Map<String , dynamic> json){
    return UserPointObj(
        id : json['id'],
        level: json['level'],
        lv_point: json['lv_point'],
        ad_point: json['ad_point'],
        isPaidMoney : json['isPaidMoney'],
        purchase_list: json['purchase_list']
    );
  }

   Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "level" : level,
      "lv_point" : lv_point,
      "ad_point" : ad_point,
      "isPaidMoney" : isPaidMoney,
      "purchase_list" : purchase_list.map((i) => (i).toJson()).toList()
    };
  }
}
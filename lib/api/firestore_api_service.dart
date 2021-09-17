import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handover/model/user_point.dart';

class FireStoreApiService{

  Future<UserPointObj> getUser(String userId) async {
    UserPointObj fetchedUser;

    var doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if(doc.exists){
      fetchedUser = UserPointObj.fromJson(doc.data());
    }else{
      fetchedUser =  UserPointObj(
          id : userId,
          level: 0,
          lv_point: 0,
          ad_point: 0,
          isPaidMoney: false,
          purchase_list: []
      );
      //firebase 에서 해당 userID 검색 후 없으면..
      FirebaseFirestore.instance.collection('users')
          .doc(userId)
          .set(
            fetchedUser.toJson(),
            SetOptions(merge: true)
      ).then((value) {
        print('add user success.');
      });
      }

    return fetchedUser;
  }

  void updateAdPoint(String userId , int point){
    FirebaseFirestore.instance.collection('users').doc(userId).update(
      {
        "ad_point" : point
      }).then((value) => print('ad point updated.'));
  }

  void addLvPoint(String userId , int point){

    FirebaseFirestore.instance.collection('users').doc(userId).update(
        {
          "lv_point" : point
        }).then((value) => print('lv point updated.'));
  }

  void updateUserLevel(String userId , int level){
    FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          "level" : level
        }).then((value) => print('level updated.'));
  }

  void updatePurchaseList(String userId , String itemUid){

    FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          "purchase_list" : FieldValue.arrayUnion(['elements' , 'elements1'])
        }).then((value) => print('purchase_list updated.'));
  }

}
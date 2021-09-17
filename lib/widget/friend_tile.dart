import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handover/constants.dart';

class FriendTile extends StatelessWidget{

  final String myId;
  final String nickName;
  final String thumbnailUrl;
  final int id;
  final Function onTap;

  FriendTile({ this.myId , @required this.id , @required this.nickName , @required this.thumbnailUrl , this.onTap});

  @override
  Widget build(BuildContext context){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(thumbnailUrl)
      ),
      title: Text(nickName , style: kRegularTextStyle),
      trailing: GestureDetector(
        onTap: this.onTap,
          child: Icon(Icons.send)),
      selected: true,
    );

  }


}
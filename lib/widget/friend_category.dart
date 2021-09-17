import 'package:flutter/material.dart';
import 'package:handover/constants.dart';


class FriendCategory extends StatelessWidget {

  final String nickName;
  final String thumbnailUrl;
  final Function onTap;

  FriendCategory({this.nickName , this.thumbnailUrl , this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        child: Column(
          children:<Widget> [
            SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(this.thumbnailUrl.isEmpty ? 'https://imgur.com/I80W1Q0.png':this.thumbnailUrl),
              ),
            ),
            SizedBox(height: 5,),
            Text(nickName , style: kFriendCategoryButtonTextStyle),
          ],
        ),
      ),
    );
  }
}

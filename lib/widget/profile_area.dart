import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

class ProfileArea extends StatelessWidget {

  final BuildContext context;
  final String nickname;
  final String profileImageUrl;

  ProfileArea({@required this.context , this.nickname , this.profileImageUrl});

  @override
  Widget build(BuildContext context) {

    print('build profile ${this.nickname}');
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          SizedBox(
            width: 60,
            height: 60,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(this.profileImageUrl.endsWith('null') ? 'https://imgur.com/I80W1Q0.png' : this.profileImageUrl),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
              this.nickname.isNotEmpty ? this.nickname : 'Nickname',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
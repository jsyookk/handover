import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class NewProfileArea extends StatelessWidget {

  final BuildContext context;
  final String nickname;
  final String profileImageUrl;
  final int level;
  final double width;
  final double height;
  final double radius;
  final double lv_percent;

  NewProfileArea({@required this.context , this.nickname , this.profileImageUrl, this.width , this.height , this.lv_percent , this.level , this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
     child: Stack(
       children: [
         Center(
           child: Container(
             //transform: Matrix4.translationValues(13.0, 13.0, 0.0),
             child: SizedBox(
               width: this.width,
               height: this.height,
               child: CircleAvatar(
                 radius: radius,
                 backgroundColor: Colors.white,
                 backgroundImage: NetworkImage(this.profileImageUrl.endsWith('null') ? 'https://imgur.com/I80W1Q0.png' : this.profileImageUrl),
               ),
             ),
           ),
         ),
         Center(
           child: CircularPercentIndicator(
              radius: radius,
              lineWidth: 6.0,
              percent: lv_percent,
              center : new Text('LV $level'),
              progressColor: Colors.amber,
           ),
         )
       ],
     ),
    );
  }
}
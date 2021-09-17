import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_button/group_button.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/utils/adhelper.dart';
import 'package:handover/widget/custom_toggle_button.dart';
import 'package:handover/widget/new_profile_area.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants.dart';


class SettingDialog extends StatefulWidget {
  @override
  _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {

  List<String> bgSndList = ['배경음 ON' , '효과음 OFF'];
  String selectedBgSnd;
  final String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.only(left : 0.0 , right : 0.0),
        width: screenSize.width * 0.6,
        height: screenSize.height * 0.65,

        child: Stack(
          overflow: Overflow.visible,
            children: [
              Container(
                padding: EdgeInsets.only(top : 18.0 ),
                margin: EdgeInsets.only(top : 13.0 , right : 8.0 , left : 8.0 , bottom: 13.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        NewProfileArea(
                          context: context ,
                          radius: 85.0,
                          width: 80.0,
                          height: 80.0,
                          lv_percent: 0.0,
                          nickname: 'test',
                          profileImageUrl:'https://imgur.com/I80W1Q0.png' ,
                        ),

                        Text('30대 양평사는 \n 김아무개'),

                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    GroupButton(
                        unselectedTextStyle: kSwitchButtonTextStyle,
                        selectedTextStyle: kSwitchButtonTextStyle,
                        unselectedColor: Colors.white,
                        selectedColor: activeButtonColour,
                        borderRadius: BorderRadius.circular(15.0),
                        spacing: 15,
                        isRadio: true,
                        direction: Axis.horizontal,
                        buttons: bgSndList,
                        onSelected: (index , isSelected)=> selectedBgSnd = bgSndList[index]
                    ),

                   SizedBox(
                     height: 15.0,
                   ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Text('랜덤게임 허용'),

                       /*
                       LiteRollingSwitch(
                         value: true,
                         textOn: '켜짐',
                         textOff : '꺼짐',
                         colorOn: Colors.greenAccent[700],
                         colorOff: Colors.redAccent[700],
                         iconOn : Icons.wb_cloudy_rounded,
                         iconOff : Icons.wb_cloudy_outlined,
                         textSize: 10.0,
                         onChanged: (bool state){
                           print('random game accept : $state');
                         },
                       )*/
                       CustomToggleButton(buttonText: "켜짐", icon: Icons.person)
                     ],
                   ),

                    SizedBox(
                      height: 15.0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('조르기 허용'),

                        /*
                        LiteRollingSwitch(
                          value: true,
                          textOn: '켜짐',
                          textOff : '꺼짐',
                          colorOn: Colors.greenAccent[700],
                          colorOff: Colors.redAccent[700],
                          iconOn : Icons.wb_cloudy_rounded,
                          iconOff : Icons.wb_cloudy_outlined,
                          textSize: 15.0,
                          onChanged: (bool state){
                            print('joruki game accept : $state');
                          },
                        )*/

                        CustomToggleButton(buttonText: "켜짐", icon: Icons.person)
                      ],
                    ),

                    SizedBox(
                      height: 15.0,
                    ),

                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('로그아웃' , style:kSendButtonTextStyle),
                          onPressed: () async {
                           bool logout =  await Provider.of<UserController>(context , listen: false).logout();
                              if(logout){
                                Get.offAllNamed('/login');
                              }
                          } ),
                    ),

            ]),
      ),

              GestureDetector(
                onTap: () {
                  Get.toNamed('/terms');
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('이용약관' , style: TextStyle(fontSize: 15.0 , fontStyle: FontStyle.italic , decoration: TextDecoration.underline))
                  ),
                ),
              ),
              Positioned(
                top : -5,
                right: -5,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color : Colors.amber,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Icon(
                        Icons.close,
                        size : 30.0,
                        color : Colors.white
                    ),
                  ),
                ),
              )
    ])));
  }
}

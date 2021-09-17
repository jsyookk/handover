import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:handover/constants.dart';


class MakerProfileScreen extends StatefulWidget {
  @override
  _MakerProfileScreenState createState() => _MakerProfileScreenState();
}

class _MakerProfileScreenState extends State<MakerProfileScreen> {

  final ageRanges = ['10대' , '20대' , '30대' , '40대' , '50대' , '60대'];
  var selectRange;
  var _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
            child: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(
                color:Colors.black
            ),
        backgroundColor: backgroundColour,
        title: Text('프로파일', style: kAppbarTextStyle),
        ),
        ),
        backgroundColor: backgroundColour,
        body: SafeArea(
        child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Center(child: Text('프로필 만들기' , style: TextStyle(fontSize: 25 , color: Colors.blue))),
            SizedBox(
              height: 15,
            ),
            Text('이름을 입력해 주세요.' , style: TextStyle(fontSize: 15 , color : Colors.black)),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0 , horizontal: 15.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter your nickname",
                  hintStyle: TextStyle(color: Colors.grey)
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('내 또래 설정'),

            Padding(
              padding: EdgeInsets.only(left: 15.0 , top: 15.0),
              child: GroupButton(
                  unselectedTextStyle: kKeywordButtonTextStyle,
                  selectedTextStyle: kKeywordButtonTextStyle,
                  unselectedColor: Colors.white,
                  selectedColor: activeButtonColour,
                  borderRadius: BorderRadius.circular(15.0),
                  spacing: 15,
                  isRadio: true,
                  direction: Axis.horizontal,
                  buttons: ageRanges,
                  onSelected: (index , isSelected) {
                      selectRange = ageRanges[index];
                  }
              ),
            ),
            SizedBox(
              height: 35,
            ),

            Center(
              child: SizedBox(
                width: 250,
                height: 60,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                    items:[
                      DropdownMenuItem<String>(
                        child: Text('지역 선택'),
                      ),
                    ],
                      hint: Text('지역 선택',style: TextStyle(fontSize: 15)),
                      onTap: () => {


                      },
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(
                    style: DefaultTextStyle.of(context).style,

                    children:<TextSpan> [
                      TextSpan(text :'이용약관',style: kRegularTextStyle),
                      TextSpan(text :'에 동의합니다.',style: kRegularTextStyle),
                    ]
                )),

                Checkbox(
                    value: _isChecked, onChanged: (value){
                      setState(() {
                        _isChecked = value;
                      });
                })
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: 280,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text('완성' , style:kSendButtonTextStyle),
                      onPressed: (){
                        Get.offNamed('/');
                      })
              ),
            ),
          ],
        ),
        ))
    );

  }
}

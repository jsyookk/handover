import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/api/game_api_service.dart';
import 'package:handover/constants.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/painting_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/model/game_next.dart';
import 'package:handover/model/user_obj.dart';
import 'package:handover/screens/dialog/send_img_dialog.dart';
import 'package:handover/utils/dynamiclink_share.dart';
import 'package:handover/widget/friend_tile.dart';
import 'package:provider/provider.dart';
import 'package:handover/widget/drawable_area.dart';
import 'package:get/get.dart';
import 'package:unicorndial/unicorndial.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:image/image.dart' as image;


enum ConfirmAction { CANCEL , ACCEPT }

class DrawScreen extends StatefulWidget {

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  GlobalKey globalKey = GlobalKey();
  final scaffoldkey = GlobalKey<ScaffoldState>();

  var arg = Get.arguments as GameNext;
  var _imageSaveing = false;
  ui.Image backimg;
  bool isImageloaded = false;
  int selectedUserId = 0;
  String selectedUserNickName = "";
  bool _isButtonDisabled = false;

  @override
  void initState(){
    super.initState();
    //init();

  }

  Future<Null> init() async{
    final drawabbleSize = MediaQuery.of(context).size;
    int drawabbleWidth = (drawabbleSize.height * 0.8).round();
    int drawabbleHeight = (drawabbleSize.width * 0.8).round();
    print("height : $drawabbleHeight width: $drawabbleWidth");
    this.backimg = await loadImage('images/note_h.png',drawabbleHeight, drawabbleWidth);
  }

  Future<ui.Image> loadImage(String imageAssetPath , int height , int width) async{
    final ByteData assetImageBytedata = await rootBundle.load(imageAssetPath);
    image.Image baseSizeImage = image.decodeImage(assetImageBytedata.buffer.asUint8List());
    image.Image resizeImage = image.copyResize(baseSizeImage , height: height , width:  width);
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  void _nextPage() {

    //마지막 턴 이라면
    if(arg.gameInfo.maximumTurn == arg.gameInfo.currentTurn){

      final box = GetStorage();
      final userId = box.read('userid');
      final url = box.read('draw_img');
      final token = box.read('token');

      print('in draw finishedUser len : ${arg.finishedUsers.length}');

      arg.gameInfo.progress='finished';
      arg.sys.endTimestamp = DateTime.now().toIso8601String();

      arg.finishedUsers.add(
          UserObj(
            id: userId.toString(),
            pushToken: token,
            country: 'ko',
            turnNum: arg.gameInfo.currentTurn,
            type: arg.gameInfo.currentTurn % 2 ==0 ? 'word' : "draw",
            imgUrl: url.toString(),
            nickname: box.read('nickname'),
            gender: box.read('gender'),
            ageRange: box.read('ageRange'),
            tossTimestamp: arg.nextUser.tossTimestamp,
            finishTimestamp: DateTime.now().toIso8601String()
        ));

      Provider.of<GameController>(context , listen: false).fetchGameNext(arg);
      Get.offNamed('/' , arguments: arg);
    }else{
      if(!Provider.of<UserController>(context , listen: false).isLogin){
        Provider.of<UserController>(context , listen: false).login();
      }
       showSelectFriend();
      //Get.toNamed('/game/s_friend' , arguments: arg);
    }
  }

  Future<String> _onlyFilesave() async{

    try{
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Directory tempdir = await getApplicationSupportDirectory();
      String tempPath = tempdir.path;
      var filePath = tempPath + 'canvas_image.png';
      var file = await File(filePath).writeAsBytes(pngBytes);

      return filePath.toString();

    }catch(e){
      throw e;
    }
  }

  Future<String> _saveWithS3() async{

    try{
      setState(() {
        _imageSaveing = true;
      });

      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      Directory tempdir = await getApplicationSupportDirectory();
      String tempPath = tempdir.path;
      var filePath = tempPath + 'canvas_image.png';
      var file = await File(filePath).writeAsBytes(pngBytes);

      //Gallery save to image
      //Request permissions if not already granted
      /*
      if (!(await Permission.storage.status.isGranted))
        await Permission.storage.request();

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name : 'good'
      );
      print(result);
      print(file.path);*/
      //파일 전송
      //var saveUrl = await GameApiServices().getFileUpload(file);
      var saveUrl = await Provider.of<GameController>(context , listen: false).fileUpload(file , arg.gameInfo.id);

      if(saveUrl.isNotEmpty){
        print("saved image url: $saveUrl ");
        final box = GetStorage();
        box.write('draw_img', saveUrl);
      }

      setState(() {
        _imageSaveing = false;
      });

      return saveUrl;

    }catch(e){
        throw e;
    }
  }

  List<UnicornButton> _getMultiFloatingButtons(PaintingController controller){
    List<UnicornButton> children = [];

    children.add(_UnicornProfile(label : '펜 선택' , iconData: Icons.create , onPressed: (){
      controller.setPenType(penType.pen);
      controller.setColor(Colors.black);
    } , heroTag: 'pen'));

    children.add(_UnicornProfile(label : '색상 선택' , iconData: Icons.format_paint_outlined, onPressed: (){
      controller.setPenType(penType.pen);
      controller.setColor(Colors.black54);
    },heroTag:'choose color' ));

    children.add(_UnicornProfile(label : '지우개' , iconData: Icons.phonelink_erase_rounded , onPressed: (){
      controller.setPenType(penType.erase);
      controller.setColor(Colors.white);
    } , heroTag: 'clear'));

    children.add(_UnicornProfile(label : '모두 지우기' , iconData: Icons.wifi_protected_setup_outlined , onPressed: ()
    {
      controller.clear();
      controller.setPenType(penType.pen);
      controller.setColor(Colors.black);
    } , heroTag: 'all clear'));

    return children;
  }

  Widget _UnicornProfile({IconData iconData , Function onPressed , String label , String heroTag}){
      return UnicornButton(
        hasLabel: true,
        labelText: label,
        currentButton: FloatingActionButton(
          backgroundColor: Colors.grey[500],
          mini: true,
          child: Icon(iconData),
          onPressed: onPressed,
          heroTag: heroTag,
        ),
      );
  }

  Widget _topPanelPainterTool(PaintingController controller){

    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            controller.setPenType(penType.pen);
            controller.setColor(Colors.black);
          },
          icon : Icon(Icons.create)
        ),
        IconButton(
            onPressed: () {
              controller.setPenType(penType.erase);
              controller.setColor(Colors.white);
        },
            icon : Icon(Icons.format_paint_outlined)
        ),
        /*
        IconButton(
            onPressed: () {
              showSetPenWidthDialog(controller);
              controller.setPenType(penType.pen);
              controller.setColor(Colors.black);
        },
            icon : Icon(Icons.album_outlined)
        ),*/
        Spacer(),
        IconButton(
            onPressed: (){
              controller.clear();
              controller.setPenType(penType.pen);
              controller.setColor(Colors.black);
        },
            icon : Icon(Icons.wifi_protected_setup_outlined)
        ),
      ],
    );
  }


  void sharedPicture() async{
    bool kakaoInstalled = Provider.of<UserController>(context , listen: false).isKakaoInstalled;

    if(!kakaoInstalled){
      final RenderBox box = context.findRenderObject() as RenderBox;
      // meta data share
      var path = await _onlyFilesave();
      Share.shareFiles(
          [path] ,
          text: ' ʕ•ﻌ•ʔ ♡ 이 그림이 어떻게 변할지 궁금하지 않으세요? (▰˘◡˘▰) ' ,
          subject: '지금 참여해보세요.' ,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }else{
      //kakao template share
      String url =  await _saveWithS3();
      await DynamicLinkShare.shareWithKakao(
          imgUrl: url
      );
    }
  }

  void _showAlertDialog(BuildContext context , String nickname) async{

    String result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('$nickname 님에게 다음 차례를 넘기시겠습니까?'),
          actions:<Widget> [
            FlatButton(onPressed: (){
              Navigator.pop(context , ConfirmAction.ACCEPT);
            }, child: Text('네')),
            FlatButton(onPressed: (){
              Navigator.pop(context , ConfirmAction.CANCEL);
            }, child: Text('아니요')),
          ],
        );
      },
    ).then((value) async{
      if (value == ConfirmAction.ACCEPT) {

        final box = GetStorage();
        final userId = box.read('userid');
        final url = box.read('draw_img');
        final token = box.read('token');

        arg.finishedUsers.add(UserObj(
          id: userId.toString(),
          pushToken: token,
          country: 'ko',
          turnNum: arg.gameInfo.currentTurn,
          type: arg.gameInfo.currentTurn % 2 ==0 ? 'word' : "draw",
          imgUrl: url.toString(),
          nickname: box.read('nickname'),
          gender: box.read('gender'),
          ageRange: box.read('ageRange'),
          tossTimestamp: arg.nextUser.tossTimestamp,
          finishTimestamp: DateTime.now().toIso8601String()
        ));
        arg.gameInfo.progress='in progress';
        //현재 턴 + 1
        arg.gameInfo.currentTurn=arg.gameInfo.currentTurn+1;

        //다음 유저 정보 셋팅
        arg.nextUser.id = selectedUserId.toString();
        arg.nextUser.turnNum = arg.gameInfo.currentTurn;
        arg.nextUser.type=  arg.nextUser.turnNum % 2 ==0 ? 'word' : "draw";
        arg.nextUser.nickname = selectedUserNickName;
        arg.nextUser.tossTimestamp = DateTime.now().toIso8601String();

        bool isSuccess = await Provider.of<GameController>(context , listen: false).fetchGameNext(arg);

        if(isSuccess){

          _isButtonDisabled = true;
          scaffoldkey.currentState.showSnackBar(
              SnackBar(
                content: Text('$nickname 님에게 다음 차례를 넘겼습니다' ),
                backgroundColor: Colors.blue,
              )).closed.then((reason){
            Get.offNamed('/' , arguments: arg);
          });

          Navigator.of(context).pop();

        }else{
          scaffoldkey.currentState.showSnackBar(
              SnackBar(
                content: Text('$nickname 님에게 넘기는 도중 오류가 발생하였습니다.' ),
                backgroundColor: Colors.redAccent,

              )).closed.then((reason){
            Get.offNamed('/' , arguments: arg);
          });

          Navigator.of(context).pop();
        }

      }else{
        print("CANCEL");
      }
    });
  }

  void showSelectFriend(){

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Please select a friend' , style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        child: Consumer<UserController>(
                          builder: (context , userController , child){
                            return ListView.separated(
                              separatorBuilder: (context , index){
                                return Divider();
                              },
                              itemBuilder: (context , index){
                                return userController.friends.length > 0 ?
                                  FriendTile(
                                    myId: userController.user.id.toString(),
                                    id: userController.friends[index].id ,
                                    nickName: userController.friends[index].profileNickname,
                                    thumbnailUrl: userController.friends[index].profileThumbnailImage.toString(),
                                    onTap: (){
                                      if(!_isButtonDisabled){
                                        selectedUserId = userController.friends[index].id;
                                        selectedUserNickName = userController.friends[index].profileNickname;
                                        _showAlertDialog(context , userController.friends[index].profileNickname);
                                      }
                                    }) : userController.login();
                              },
                              itemCount: userController.friends.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });


  }

  void showSetPenWidthDialog(PaintingController controller){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              width: 50,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.album , size: 10),
                      onPressed: (){
                        controller.setWidth(0.3);
                        controller.setPenType(penType.pen);
                        controller.setColor(Colors.black);
                        Navigator.of(context).pop();
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.album , size: 12),
                      onPressed: (){
                        controller.setWidth(1.0);
                        controller.setPenType(penType.pen);
                        controller.setColor(Colors.black);
                        Navigator.of(context).pop();
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.album , size: 14),
                      onPressed: (){
                        controller.setWidth(3.0);
                        controller.setPenType(penType.pen);
                        controller.setColor(Colors.black);
                        Navigator.of(context).pop();
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.album , size: 16),
                      onPressed: () {
                        controller.setWidth(5.0);
                        controller.setPenType(penType.pen);
                        controller.setColor(Colors.black);
                        Navigator.of(context).pop();
                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<PaintingController>(
        create: (context) => PaintingController(),
        child: Consumer<PaintingController>(builder: (context, controller, child) {
          return Scaffold(
             key : scaffoldkey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  elevation: 0,
                  iconTheme: IconThemeData(
                      color:Colors.black
                  ),
                  backgroundColor: backgroundColour,
                  title: arg.gameInfo.currentTurn % 2 ==0 ? Text('맞추기', style: kAppbarTextStyle) : Text('그리기', style: kAppbarTextStyle),
                ),
              ),
            backgroundColor: backgroundColour,
            /*
            floatingActionButton: UnicornDialer(
              backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
              parentButtonBackground: activeButtonColour,
              orientation: UnicornOrientation.VERTICAL,
              parentButton: Icon(Icons.list),
              childButtons: _getMultiFloatingButtons(controller),
            ),*/
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () async{
                              showDialog(context: context, builder: (BuildContext context) =>  SendImgDialog(arg , false));
                            },
                            child: Card(
                                elevation: 20,
                                shadowColor: Colors.black38,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: arg.finishedUsers.length == 0 ?
                                SizedBox(
                                  width: 80,
                                  height: 100,
                                  child: Center(
                                      child: Text('${arg.gameInfo.keyword}' , style: TextStyle(fontSize: 10))
                                  ),
                                ):
                                Image.network(
                                    arg.finishedUsers.last.imgUrl ,
                                    fit:BoxFit.fill , width: 80 , height: 100)

                            ),
                          ),
                        ) ,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${arg.gameInfo.currentTurn}/${arg.gameInfo.maximumTurn}턴 입니다.' , style: TextStyle(
                                fontSize: 14 , color: Colors.blue)),

                            Container(
                              //transform: Matrix4.translationValues(-13.5, -15.5, -50.0),
                              child: arg.gameInfo.currentTurn % 2 ==0 ?
                              Text('<--- 이게 뭘까요?',style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w700))
                              :Text("<--- 그림으로 그려보세요." , style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                            ),
                          ],
                        )
                      ],
                    ),
                    _topPanelPainterTool(controller),
                    Expanded(
                      child: Container(
                        color: Colors.grey,
                        child:
                        arg.gameInfo.currentTurn % 2 ==0 ?
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('저것은 바로..'),
                              SizedBox(height: 15),
                              ModalProgressHUD(
                                color: backgroundColour,
                                inAsyncCall: _imageSaveing,
                                child:  DrawableArea( this.globalKey , backimg , false ),
                              ),
                              SizedBox(height: 15),
                              Text('입니다!')
                            ],
                          ),
                        ):
                        ModalProgressHUD(
                            color: backgroundColour,
                            inAsyncCall: _imageSaveing,
                            child:  DrawableArea( this.globalKey , backimg , true),
                        )
                      ),
                    ),

                    SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                          child: Text('다했어요!' , style:kSendButtonTextStyle),
                          onPressed: _imageSaveing ? null : () async {
                                  await _saveWithS3();
                                  _nextPage();}),
                    )
                  ],
                ),
              ),
            )
          );
        }));
  }
}




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController controller;
  bool gifAnimation = false;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(vsync: this)
      ..addStatusListener((status) async {
        if(status == AnimationStatus.completed){
            needLoginCheck();
        }
      });
  }

  void needLoginCheck() async{
    var needLogin = await Provider.of<UserController>(context).needlogin();
    if(!needLogin){
      await Provider.of<UserController>(context).autoLoginPossible();
      Get.offNamed('/');
    }else{
      Get.offNamed('/login');
    }
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    var adWidth = screenSize.width * 0.5;
    var adHeight = adWidth * 1.7;

    return
       Container(
        width: double.infinity,
        height:double.infinity,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: adHeight,
            height: adHeight,
            child: gifAnimation ?
            Image.asset('images/splash2.gif') :
            Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_9dmzmwdm.json',
                controller: controller,
                fit: BoxFit.fill,
                onLoaded: (composition){
                  controller
                    ..duration = composition.duration;
                  controller.forward(from : 0.1);
                }
            ),
          ),
        ),
    );
  }

}

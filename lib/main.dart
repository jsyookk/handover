
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/controllers/language_controller.dart';
import 'package:handover/controllers/painting_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:handover/screens/gamestarter/gameselect_screen.dart';
import 'package:handover/screens/gamestarter/maker_profile_screen.dart';
import 'package:handover/screens/gamestarter/receive_screen.dart';
import 'package:handover/screens/gamestarter/singleImage_screen.dart';
import 'package:handover/screens/gamestarter/starter_screen.dart';
import 'package:handover/screens/history/grid_view_screen.dart';
import 'package:handover/screens/history_screen.dart';
import 'package:handover/screens/main2_screen.dart';
import 'package:handover/screens/history/multi_image_screen.dart';
import 'package:handover/screens/main3_screen.dart';
import 'package:handover/screens/mypage_screen.dart';
import 'package:handover/screens/splash_screen.dart';
import 'package:handover/screens/user_screen.dart';
import 'package:handover/screens/gamestarter/draw_screen.dart';
import 'package:handover/screens/login_screen.dart';
import 'package:handover/utils/admob_manager.dart';
import 'package:handover/utils/firebase_notification_handler.dart';
import 'package:handover/widget/agree_terms_webview.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handover/screens/gamestarter/complete_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:handover/controllers/game_controller.dart';
import 'package:handover/controllers/user_auth_controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'binding/history_binding.dart';
import 'controllers/user_point_controller.dart';
import 'package:handover/locale/my_translations.dart';
import 'package:handover/service/storage_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/services.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async{
  await Firebase.initializeApp();
  print('Handling a background message : ${remoteMessage.messageId}');

  //var gameUid = remoteMessage.data['json'].toString();
  //Navigator to receive screen
  //FirebaseNotificationHandler.moveToReceiveScreen(gameUid);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if(kDebugMode){
    await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(true);
  }else{
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(true);
  }

  runApp(MyApp());
}

Future<void> initialConfig() async{
  await Get.putAsync(()=> StorageService().init());
  await GetStorage.init();
  await Firebase.initializeApp();
  //Admob initialize
  MobileAds.instance.initialize();
  //in_app_purchase
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

}


class MyApp extends StatelessWidget {

  final storage = Get.find<StorageService>();
  // This widget is the root of your application.
   @override
  Widget build(BuildContext context) {
     //세로 모드 고정
     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp , DeviceOrientation.portraitDown]);

     return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaintingController()),
        ChangeNotifierProvider(create: (_) => GameController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => UserPointController()),
        //ChangeNotifierProvider(create: (_) => HistoryPicController(context))
      ],
      child: GetMaterialApp(
          translations : AppTranslations(),
          locale : storage.languageCode != null ? Locale(storage.languageCode , storage.countryCode)
          : Locale('en' , 'US'),
          fallbackLocale : Locale('en' , 'US'),
          initialBinding: BindingsBuilder(() => {
            Get.put(GameController()),
            Get.put(LanguageController())}),
          getPages :[
            GetPage(name: '/' ,
                page : ()=> Main3Screen(),
                binding: HistoryBinding()
            ),
            GetPage(name: '/game/select' , page :()=> GameSelectScreen()),
             GetPage(name: '/mypage' , page :()=> MypageScreen()),
             GetPage(name: '/splash' , page :()=> SplashScreen()),
             GetPage(name: '/game/draw' ,
                     page :()=> DrawScreen()),
             GetPage(name: '/game/complete' , page :()=> CompleteScreen()),
             GetPage(name: '/game/receive' , page :()=> ReceiveScreen()),
             GetPage(name: '/game/singleImg' , page :()=> SingleImageScreen()),
            GetPage(name: '/login', page :()=> LoginScreen()),
            GetPage(name: '/history',
                page :()=> HistoryScreen(),
                binding: HistoryBinding()),
            GetPage(name: '/history/multiImg',
                page :()=> MultiImageScreen()),
            GetPage(name: '/history/gridImg',
                page :()=> GridViewScreen(),
                binding: HistoryBinding()),
            GetPage(name: '/game/starter',
                page :()=> StarterScreen(),
                binding: HistoryBinding()),
            GetPage(name: '/profile',
                page :()=> MakerProfileScreen(),
              ),
            GetPage(name: '/terms' ,
                page: ()=> AgreeTermsWebview())
           ],
          initialRoute: '/login',
          title: '넘겨',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          )
        ),
    );
  }
}

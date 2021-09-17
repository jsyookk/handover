
import 'dart:io' show Platform;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{

  static String get appId{
   if(Platform.isIOS){
     return 'ca-app-pub-8378950220113691~7638478332';
   }else if(Platform.isAndroid){
     return 'ca-app-pub-8378950220113691~3286609286';
   }else{
     throw new UnsupportedError('Unsupported platform');
   }

  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return RewardedAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return RewardedAd.testAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get keywordRewardAdUnitId {
    if (Platform.isAndroid) {
      return RewardedAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return RewardedAd.testAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get turnRewardAdUnitId{
    if (Platform.isAndroid) {
      return RewardedAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return RewardedAd.testAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get completeTurnRewardAdUnitId{
    if (Platform.isAndroid) {
      return RewardedAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return RewardedAd.testAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId{
    if (Platform.isAndroid) {
      return BannerAd.testAdUnitId;
    } else if (Platform.isIOS) {
      return BannerAd.testAdUnitId;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:handover/controllers/user_point_controller.dart';
import 'package:provider/provider.dart';

class AdMobManager {

  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;
  BannerAd _bannerAd;

  String appID = Platform.isIOS ? 'ca-app-pub-8378950220113691~7638478332'
      : 'ca-app-pub-8378950220113691~3286609286';
  String interstitialID = InterstitialAd.testAdUnitId;
  String rewardID = RewardedAd.testAdUnitId;
  String bannerID = BannerAd.testAdUnitId;
  BuildContext context;
  UserPointController _pointController;
  AdListener _rewardAdListener;
  AdListener _interstitialAdListener;
  AdListener _bannerAdListener;


  /*
  final AdListener interstitialListener = AdListener(
    onAdLoaded: (Ad ad) {
      print('Ad loaded');
    },
    onAdFailedToLoad: (Ad ad , LoadAdError error){
      ad.dispose();
      print('Ad failed to load : $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed : (Ad ad){
      ad.dispose();
      print('Ad closed.');
    },
    onApplicationExit: (Ad ad) => print('Left application.'),
  );

  final AdListener rewardListener = AdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded'),
    onAdFailedToLoad: (Ad ad , LoadAdError error){
      ad.dispose();
      print('Ad failed to load : $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed : (Ad ad){
      ad.dispose();
      print('Ad closed.');
    },
    onApplicationExit: (Ad ad) => print('Left application.'),
    onRewardedAdUserEarnedReward: (RewardedAd ad , RewardItem reward){
      print(reward.type);
      print(reward.amount);
      print('Reward earned : $reward');
    }
  );*/

  init(AdListener interstitialAdListener , AdListener rewardAdListener) async{
    this._interstitialAdListener = interstitialAdListener;
    this._rewardAdListener = rewardAdListener;

    _interstitialAd = createInterstitialAd(_interstitialAdListener);
    _rewardedAd = createRewardAd(_rewardAdListener);
  }

  RewardedAd createRewardAd(AdListener listener) {
    /*
    return RewardedAd(
      adUnitId: rewardID,
      request: AdRequest(),
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('Ad loaded');
          },
          onAdFailedToLoad: (Ad ad , LoadAdError error){
            ad.dispose();
            print('RewardAd failed to load : $error');
          },
          onAdOpened: (Ad ad) => print('RewardAd opened.'),
          onAdClosed : (Ad ad){
            ad.dispose();
            _rewardedAd = createRewardAd();
            print('RewardAd closed.');
          },
          onApplicationExit: (Ad ad) => print('Left application.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad , RewardItem reward){
            print(reward.type);
            print(reward.amount);
            print('Reward earned : $reward');
            notifyListeners();
            _pointController.addAdPoint(reward.amount);
          }
      )
      )..load();*/


    return RewardedAd(
        adUnitId: rewardID,
        request: AdRequest(),
        listener:listener
    )..load();

  }

  loadRewardAd() async{

    _rewardedAd?.dispose();
    _rewardedAd = createRewardAd(_rewardAdListener)..load();

  }


  showRewardAd() {
    _rewardedAd.show();
      /*
        _rewardedAd.isLoaded().then((value) async{
          if(value){
            _rewardedAd.show();
          }else{
            _rewardedAd = createRewardAd(_rewardAdListener);
          }
        });*/

    }

    InterstitialAd createInterstitialAd(AdListener listener){
    /*
      return InterstitialAd(
        adUnitId : interstitialID,
        request: AdRequest(),
        listener :  AdListener(
          onAdLoaded: (Ad ad) {
            _onInterstitialAdClosed = true;
            print('InterstitialAd loaded');
          },
          onAdFailedToLoad: (Ad ad , LoadAdError error){
            ad.dispose();
            print('InterstitialAd failed to load : $error');
          },
          onAdOpened: (Ad ad) => print('InterstitialAd opened.'),
          onAdClosed : (Ad ad){
            ad.dispose();
            print('InterstitialAd closed.');
            _interstitialAd = createInterstitialAd();
            _onInterstitialAdClosed = true;
            notifyListeners();
          },
          onApplicationExit: (Ad ad) => print('Left application.'),
        )
      )..load();*/

      return InterstitialAd(
          adUnitId : interstitialID,
          request: AdRequest(),
          listener : listener
      )..load();
    }

    loadInterstitialAd() async{
      _interstitialAd?.dispose();
      _interstitialAd = createInterstitialAd(_interstitialAdListener)..load();
    }

    showInterstitialAd(){
     _interstitialAd.show();
   }



    dispose(){
        _rewardedAd.dispose();
        _interstitialAd.dispose();
    }

}

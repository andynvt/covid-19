import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';
import '../service.dart';

class AdsService extends BaseService {
  static AdsService _sInstance;
  static String id = '';

  AdsService._(){
    FirebaseAdMob.instance.initialize(appId: getAppId());
  }

  factory AdsService.shared() {
    if (_sInstance == null) {
      _sInstance = AdsService._();
    }
    return _sInstance;
  }

//  static Future init() async {
//    id = await DeviceId.getID;
//
//    await FirebaseAdMob.instance.initialize(appId: getAppId());
//    print('---> Device ID: $id');
//  }

  static String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-8234932442745891~4059290354';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8234932442745891~8884241622';
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-8234932442745891/3154290842';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8234932442745891/1049983633';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-8234932442745891/5278493944';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8234932442745891/9026167262';
    }
    return null;
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
//      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("--> BannerAd event $event");
      },
    );
  }
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: getInterstitialAdUnitId(),
//      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("--> InterstitialAd event $event");
      },
    );
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['covid', 'corona', 'news', 'app', 'game', 'entertainment'],
//    contentUrl: 'https://flutter.io',
    childDirected: false,
//    testDevices: <String>[id],
  );

}
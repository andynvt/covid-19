import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';
import '../service.dart';

class AdsService extends BaseService {
  static AdsService _sInstance;

  AdsService._() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
  }

  factory AdsService.shared() {
    if (_sInstance == null) {
      _sInstance = AdsService._();
    }
    return _sInstance;
  }

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
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("--> InterstitialAd event $event");
      },
    );
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'covid',
      'covid-19',
      'corona',
      'virus',
      'news',
      'app',
      'game',
      'entertainment',
    ],
    childDirected: false,
    testDevices: <String>['4701BEC495FDC0E6F633252C581D79E7'],
  );
}

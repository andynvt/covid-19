//import 'dart:io' show Platform;
//import 'package:firebase_admob/firebase_admob.dart';
//import '../service.dart';
//
//class AdsService extends BaseService {
//  static AdsService _sInstance;
//
//  AdsService._();
//
//  factory AdsService.shared() {
//    if (_sInstance == null) {
//      _sInstance = AdsService._();
//    }
//    return _sInstance;
//  }
//
//  static void init() {
//    FirebaseAdMob.instance.initialize(appId: _getAppId());
//  }
//
//  static String _getAppId() {
//    if (Platform.isIOS) {
//      return 'ca-app-pub-8234932442745891~4059290354';
//    } else if (Platform.isAndroid) {
//      return 'ca-app-pub-8234932442745891~8884241622';
//    }
//    return '';
//  }
//
//  String getBannerAdUnitId() {
//    if (Platform.isIOS) {
//      return 'ca-app-pub-8234932442745891/3154290842';
//    } else if (Platform.isAndroid) {
//      return 'ca-app-pub-8234932442745891/1049983633';
//    }
//    return '';
//  }
//
//}
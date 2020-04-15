import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../service.dart';

class PushNotificationService extends BaseService {
  static PushNotificationService _sInstance;
  FirebaseMessaging _service;

  PushNotificationService._();

  factory PushNotificationService.shared() {
    if (_sInstance == null) {
      _sInstance = PushNotificationService._();
    }
    return _sInstance;
  }

  static Future init() async {
    await PushNotificationService.shared()._init();
  }

  Future _init() async {
    _service = FirebaseMessaging();
    if (Platform.isIOS) {
      await _requestIOSPermission();
    }
    _fireBaseListeners();
  }

  void _fireBaseListeners() {

//    _service.getToken().then((token) {
//      if (d___) {
//        print('---> fcmToken: $token');
//      }
//    });
    _service.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (d___) {
          print('---> on message $message');
        }
      },
      onResume: (Map<String, dynamic> message) async {
        if (d___) {
          print('---> on resume $message');
        }
        handleMsg(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (d___) {
          print('---> on launch $message');
        }
        handleMsg(message);
      },
    );
  }

  void handleMsg(Map<String, dynamic> message) {
    if (d___) {
      print('---> handleMsg: $message');
    }
  }

  Future _requestIOSPermission() async {
    await _service.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _service.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      if (d___) {
        print("---> Settings registered: $settings");
      }
    });
  }
}

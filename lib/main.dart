import 'package:flutter/material.dart';
import './module/module.dart' as Module;
import 'core/language/language.dart';
import 'model/language_enum.dart';
import 'service/cache/cache_service.dart';
import 'service/service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
//  await AdsService.init();
  await PushNotificationService.init();
  Language.init(LanguageEnum.values.map((e) => langToCode(e)).toList());
  runApp(Module.createApp());
}

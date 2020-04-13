import 'package:covid/service/ads/ads_service.dart';
import 'package:flutter/material.dart';
import './module/module.dart' as Module;
import 'core/language/language.dart';
import 'model/language_enum.dart';
import 'service/cache/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  Language.init(LanguageEnum.values.map((e) => langToCode(e)).toList());
//  AdsService.init();
  runApp(Module.createApp());
}

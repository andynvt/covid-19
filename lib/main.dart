import 'package:flutter/material.dart';
import './module/module.dart' as Module;
import 'service/cache/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  runApp(Module.createApp());
}

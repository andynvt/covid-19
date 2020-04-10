import 'package:covid/model/language_enum.dart';
import 'package:covid/service/service.dart';
import 'package:flutter/material.dart';
import 'change_language_logic.dart';

class ChangeLanguageModel extends ChangeNotifier {
  ChangeLanguageLogic _logic;
  ChangeLanguageLogic get logic => _logic;

  LanguageEnum currentLang = LanguageEnum.English;

  ChangeLanguageModel() {
    _logic = ChangeLanguageLogic(this);
    final str = CacheService.shared().getString(CacheConfig.LANGUAGE);
    if(str.isNotEmpty) {
      currentLang = strToLang(str);
    }
  }
}

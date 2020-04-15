import 'package:covid/core/language/language.dart';
import 'package:covid/model/language_enum.dart';
import 'package:covid/service/cache/cache_config.dart';
import 'package:covid/service/cache/cache_service.dart';
import 'package:flutter/cupertino.dart';
import 'root_model.dart';


class RootLogic {
  RootModel _model;

  RootLogic(this._model) {
    Language.shared().delegate.notifyOnChanged = _model.refresh;
    cloneLanguage();
  }

  void showLoading() {
    if (_model.isLoading.value) {
      return;
    }
    _model.isLoading.add(true);
    Future.delayed(Duration(seconds: 15), () {
      _model.isLoading.add(false);
    });
  }

  void hideLoading() {
    _model.isLoading.add(false);
  }

  void cloneLanguage() {
    final str = CacheService.shared().getString(CacheConfig.LANGUAGE);
    updateLanguage(strToLang(str));
  }

  void updateLanguage(LanguageEnum type) {
    String str = langToCode(type);
    CacheService.shared().setString(CacheConfig.LANGUAGE, str);

    Locale locale = langToLocale(type);
    if (_model.currentLocale == null ||
        locale.toString() != _model.currentLocale.toString()) {
      _model.currentLocale = locale;
      _model.refresh();
    }
  }
}

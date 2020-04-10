import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final List<String> langList;
  AppLocalizations localizations;

  Function() notifyOnChanged;

  AppLocalizationsDelegate(this.langList) : assert(langList != null);

  @override
  bool isSupported(Locale locale) {
    assert(locale != null);
    return langList.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    assert(locale != null);
    return AppLocalizations.load(locale: locale, callback: (loc) {
      localizations = loc;

      if(notifyOnChanged != null) {
        notifyOnChanged();
      }
    });
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

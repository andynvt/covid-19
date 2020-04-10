import '../../l10n/messages_all.dart';
import '../../l10n/localization_intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations extends LocalizationIntl {
  
  static Future<AppLocalizations> load({@required Locale locale, Function(AppLocalizations) callback}) {
    assert(locale != null);
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final localization = AppLocalizations();
      if (callback != null) {
        callback(localization);
      }
      return localization;
    });
  }

  static AppLocalizations of(BuildContext context) {
    assert(context != null);
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

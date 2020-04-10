import 'app_localizations.dart';
import 'app_localizations_delegate.dart';

class Language {
  static Language _sInstance;
  AppLocalizationsDelegate delegate;
  Language._();

  static void init(List<String> locales) {
    assert(locales != null);
    Language.shared().delegate = AppLocalizationsDelegate(locales);
  }

  factory Language.shared() {
    if (_sInstance == null) {
      _sInstance = Language._();
    }
    return _sInstance;
  }

  static AppLocalizations get get => Language.shared().delegate.localizations;

  
}

import 'dart:ui';

enum LanguageEnum {
  English,
  Vietnamese,
  Chinese,
  Hindi,
  Spanish,
  French,
  Russian,
  Portuguese,
}

String langToCode(LanguageEnum lang) {
  switch (lang) {
    case LanguageEnum.English:
      return 'en';
    case LanguageEnum.Vietnamese:
      return 'vi';
    case LanguageEnum.Chinese:
      return 'zh';
    case LanguageEnum.Hindi:
      return 'hi';
    case LanguageEnum.Spanish:
      return 'es';
    case LanguageEnum.French:
      return 'fr';
    case LanguageEnum.Russian:
      return 'ru';
    case LanguageEnum.Portuguese:
      return 'pt';
    default:
      return 'en';
  }
}

Locale langToLocale(LanguageEnum lang) {
  switch (lang) {
    case LanguageEnum.English:
      return Locale('en', 'US');
    case LanguageEnum.Vietnamese:
      return Locale('vi', 'VN');
    case LanguageEnum.Chinese:
      return Locale('zh', 'CN');
    case LanguageEnum.Hindi:
      return Locale('hi', 'IN');
    case LanguageEnum.Spanish:
      return Locale('es', 'ES');
    case LanguageEnum.French:
      return Locale('fr', 'FR');
    case LanguageEnum.Russian:
      return Locale('ru', 'RU');
    case LanguageEnum.Portuguese:
      return Locale('pt', 'PT');
    default:
      return Locale('en', 'US');
  }
}

String langToNative(LanguageEnum lang) {
  switch (lang) {
    case LanguageEnum.English:
      return 'English';
    case LanguageEnum.Vietnamese:
      return 'Tiếng Việt';
    case LanguageEnum.Chinese:
      return '中文';
    case LanguageEnum.Hindi:
      return 'हिन्दी';
    case LanguageEnum.Spanish:
      return 'Español';
    case LanguageEnum.French:
      return 'Français';
    case LanguageEnum.Russian:
      return 'Pусский';
    case LanguageEnum.Portuguese:
      return 'Português';
    default:
      return 'English';
  }
}

LanguageEnum strToLang(String str) {
  switch (str) {
    case 'en':
      return LanguageEnum.English;
    case 'vi':
      return LanguageEnum.Vietnamese;
    case 'zh':
      return LanguageEnum.Chinese;
    case 'hi':
      return LanguageEnum.Hindi;
    case 'es':
      return LanguageEnum.Spanish;
    case 'fr':
      return LanguageEnum.French;
    case 'ru':
      return LanguageEnum.Russian;
    case 'pt':
      return LanguageEnum.Portuguese;
    default:
      return LanguageEnum.English;
  }
}

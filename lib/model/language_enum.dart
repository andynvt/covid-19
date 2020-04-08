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
      return 'en';
    case LanguageEnum.Chinese:
      return 'en';
    case LanguageEnum.Hindi:
      return 'en';
    case LanguageEnum.Spanish:
      return 'en';
    case LanguageEnum.French:
      return 'en';
    case LanguageEnum.Russian:
      return 'en';
    case LanguageEnum.Portuguese:
      return 'en';
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

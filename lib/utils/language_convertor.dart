// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

class LanguageConvertor {
  static LanguageConvertor? _instance;
  static LanguageConvertor get instance => _instance ??= LanguageConvertor();
  LanguageCode? _targetLanguage;

  LanguageCode targetLanguage(BuildContext context) {
    return _targetLanguage ??
        _systemLanguage(context) ??
        LanguageConvertor.defaultLanguage;
  }

  LanguageCode fromLocale(Locale? local) {
    _targetLanguage = local?.languageCode.toLanguageCode() ??
        LanguageConvertor.defaultLanguage;
    return _targetLanguage!;
  }

  LanguageCode? _systemLanguage(BuildContext context) {
    Locale local = Localizations.localeOf(context);
    return local.languageCode.toLanguageCode();
  }

  static LanguageCode defaultLanguage = LanguageCode.en;
}

enum LanguageCode {
  en,
  zh_Hans,
  zh_Hant,
  zh,
  ru,
  de,
  fr,
  ja,
  ko,
}

/// [LanguageCode] extension
extension LanguageCodeExt on LanguageCode {
  String get code {
    switch (this) {
      case LanguageCode.en:
        return 'en';
      case LanguageCode.zh:
        return 'zh';
      case LanguageCode.zh_Hans:
        return 'zh-Hans';
      case LanguageCode.zh_Hant:
        return 'zh-Hant';
      case LanguageCode.ru:
        return 'ru';
      case LanguageCode.de:
        return 'de';
      case LanguageCode.fr:
        return 'fr';
      case LanguageCode.ja:
        return 'ja';
      case LanguageCode.ko:
        return 'ko';
    }
  }
}

extension StringExt on String {
  LanguageCode? toLanguageCode() {
    switch (this) {
      case 'en':
        return LanguageCode.en;
      case 'zh':
        return LanguageCode.zh;
      case 'zh-Hans':
        return LanguageCode.zh_Hans;
      case 'zh-Hant':
        return LanguageCode.zh_Hant;
      case 'ru':
        return LanguageCode.ru;
      case 'de':
        return LanguageCode.de;
      case 'fr':
        return LanguageCode.fr;
      case 'ja':
        return LanguageCode.ja;
      case 'ko':
        return LanguageCode.ko;
    }
    return LanguageConvertor.defaultLanguage;
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cabira/Locale/strings_enum.dart';
import 'Languages/arabic.dart';
import 'Languages/english.dart';
import 'Languages/french.dart';
import 'Languages/indonesian.dart';
import 'Languages/portuguese.dart';
import 'Languages/spanish.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<Strings, String>> _localizedValues = {
    'ar': arabic(),
    'fr': french(),
    'pt': portuguese(),
    'es': spanish(),
    'id': indonesian(),
  };

  String? getString(Strings key) {
    return _localizedValues[locale.languageCode]![key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'ar', 'fr', 'pt', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension StateExtension on State {
  String? getString(Strings key) {
    return english[key];
  }
}

extension ContextExtension on BuildContext {
  String? getString(Strings key) {
    return english[key];
  }
}

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../../data/repositories/settings_repository.dart';

/// Supported application locales. Bengali is the default because the
/// primary users are Bengali-speaking garment traders; English can be
/// selected at any time from the dashboard or Settings.
class AppLocales {
  const AppLocales._();

  static const Locale bengali = Locale('bn');
  static const Locale english = Locale('en');

  static const List<Locale> supported = [bengali, english];

  static Locale fromCode(String? code) {
    return switch (code) {
      'en' => english,
      _ => bengali,
    };
  }
}

/// Holds the currently selected locale and persists every change to
/// the database settings table, so the choice survives restarts.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // Load the persisted language once the provider is first used.
    Future<void>(() async {
      final saved = await ref
          .read(settingsRepositoryProvider)
          .getString(AppConstants.settingLanguageCode);
      final locale = AppLocales.fromCode(saved);
      if (state != locale) state = locale;
    });
    return AppLocales.bengali;
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    await ref
        .read(settingsRepositoryProvider)
        .setString(AppConstants.settingLanguageCode, locale.languageCode);
  }
}

/// The active app locale (Bengali by default).
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

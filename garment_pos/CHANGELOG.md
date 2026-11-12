# Changelog

All notable changes to Garment POS are documented here.

## [0.1.1] - 2026-11-12 — Phase 1 fix (first PC run)

### Fixed
- `settings_repository.dart`: added the missing
  `app_constants.dart` import — `flutter analyze` reported
  "Undefined name 'AppConstants'" on the first Windows run.
- README setup guide: documented deleting the sample
  `test/widget_test.dart` that `flutter create .` generates (it
  references a non-existent `MyApp` class).

## [0.1.0] - 2026-11-12 — Phase 1: Foundation & Project Architecture

### Added
- Flutter project skeleton with feature-first folder structure
  (`core/`, `data/`, `features/`, `l10n/`).
- Pinned dependencies verified against pub.dev on 2026-11-12:
  flutter_riverpod 3.5.0, go_router 18.1.4, drift 2.35.4,
  sqlite3 3.9.1, path_provider 2.1.5, drift_dev 2.35.3.
  The End-of-Life `sqlite3_flutter_libs` package is deliberately not
  used; `sqlite3` 3.x bundles native SQLite via Dart build hooks.
- Material 3 theme (light/dark) with bundled Noto Sans Bengali font.
- Responsive layout foundation: mobile / tablet / desktop device
  classes with breakpoint helpers.
- Bengali (default) + English localization via ARB files and a
  database-persisted language switcher.
- Drift + SQLite database, schema **version 1**: `app_settings`
  key-value table, migration strategy skeleton, foreign keys on.
- `SettingsRepository` with typed string/int/bool access.
- `Money` utility: integer-paise arithmetic, Indian digit grouping,
  half-up percentage and round-off helpers.
- Dashboard shell showing real database status (connected, schema
  version, settings count) and module tiles labelled by delivery
  phase. No placeholder business numbers.
- Foundation Settings screen (language, persisted to SQLite).
- Tests: money, responsive breakpoints, database/settings,
  localization switching (Bengali → English).
- Documentation: README, ROADMAP, docs/ARCHITECTURE,
  docs/DATABASE_SCHEMA, docs/TESTING, docs/BUILD_WINDOWS,
  docs/BUILD_ANDROID.

### Notes
- The Arena sandbox has no Flutter/Dart toolchain and the Dart SDK
  download host is blocked there, so `flutter pub get`,
  `flutter analyze` and `flutter test` could not be executed in the
  sandbox. They must be run on the development PC (see
  docs/TESTING.md) and any failure reported back for fixing.
- `android/` and `windows/` runner folders are generated locally with
  `flutter create .` (see README > First-time setup).

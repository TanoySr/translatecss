# Architecture — Garment POS

## Principles

- **Offline-first.** No feature needs the internet. All business data
  lives in a local SQLite database.
- **One codebase, three form factors.** Android phone (single
  column), Android tablet (2–3 panels), Windows desktop (multi-panel)
  share the same features; only layouts differ
  (`lib/core/utils/responsive.dart`).
- **Money is integer paise.** `double` is never used for finance
  (see `lib/core/utils/money.dart`).
- **Feature-first folders.** Each business module owns its UI and
  logic; shared code lives in `core/` (app-wide) and `data/`
  (database + repositories).

## Layers

```
UI (features/*/presentation)      Flutter widgets, Riverpod consumers
        │  reads providers
State (Riverpod providers)        locale, repositories, future features
        │
Data (data/repositories)          typed, testable business-facing API
        │
Database (data/database)          Drift tables + AppDatabase (SQLite)
```

- Widgets never write SQL. Repositories never import Flutter UI.
- The database instance is a single Riverpod provider
  (`appDatabaseProvider`) so tests can substitute
  `NativeDatabase.memory()`.

## Key decisions (Phase 1)

| Decision | Choice | Why |
|---|---|---|
| State management | Riverpod 3.5 (`NotifierProvider`, `Provider`) | Compile-safe DI, easy in-memory overrides in tests |
| Navigation | go_router 18 | Declarative routes, stable paths |
| Database | Drift 2.35 + sqlite3 3.9 | Type-safe SQL, migrations, native SQLite bundled by Dart build hooks on Android + Windows |
| Deprecated packages avoided | `sqflite`, `sqlite3_flutter_libs` (EOL), old `esc_pos_utils`, `blue_thermal_printer` | Maintenance/platform risk |
| Settings storage | SQLite `app_settings` table | Backed up & migrated with business data; `shared_preferences` reserved for tiny UI prefs (Phase 2) |
| Localization | ARB + gen-l10n, bn default | No hardcoded UI text; language persisted in DB |

## Platform-specific code policy

Features that cannot work identically everywhere (camera barcode
scanning, Bluetooth thermal printing) will be isolated behind
platform interfaces in their phase (scanner: Phase 5, printing:
Phase 6). Android-only APIs are never imported by Windows code paths.

## Database migrations

`AppDatabase.schemaVersion` starts at 1. Every schema change:
increments the version by 1, adds a guarded step in `onUpgrade`,
and gets a migration test proving old rows survive. See
[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md).

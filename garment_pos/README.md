# Garment POS

Offline-first Wholesale & Retail Point of Sale and Business Management
Software for garment shops. One Flutter codebase for **Android mobile,
Android tablet and Windows desktop**.

> **Current status: Phase 1 (Foundation) — v0.1.0**
> Login/security (Phase 2), inventory (Phase 3), POS (Phase 5) and the
> remaining modules are delivered phase by phase. See
> [ROADMAP.md](ROADMAP.md). No sales numbers anywhere in the app are
> fake: every screen reads the real SQLite database.

## Features (planned, by phase)

| Phase | Module |
|---|---|
| 1 | Foundation: project architecture, Material 3 theme, responsive layout, বাংলা/English, Drift+SQLite database, dashboard shell |
| 2 | Offline login (password/PIN), roles & permissions, audit log, shop settings, Retail Mode switch, invoice numbering |
| 3 | Products, size×colour variants, barcodes, size sets/bundles, price tiers, stock |
| 4 | Customers, suppliers, agents, credit limits, ledgers |
| 5 | Wholesale-first POS: barcode cart, discounts, split payment, credit/due |
| 6 | GST invoice (CGST/SGST/IGST), challan, A4 & thermal printing, PDF |
| 7 | Purchases & supplier payments |
| 8 | Sales/purchase returns, invoice cancellation, due settlement |
| 9 | Accounts, expenses, dashboard analytics, reports |
| 10 | Backup/restore, final QA, release preparation |

## Technology

- Flutter stable (3.47.x) + Dart 3, Material 3
- State management: Riverpod (`flutter_riverpod` 3.5.0)
- Navigation: `go_router` 18.1.4
- Database: SQLite via Drift (`drift` 2.35.4, `sqlite3` 3.9.1) —
  the deprecated `sqlite3_flutter_libs` and `sqflite` are **not** used
- Localization: ARB files (`lib/l10n/app_en.arb`, `app_bn.arb`)
- Money: all amounts are integer **paise** (₹1 = 100 paise);
  see `lib/core/utils/money.dart`

## First-time setup (Windows PC)

The source ZIP intentionally does not contain the generated
`android/` and `windows/` runner folders (they are large,
machine-generated files that the Flutter tool recreates exactly for
your installed Flutter version). Create them once:

```bat
cd garment_pos
flutter create --platforms=android,windows --project-name garment_pos .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

`flutter create .` only adds platform folders — it never overwrites
the code in `lib/`, `test/` or this documentation.

Requirements: Flutter stable installed, and for Windows builds the
Visual Studio *Desktop development with C++* workload — see
[docs/BUILD_WINDOWS.md](docs/BUILD_WINDOWS.md). Android setup is in
[docs/BUILD_ANDROID.md](docs/BUILD_ANDROID.md).

## Run and test

```bat
flutter analyze
flutter test
flutter build apk --release
flutter build windows --release
```

## Project layout

```
lib/
  core/         theme, router, localization, money + responsive utils
  data/         Drift database, repositories
  features/     feature-first UI (dashboard, settings, ...)
  l10n/         বাংলা + English ARB files
test/           unit + widget tests
docs/           architecture, database schema, build & testing guides
```

## Database & data safety

- SQLite file `garment_pos.sqlite` in the app documents folder.
- Schema is versioned; every future change ships as a data-preserving
  migration. Current schema: **version 1** (`app_settings` table).
  See [docs/DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md).
- Automated backup/restore arrives in Phase 10; until then, copying
  the single `.sqlite` file while the app is fully closed is a safe
  manual backup.

# Changelog

All notable changes to Garment POS are documented here.

## [0.3.1] - 2026-11-12 — Phase 3 fix (first Windows run of Phase 3)

### Fixed
- `app_database.dart`: registered the 12 Phase 3 tables in
  `@DriftDatabase` and added the `from < 3` migration step. The
  entries were missing in v0.3.0, so drift_dev generated a schema
  without products/variants and the build failed with hundreds of
  "Type 'Product' not found" errors.
- `invoice_sequence_service.dart`: restored the missing
  `database_provider.dart` import (`appDatabaseProvider` undefined).
- Dashboard: `_DashboardBody` used an out-of-scope `auth` variable;
  `canViewProducts` is now computed once and passed in.
- Labels screen: restored the missing label providers and removed
  a stray placeholder widget.

## [0.3.0] - 2026-11-12 — Phase 3: Product Master & Inventory

### Added
- Database schema **version 3**: categories, brands, products,
  product_variants, product_sizes, product_colors, price_tiers,
  tax_rates, stock_movements, stock_adjustments, product_sets,
  product_set_items. Migration from v2 preserves all existing data.
- Product master with full garment fields (category, brand, fabric,
  fit, sleeve, neck, HSN, purchase/wholesale/retail/min-selling/MRP
  prices in paise, tax rate, wholesale min qty, status, description).
- Size × colour variant matrix: every variant has its own stock and
  a unique generated EAN-style internal barcode (prefix 20 + check
  digit), validated by BarcodeUtil.
- Masters screens for categories, brands, sizes, colours and
  configurable tax rates (seeded defaults are editable master data,
  not hardcoded law — verify GST slabs with a CA).
- Opening stock, manual stock adjustment with mandatory reason,
  stock_movements ledger (opening/adjustment/sale/set_sale/...),
  low-stock & out-of-stock list. Stock cannot go negative except
  through an explicit override flag in the service layer.
- Wholesale price tiers (e.g. 12+/50+/100+ pieces) with
  priceForQuantity selection.
- Size sets / bundles / cartons: composition by size (optionally
  colour), complete-set availability from variant stock, set sale
  deducting every component variant; individual piece sales reduce
  complete sets automatically.
- Barcode label preview (Code128) and PDF label printing via
  `printing`/`pdf`; `barcode_widget` for on-screen barcodes.
- CSV export (documents folder + preview) and CSV import
  (paste or file path): find-or-create sizes/colours/products/
  variants, stock set through audited adjustments, per-row errors
  reported instead of failing the whole file.
- Product create/edit screens; purchase & selling price changes
  and stock adjustments written to the audit log. Purchase price
  hidden without purchase_price.view permission.
- Tests: barcode validity, CSV codec, inventory repository
  (matrix+unique barcodes, duplicate code, negative-stock block,
  tiers, set availability/sale, low stock, CSV round-trip), schema v3.

## [0.2.0] - 2026-11-12 — Phase 2: Authentication, Security & Settings

### Added
- Database schema **version 2** (migration from v1 preserves
  app_settings): users, roles, permissions, role_permissions,
  user_permissions, audit_logs, number_sequences.
- First-run Owner/Admin setup (username, password, PIN) with a
  one-time Recovery Key; only its PBKDF2 hash is stored.
- Offline login by username+password or user+PIN (4–6 digits);
  PBKDF2-HMAC-SHA256 salted hashing via `cryptography` 2.9.0 —
  never plain SHA-256, never plain text.
- Roles (Admin/Manager/Salesman) with a seeded, editable
  permission matrix plus per-user overrides; Salesman cannot see
  purchase price, product cost or profit by default.
- User management: create/edit/enable/disable users, password
  reset, PIN set — all audit-logged.
- Forgot-password: Admin resets others; owner resets own password
  with the Recovery Key (audited as `password.recovery_reset`).
- Auto lock after configurable inactivity (default 5 min) with a
  lock screen (password/PIN unlock), plus manual lock and sign out.
- Audit log viewer screen.
- Full shop settings: profile (name, address, GSTIN, state/code,
  phone, logo path), invoice prefix with live next-number preview,
  tax defaults, round-off, printer name/paper size, language,
  Retail Mode switch, auto-lock minutes, auto-backup preference.
- Financial-year invoice sequencing (`GW/2026-27/0001`) backed by
  the number_sequences table inside a database transaction.
- Dashboard: signed-in user/role header, wholesale/retail mode
  chip, live Users/Permissions/Audit/Settings tiles by permission.
- Tests: password hasher, recovery key, financial year + invoice
  sequence, auth repository (login, PIN, disable, permissions,
  recovery, audit), retail mode toggle, schema v2 tables.

### Notes
- Sessions are memory-only: restarting the app requires login.
- `app_database.g.dart` was regenerated for the 8-table schema;
  as before, `dart run build_runner build` on a dev PC reproduces
  it from drift_dev.

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

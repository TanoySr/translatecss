# Testing — Garment POS

## Run everything

```bat
cd garment_pos
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

## What exists in Phase 1

| Test file | Covers |
|---|---|
| `test/money_test.dart` | Paise storage/parsing, Indian grouping (₹1,00,500.75), add/multiply, half-up percentage, rupee round-off |
| `test/database_test.dart` | Schema v1 creates, settings save/read/overwrite/delete, typed int/bool access (in-memory SQLite) |
| `test/responsive_test.dart` | Breakpoints: <600 mobile, 600–1023 tablet, ≥1024 desktop |
| `test/app_localization_test.dart` | App boots in Bengali, language switch re-renders in English and persists |
| `test/password_hasher_test.dart` | PBKDF2 hash format, verify ok/fail, random salt, recovery-key format/normalising |
| `test/auth_repository_test.dart` | Owner setup, password + PIN login, duplicate user, salesman profit/cost hidden, disabled login blocked, password + recovery reset, role matrix change, audit entries |
| `test/financial_year_test.dart` | FY Apr–Mar boundaries, invoice sequence increments, FY rollover, custom prefix |
| `test/retail_mode_test.dart` | Retail Mode defaults OFF, toggling preserves other data |

## Sandbox limitation (Phase 1)

The Arena build sandbox has no Flutter/Dart toolchain and cannot
download the Dart SDK (its download host is blocked), so the suite
could not be executed there. Run the commands above on your PC after
setup; if anything fails, send the full red error text back and it
will be fixed before the next phase starts.

## Testing rules for later phases

- Every money/tax rule gets a hand-calculated expected value.
- Every migration gets a create-old → migrate → data-intact test.
- POS/return flows get transaction-consistency tests (either the
  whole sale + stock + ledger is written, or nothing is).

/// Application-wide constants for Garment POS.
///
/// Business rule: every monetary amount in this application is stored
/// and calculated as integer *paise* (1 rupee = 100 paise). Floating
/// point values are never used for money anywhere in the project.
class AppConstants {
  const AppConstants._();

  /// Product / application display name (the shop name itself is
  /// user-configurable and stored in the database settings table).
  static const String appName = 'Garment POS';

  /// SQLite database file name (created in the app documents folder).
  static const String databaseFileName = 'garment_pos.sqlite';

  /// Settings-table keys (lib/data/database). Shop settings themselves
  /// are implemented in Phase 2; the keys live here so every feature
  /// uses exactly the same names.
  static const String settingShopName = 'shop_name';
  static const String settingLanguageCode = 'language_code';

  /// Number of paise in one rupee.
  static const int paisePerRupee = 100;
}

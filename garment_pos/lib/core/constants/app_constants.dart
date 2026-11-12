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

  /// Settings-table keys (lib/data/database). All business settings
  /// live in SQLite so they are backed up with the rest of the data.
  static const String settingShopName = 'shop_name';
  static const String settingShopAddress = 'shop_address';
  static const String settingShopGstin = 'shop_gstin';
  static const String settingShopState = 'shop_state';
  static const String settingShopStateCode = 'shop_state_code';
  static const String settingShopLogoPath = 'shop_logo_path';
  static const String settingShopPhone = 'shop_phone';
  static const String settingLanguageCode = 'language_code';
  static const String settingInvoicePrefix = 'invoice_prefix';
  static const String settingInvoicePadding = 'invoice_number_padding';
  static const String settingDefaultTaxRatePercent =
      'default_tax_rate_percent';
  static const String settingPricesIncludeTax = 'prices_include_tax';
  static const String settingRoundOffEnabled = 'round_off_enabled';
  static const String settingPrinterName = 'printer_name';
  static const String settingPrinterPaperSize = 'printer_paper_size';
  static const String settingRetailModeEnabled = 'retail_mode_enabled';
  static const String settingAutoLockMinutes = 'auto_lock_minutes';
  static const String settingAutoBackupEnabled = 'auto_backup_enabled';
  static const String settingRecoveryKeyHash = 'recovery_key_hash';

  /// Number of paise in one rupee.
  static const int paisePerRupee = 100;
}

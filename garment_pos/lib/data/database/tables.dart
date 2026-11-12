import 'package:drift/drift.dart';

/// Drift table definitions for Garment POS.
///
/// Schema history:
/// - v1 (Phase 1): [AppSettings]
/// - v2 (Phase 2): [Users], [Roles], [Permissions], [RolePermissions],
///   [UserPermissions], [AuditLogs], [NumberSequences]
///
/// All monetary values in future tables must be integer columns
/// holding paise (see lib/core/utils/money.dart). Every table carries
/// created/updated timestamps as epoch milliseconds.
class AppSettings extends Table {
  /// Setting name, e.g. `shop_name`. Primary key.
  TextColumn get key => text()();

  /// Setting value stored as text; typed access goes through
  /// SettingsRepository (lib/data/repositories).
  TextColumn get value => text()();

  /// Last update time, epoch milliseconds.
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Application user accounts (Phase 2). Passwords and PINs are never
/// stored in plain text — only PBKDF2 salted hashes
/// (see PasswordHasher in features/auth).
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Login name, unique across the shop.
  TextColumn get username => text()();

  /// Display name shown in the app header and on invoices.
  TextColumn get displayName => text()();

  /// Encoded PBKDF2 hash: `pbkdf2-sha256$iterations$salt$hash`.
  TextColumn get passwordHash => text()();

  /// Encoded PBKDF2 hash of the 4–6 digit PIN, or null when unset.
  TextColumn get pinHash => text().nullable()();

  /// Role of this user (roles.id).
  IntColumn get roleId => integer().references(Roles, #id)();

  /// Disabled users cannot log in; their history is preserved.
  BoolColumn get isActive => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  /// User who created this account (users.id), null for the first
  /// owner account created during initial setup.
  IntColumn get createdBy => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {username},
  ];
}

/// User roles: admin, manager, salesman (seeded, Phase 2).
class Roles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Machine name, e.g. `admin`.
  TextColumn get name => text()();

  /// Human readable name, e.g. `Admin`.
  TextColumn get displayName => text()();

  /// System roles cannot be deleted.
  BoolColumn get isSystem => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Every permission that can be granted in the app (seeded from
/// AppPermissions in features/auth/domain, Phase 2).
class Permissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Machine key, e.g. `profit.view`.
  TextColumn get permissionKey => text()();

  TextColumn get displayName => text()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {permissionKey},
  ];
}

/// Default permission grants per role (the permission matrix).
class RolePermissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get roleId => integer().references(Roles, #id)();
  IntColumn get permissionId => integer().references(Permissions, #id)();

  BoolColumn get allowed => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {roleId, permissionId},
  ];
}

/// Per-user permission overrides. When a row exists it wins over the
/// role default for that user.
class UserPermissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get permissionId => integer().references(Permissions, #id)();

  BoolColumn get allowed => boolean()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, permissionId},
  ];
}

/// Audit trail (Phase 2): who did what, when, to which record.
/// Later phases add entries for price changes, stock adjustments,
/// invoice cancellations, returns, payments, backups, etc.
class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Acting user (users.id); null for system/setup actions.
  IntColumn get userId => integer().nullable()();

  /// Action key, e.g. `user.create`, `password.reset`.
  TextColumn get action => text()();

  /// Affected record type, e.g. `user`, `invoice`.
  TextColumn get entityType => text().nullable()();

  /// Affected record id.
  IntColumn get entityId => integer().nullable()();

  /// Optional human-readable detail.
  TextColumn get details => text().nullable()();

  IntColumn get createdAt => integer()();
}

/// Running number sequences, e.g. invoice numbers per financial
/// year: key `invoice:GW:2026-27` -> last used number.
class NumberSequences extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get sequenceKey => text()();

  IntColumn get lastNumber => integer()();

  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sequenceKey},
  ];
}

// =====================================================================
// Phase 3 — Product master & inventory (schema v3)
// All prices are integer paise. Stock is tracked per variant.
// =====================================================================

/// Product categories; a row with [parentId] set is a sub-category.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Product brands.
class Brands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Customisable size list, e.g. S, M, L, XL, XXL, 3XL, Free Size,
/// kids sizes. Seeded with common garment sizes; editable in Masters.
class ProductSizes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isActive => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Colour list for the variant matrix.
class ProductColors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get hexCode => text().nullable()();
  BoolColumn get isActive => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Configurable tax rates. Rates are stored as basis points
/// (1200 = 12.00%) so no floating point is involved. Nothing about
/// GST slabs is hardcoded — these rows are editable master data.
class TaxRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get rateBasisPoints => integer()();
  BoolColumn get isDefault => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {name},
  ];
}

/// Product master. Per-variant stock lives in [ProductVariants].
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  /// Shop product code, unique.
  TextColumn get productCode => text()();

  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  IntColumn get brandId => integer().nullable().references(Brands, #id)();
  TextColumn get subCategory => text().nullable()();
  TextColumn get fabric => text().nullable()();
  TextColumn get fit => text().nullable()();
  TextColumn get sleeve => text().nullable()();
  TextColumn get neck => text().nullable()();
  TextColumn get hsnCode => text().nullable()();

  /// Money — integer paise.
  IntColumn get purchasePricePaise => integer()();
  IntColumn get wholesalePricePaise => integer()();
  IntColumn get retailPricePaise => integer().nullable()();
  IntColumn get minSellingPricePaise => integer()();
  IntColumn get mrpPaise => integer().nullable()();

  /// Tax rate in basis points copied from the chosen TaxRates row,
  /// so editing a tax rate never silently changes old products.
  IntColumn get taxRateBasisPoints => integer()();

  /// Minimum quantity for a wholesale sale of this product.
  IntColumn get wholesaleMinQty => integer()();

  /// A variant at or below this quantity is "low stock".
  IntColumn get lowStockThreshold => integer()();

  BoolColumn get isActive => boolean()();
  TextColumn get description => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get createdBy => integer().nullable()();
  IntColumn get updatedBy => integer().nullable()();
  BoolColumn get isDeleted => boolean()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {productCode},
  ];
}

/// One size × colour combination of a product, with its own
/// barcode and stock quantity. Stock may never go negative except
/// through an audited admin override (see InventoryService).
class ProductVariants extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get sizeId => integer().references(ProductSizes, #id)();
  IntColumn get colorId => integer().references(ProductColors, #id)();

  /// Unique barcode (internally generated EAN-13-style or manual).
  TextColumn get barcode => text()();

  IntColumn get stockQuantity => integer()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {barcode},
    {productId, sizeId, colorId},
  ];
}

/// Quantity-based wholesale price tiers for a product:
/// at [minQuantity]+ pieces, the unit price becomes [pricePaise].
class PriceTiers extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get minQuantity => integer()();
  IntColumn get pricePaise => integer()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {productId, minQuantity},
  ];
}

/// Size sets / bundles / cartons for a product, e.g. a 5-piece set
/// of S+M+L+XL+XXL one piece each.
class ProductSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get name => text()();

  /// set | bundle | carton
  TextColumn get setType => text()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// Composition of a [ProductSets] row: how many pieces of each
/// size (and optionally colour) make one set/bundle/carton.
class ProductSetItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get setId => integer().references(ProductSets, #id)();
  IntColumn get sizeId => integer().references(ProductSizes, #id)();
  IntColumn get colorId => integer().nullable()();
  IntColumn get quantityPerSet => integer()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// Every stock change, so stock can always be explained:
/// opening, adjustment, purchase, sale, return, set_break.
class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get variantId => integer().references(ProductVariants, #id)();

  /// opening | adjustment | purchase | sale | sale_return |
  /// purchase_return | set_sale
  TextColumn get movementType => text()();

  /// Signed change applied to stock (+ inward, - outward).
  IntColumn get quantityChange => integer()();

  /// Stock after this movement.
  IntColumn get balanceAfter => integer()();

  TextColumn get reason => text().nullable()();
  IntColumn get userId => integer().nullable()();
  IntColumn get createdAt => integer()();
}

/// Manual stock adjustments with a mandatory reason.
class StockAdjustments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get variantId => integer().references(ProductVariants, #id)();
  IntColumn get quantityChange => integer()();
  TextColumn get reason => text()();
  IntColumn get userId => integer().nullable()();
  IntColumn get createdAt => integer()();
}

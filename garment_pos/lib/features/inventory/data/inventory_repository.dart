import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/csv_codec.dart';
import '../../../core/utils/money.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/database_provider.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/barcode_util.dart';
import '../domain/inventory_models.dart';

/// Product master, variant matrix, stock, sets and price tiers
/// (Phase 3). Every stock change is written to stock_movements (and
/// stock_adjustments for manual changes) inside the same database
/// transaction as the stock update itself, so the numbers can never
/// disagree. Important changes also go to the audit log.
class InventoryRepository {
  InventoryRepository(this._db, {AuthRepository? audit})
    : _audit = audit ?? AuthRepository(_db);

  final AppDatabase _db;
  final AuthRepository _audit;

  int _now() => DateTime.now().millisecondsSinceEpoch;

  // ----------------------------------------------------------------
  // Seeding & masters
  // ----------------------------------------------------------------

  /// Seeds default sizes and editable tax rates when missing.
  /// Tax rows are master data, not law: verify slabs with a CA
  /// before billing (see docs).
  Future<void> ensureSeedData() async {
    final now = _now();
    const defaultSizes = [
      'S',
      'M',
      'L',
      'XL',
      'XXL',
      '3XL',
      'Free Size',
    ];
    for (var i = 0; i < defaultSizes.length; i++) {
      final name = defaultSizes[i];
      final existing = await (_db.select(
        _db.productSizes,
      )..where((t) => t.name.equals(name))).getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.productSizes)
            .insert(
              ProductSizesCompanion.insert(
                name: name,
                sortOrder: i,
                isActive: true,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    }
    const defaultColors = ['Black', 'White', 'Blue', 'Red', 'Grey', 'Green'];
    for (final name in defaultColors) {
      final existing = await (_db.select(
        _db.productColors,
      )..where((t) => t.name.equals(name))).getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.productColors)
            .insert(
              ProductColorsCompanion.insert(
                name: name,
                isActive: true,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    }
    const taxRates = <(String, int, bool)>[
      ('No Tax (0%)', 0, true),
      ('GST 5%', 500, false),
      ('GST 12%', 1200, false),
      ('GST 18%', 1800, false),
    ];
    for (final (name, basisPoints, isDefault) in taxRates) {
      final existing = await (_db.select(
        _db.taxRates,
      )..where((t) => t.name.equals(name))).getSingleOrNull();
      if (existing == null) {
        await _db
            .into(_db.taxRates)
            .insert(
              TaxRatesCompanion.insert(
                name: name,
                rateBasisPoints: basisPoints,
                isDefault: isDefault,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
    }
  }

  Future<List<Category>> listCategories() =>
      (_db.select(_db.categories)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<Category> createCategory(String name) async {
    final now = _now();
    final id = await _db
        .into(_db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: name.trim(),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.categories,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<Brand>> listBrands() =>
      (_db.select(_db.brands)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<Brand> createBrand(String name) async {
    final now = _now();
    final id = await _db
        .into(_db.brands)
        .insert(
          BrandsCompanion.insert(
            name: name.trim(),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(_db.brands)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<ProductSize>> listSizes() =>
      (_db.select(_db.productSizes)
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<ProductSize> createSize(String name) async {
    final now = _now();
    final count = (await listSizes()).length;
    final id = await _db
        .into(_db.productSizes)
        .insert(
          ProductSizesCompanion.insert(
            name: name.trim(),
            sortOrder: count,
            isActive: true,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.productSizes,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<ProductColor>> listColors() =>
      (_db.select(_db.productColors)
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<ProductColor> createColor(String name) async {
    final now = _now();
    final id = await _db
        .into(_db.productColors)
        .insert(
          ProductColorsCompanion.insert(
            name: name.trim(),
            isActive: true,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.productColors,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<TaxRate>> listTaxRates() => _db.select(_db.taxRates).get();

  Future<TaxRate> createTaxRate(String name, int rateBasisPoints) async {
    final now = _now();
    final id = await _db
        .into(_db.taxRates)
        .insert(
          TaxRatesCompanion.insert(
            name: name.trim(),
            rateBasisPoints: rateBasisPoints,
            isDefault: false,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.taxRates,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  // ----------------------------------------------------------------
  // Products & variants
  // ----------------------------------------------------------------

  /// Creates a product with its full variant matrix and opening
  /// stock in one transaction. Barcodes are generated per variant
  /// unless a manual one is supplied; duplicates throw.
  Future<Product> createProduct({
    required int actorId,
    required String name,
    required String productCode,
    int? categoryId,
    int? brandId,
    String? subCategory,
    String? fabric,
    String? fit,
    String? sleeve,
    String? neck,
    String? hsnCode,
    required int purchasePricePaise,
    required int wholesalePricePaise,
    int? retailPricePaise,
    required int minSellingPricePaise,
    int? mrpPaise,
    required int taxRateBasisPoints,
    int wholesaleMinQty = 1,
    int lowStockThreshold = 5,
    String? description,
    required List<NewVariantInput> variants,
    List<PriceTierInput> tiers = const [],
  }) async {
    final duplicate = await (_db.select(
      _db.products,
    )..where((t) => t.productCode.equals(productCode.trim()))).getSingleOrNull();
    if (duplicate != null) {
      throw const InsufficientStockException('Product code already exists');
    }
    final now = _now();
    final productId = await _db.transaction(() async {
      final id = await _db
          .into(_db.products)
          .insert(
            ProductsCompanion.insert(
              name: name.trim(),
              productCode: productCode.trim(),
              categoryId: Value(categoryId),
              brandId: Value(brandId),
              subCategory: Value(subCategory),
              fabric: Value(fabric),
              fit: Value(fit),
              sleeve: Value(sleeve),
              neck: Value(neck),
              hsnCode: Value(hsnCode),
              purchasePricePaise: purchasePricePaise,
              wholesalePricePaise: wholesalePricePaise,
              retailPricePaise: Value(retailPricePaise),
              minSellingPricePaise: minSellingPricePaise,
              mrpPaise: Value(mrpPaise),
              taxRateBasisPoints: taxRateBasisPoints,
              wholesaleMinQty: wholesaleMinQty,
              lowStockThreshold: lowStockThreshold,
              isActive: true,
              description: Value(description),
              createdAt: now,
              updatedAt: now,
              createdBy: Value(actorId),
              updatedBy: Value(actorId),
              isDeleted: false,
            ),
          );
      for (final variant in variants) {
        final variantId = await _db
            .into(_db.productVariants)
            .insert(
              ProductVariantsCompanion.insert(
                productId: id,
                sizeId: variant.sizeId,
                colorId: variant.colorId,
                barcode: variant.barcode ?? 'PENDING-$id-${variant.sizeId}-${variant.colorId}',
                stockQuantity: 0,
                createdAt: now,
                updatedAt: now,
              ),
            );
        final barcode = variant.barcode ?? BarcodeUtil.forVariantId(variantId);
        await (_db.update(_db.productVariants)
              ..where((t) => t.id.equals(variantId)))
            .write(ProductVariantsCompanion(barcode: Value(barcode)));
        if (variant.openingStock != 0) {
          await _applyMovement(
            variantId: variantId,
            change: variant.openingStock,
            type: 'opening',
            userId: actorId,
            reason: 'Opening stock',
          );
        }
      }
      for (final tier in tiers) {
        await _db
            .into(_db.priceTiers)
            .insert(
              PriceTiersCompanion.insert(
                productId: id,
                minQuantity: tier.minQuantity,
                pricePaise: tier.pricePaise,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      return id;
    });
    await _audit.logAction(
      userId: actorId,
      action: 'product.create',
      entityType: 'product',
      entityId: productId,
      details: 'Created product $productCode with ${variants.length} variants',
    );
    return (_db.select(
      _db.products,
    )..where((t) => t.id.equals(productId))).getSingle();
  }

  /// Updates product master fields. Purchase/selling price changes
  /// are audit-logged (Phase 2 audit requirement).
  Future<void> updateProduct({
    required int actorId,
    required Product product,
  }) async {
    final before = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(product.id))).getSingle();
    await (_db.update(
      _db.products,
    )..where((t) => t.id.equals(product.id))).write(
      ProductsCompanion(
        name: Value(product.name),
        categoryId: Value(product.categoryId),
        brandId: Value(product.brandId),
        subCategory: Value(product.subCategory),
        fabric: Value(product.fabric),
        fit: Value(product.fit),
        sleeve: Value(product.sleeve),
        neck: Value(product.neck),
        hsnCode: Value(product.hsnCode),
        purchasePricePaise: Value(product.purchasePricePaise),
        wholesalePricePaise: Value(product.wholesalePricePaise),
        retailPricePaise: Value(product.retailPricePaise),
        minSellingPricePaise: Value(product.minSellingPricePaise),
        mrpPaise: Value(product.mrpPaise),
        taxRateBasisPoints: Value(product.taxRateBasisPoints),
        wholesaleMinQty: Value(product.wholesaleMinQty),
        lowStockThreshold: Value(product.lowStockThreshold),
        isActive: Value(product.isActive),
        description: Value(product.description),
        updatedAt: Value(_now()),
        updatedBy: Value(actorId),
      ),
    );
    if (before.purchasePricePaise != product.purchasePricePaise) {
      await _audit.logAction(
        userId: actorId,
        action: 'product.purchase_price_change',
        entityType: 'product',
        entityId: product.id,
        details:
            '${before.purchasePricePaise} -> ${product.purchasePricePaise} paise',
      );
    }
    if (before.wholesalePricePaise != product.wholesalePricePaise ||
        before.retailPricePaise != product.retailPricePaise) {
      await _audit.logAction(
        userId: actorId,
        action: 'product.selling_price_change',
        entityType: 'product',
        entityId: product.id,
        details:
            'wholesale ${before.wholesalePricePaise} -> ${product.wholesalePricePaise}, '
            'retail ${before.retailPricePaise} -> ${product.retailPricePaise} paise',
      );
    }
    await _audit.logAction(
      userId: actorId,
      action: 'product.update',
      entityType: 'product',
      entityId: product.id,
    );
  }

  /// Adds one variant to an existing product (stock starts at 0,
  /// then opening stock can be adjusted in).
  Future<ProductVariant> addVariant({
    required int actorId,
    required int productId,
    required int sizeId,
    required int colorId,
    int openingStock = 0,
  }) async {
    final now = _now();
    final variantId = await _db.transaction(() async {
      final id = await _db
          .into(_db.productVariants)
          .insert(
            ProductVariantsCompanion.insert(
              productId: productId,
              sizeId: sizeId,
              colorId: colorId,
              barcode: 'PENDING-$productId-$sizeId-$colorId',
              stockQuantity: 0,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await (_db.update(_db.productVariants)..where((t) => t.id.equals(id)))
          .write(
            ProductVariantsCompanion(
              barcode: Value(BarcodeUtil.forVariantId(id)),
            ),
          );
      if (openingStock != 0) {
        await _applyMovement(
          variantId: id,
          change: openingStock,
          type: 'opening',
          userId: actorId,
        );
      }
      return id;
    });
    return (_db.select(
      _db.productVariants,
    )..where((t) => t.id.equals(variantId))).getSingle();
  }

  Future<List<Product>> listProducts({String search = ''}) {
    final query = _db.select(_db.products)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    if (search.trim().isNotEmpty) {
      final term = '%${search.trim()}%';
      query.where(
        (t) => t.name.like(term) | t.productCode.like(term),
      );
    }
    return query.get();
  }

  Future<Product?> productById(int id) {
    return (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<ProductVariant?> variantByBarcode(String barcode) {
    return (_db.select(_db.productVariants)
          ..where((t) => t.barcode.equals(barcode.trim())))
        .getSingleOrNull();
  }

  /// Variants of one product with size/colour names.
  Future<List<VariantView>> variantsOfProduct(int productId) async {
    final product = await productById(productId);
    if (product == null) return [];
    final query = _db.select(_db.productVariants).join([
      innerJoin(
        _db.productSizes,
        _db.productSizes.id.equalsExp(_db.productVariants.sizeId),
      ),
      innerJoin(
        _db.productColors,
        _db.productColors.id.equalsExp(_db.productVariants.colorId),
      ),
    ])..where(_db.productVariants.productId.equals(productId));
    final rows = await query.get();
    return rows.map((row) {
      final variant = row.readTable(_db.productVariants);
      return VariantView(
        variantId: variant.id,
        productId: productId,
        productName: product.name,
        productCode: product.productCode,
        sizeId: variant.sizeId,
        sizeName: row.readTable(_db.productSizes).name,
        colorId: variant.colorId,
        colorName: row.readTable(_db.productColors).name,
        barcode: variant.barcode,
        stockQuantity: variant.stockQuantity,
        lowStockThreshold: product.lowStockThreshold,
      );
    }).toList();
  }

  /// All variants with names — used by low-stock and label screens.
  Future<List<VariantView>> allVariants() async {
    final query = _db.select(_db.productVariants).join([
      innerJoin(
        _db.products,
        _db.products.id.equalsExp(_db.productVariants.productId),
      ),
      innerJoin(
        _db.productSizes,
        _db.productSizes.id.equalsExp(_db.productVariants.sizeId),
      ),
      innerJoin(
        _db.productColors,
        _db.productColors.id.equalsExp(_db.productVariants.colorId),
      ),
    ])..where(_db.products.isDeleted.equals(false));
    final rows = await query.get();
    return rows.map((row) {
      final variant = row.readTable(_db.productVariants);
      final product = row.readTable(_db.products);
      return VariantView(
        variantId: variant.id,
        productId: product.id,
        productName: product.name,
        productCode: product.productCode,
        sizeId: variant.sizeId,
        sizeName: row.readTable(_db.productSizes).name,
        colorId: variant.colorId,
        colorName: row.readTable(_db.productColors).name,
        barcode: variant.barcode,
        stockQuantity: variant.stockQuantity,
        lowStockThreshold: product.lowStockThreshold,
      );
    }).toList();
  }

  Future<int> totalStockOfProduct(int productId) async {
    final quantity = _db.productVariants.stockQuantity.sum();
    final query = _db.selectOnly(_db.productVariants)
      ..addColumns([quantity])
      ..where(_db.productVariants.productId.equals(productId));
    final row = await query.getSingle();
    return row.read(quantity) ?? 0;
  }

  // ----------------------------------------------------------------
  // Stock
  // ----------------------------------------------------------------

  /// Applies a signed stock change and records the movement.
  /// Throws [InsufficientStockException] when the result would be
  /// negative and [allowNegative] is false (admin override only).
  Future<int> _applyMovement({
    required int variantId,
    required int change,
    required String type,
    int? userId,
    String? reason,
    bool allowNegative = false,
  }) async {
    final variant = await (_db.select(
      _db.productVariants,
    )..where((t) => t.id.equals(variantId))).getSingle();
    final balance = variant.stockQuantity + change;
    if (balance < 0 && !allowNegative) {
      throw InsufficientStockException(
        'Stock would become negative for variant $variantId '
        '(have ${variant.stockQuantity}, need ${-change})',
      );
    }
    await (_db.update(_db.productVariants)
          ..where((t) => t.id.equals(variantId)))
        .write(
          ProductVariantsCompanion(
            stockQuantity: Value(balance),
            updatedAt: Value(_now()),
          ),
        );
    await _db
        .into(_db.stockMovements)
        .insert(
          StockMovementsCompanion.insert(
            variantId: variantId,
            movementType: type,
            quantityChange: change,
            balanceAfter: balance,
            reason: Value(reason),
            userId: Value(userId),
            createdAt: _now(),
          ),
        );
    return balance;
  }

  /// Transactional wrapper around [_applyMovement] for callers
  /// outside product creation (sales engine, sets, tests).
  Future<int> changeStock({
    required int actorId,
    required int variantId,
    required int change,
    required String movementType,
    String? reason,
    bool allowNegative = false,
  }) {
    return _db.transaction(
      () => _applyMovement(
        variantId: variantId,
        change: change,
        type: movementType,
        userId: actorId,
        reason: reason,
        allowNegative: allowNegative,
      ),
    );
  }

  /// Manual adjustment with mandatory reason (audited).
  Future<void> adjustStock({
    required int actorId,
    required int variantId,
    required int change,
    required String reason,
    bool allowNegative = false,
  }) async {
    if (reason.trim().isEmpty) {
      throw const InsufficientStockException(
        'Adjustment reason is required',
      );
    }
    await _db.transaction(() async {
      await _applyMovement(
        variantId: variantId,
        change: change,
        type: 'adjustment',
        userId: actorId,
        reason: reason,
        allowNegative: allowNegative,
      );
      await _db
          .into(_db.stockAdjustments)
          .insert(
            StockAdjustmentsCompanion.insert(
              variantId: variantId,
              quantityChange: change,
              reason: reason.trim(),
              userId: Value(actorId),
              createdAt: _now(),
            ),
          );
    });
    await _audit.logAction(
      userId: actorId,
      action: 'stock.adjustment',
      entityType: 'variant',
      entityId: variantId,
      details: '$change (${reason.trim()})',
    );
  }

  Future<List<StockMovement>> movementsOfVariant(int variantId) {
    return (_db.select(_db.stockMovements)
          ..where((t) => t.variantId.equals(variantId))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
  }

  /// Variants at/below their product's low-stock threshold.
  Future<List<VariantView>> lowStockVariants() async {
    final all = await allVariants();
    return all.where((v) => v.isLowStock).toList();
  }

  // ----------------------------------------------------------------
  // Price tiers
  // ----------------------------------------------------------------

  Future<List<PriceTier>> tiersOfProduct(int productId) {
    return (_db.select(_db.priceTiers)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.asc(t.minQuantity)]))
        .get();
  }

  Future<void> setTier({
    required int productId,
    required int minQuantity,
    required int pricePaise,
  }) async {
    final now = _now();
    await _db
        .into(_db.priceTiers)
        .insertOnConflictUpdate(
          PriceTiersCompanion.insert(
            productId: productId,
            minQuantity: minQuantity,
            pricePaise: pricePaise,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> deleteTier(int tierId) {
    return (_db.delete(_db.priceTiers)..where((t) => t.id.equals(tierId)))
        .go();
  }

  /// Wholesale unit price for [quantity] pieces of a product: the
  /// highest tier whose minQuantity is reached, else the product's
  /// base wholesale price.
  Future<int> priceForQuantity(int productId, int quantity) async {
    final product = await productById(productId);
    if (product == null) {
      throw const InsufficientStockException('Product not found');
    }
    final tiers = await tiersOfProduct(productId);
    var price = product.wholesalePricePaise;
    for (final tier in tiers) {
      if (quantity >= tier.minQuantity) price = tier.pricePaise;
    }
    return price;
  }

  // ----------------------------------------------------------------
  // Size sets / bundles / cartons
  // ----------------------------------------------------------------

  Future<ProductSet> createSet({
    required int actorId,
    required int productId,
    required String name,
    required String setType,
    required List<({int sizeId, int? colorId, int quantityPerSet})> items,
  }) async {
    final now = _now();
    final setId = await _db.transaction(() async {
      final id = await _db
          .into(_db.productSets)
          .insert(
            ProductSetsCompanion.insert(
              productId: productId,
              name: name.trim(),
              setType: setType,
              createdAt: now,
              updatedAt: now,
            ),
          );
      for (final item in items) {
        await _db
            .into(_db.productSetItems)
            .insert(
              ProductSetItemsCompanion.insert(
                setId: id,
                sizeId: item.sizeId,
                colorId: Value(item.colorId),
                quantityPerSet: item.quantityPerSet,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      return id;
    });
    await _audit.logAction(
      userId: actorId,
      action: 'product.set_create',
      entityType: 'product_set',
      entityId: setId,
      details: name,
    );
    return (_db.select(
      _db.productSets,
    )..where((t) => t.id.equals(setId))).getSingle();
  }

  Future<List<ProductSet>> setsOfProduct(int productId) {
    return (_db.select(
      _db.productSets,
    )..where((t) => t.productId.equals(productId))).get();
  }

  Future<List<ProductSetItem>> itemsOfSet(int setId) {
    return (_db.select(
      _db.productSetItems,
    )..where((t) => t.setId.equals(setId))).get();
  }

  /// Total pieces in one set/bundle/carton.
  Future<int> piecesPerSet(int setId) async {
    final items = await itemsOfSet(setId);
    return items.fold(0, (sum, item) => sum + item.quantityPerSet);
  }

  /// How many complete sets can be made from current variant stock.
  /// For each composition row, matching variant stock (same size,
  /// and same colour when the row names one) is summed; the set
  /// count is the smallest whole number across all rows.
  Future<int> availableSets(int setId) async {
    final set = await (_db.select(
      _db.productSets,
    )..where((t) => t.id.equals(setId))).getSingle();
    final items = await itemsOfSet(setId);
    if (items.isEmpty) return 0;
    var result = 1 << 62;
    for (final item in items) {
      var query = _db.select(_db.productVariants)
        ..where(
          (t) =>
              t.productId.equals(set.productId) & t.sizeId.equals(item.sizeId),
        );
      if (item.colorId != null) {
        query.where((t) => t.colorId.equals(item.colorId!));
      }
      final variants = await query.get();
      final stock = variants.fold(0, (sum, v) => sum + v.stockQuantity);
      final possible = stock ~/ item.quantityPerSet;
      if (possible < result) result = possible;
    }
    return result;
  }

  /// Deducts the stock for [count] complete sets across the
  /// matching variants (audited movement type `set_sale`).
  /// Individual-piece sale is simply changeStock on one variant,
  /// which automatically reduces complete-set availability.
  Future<void> sellSets({
    required int actorId,
    required int setId,
    required int count,
    bool allowNegative = false,
  }) async {
    if (count <= 0) return;
    final set = await (_db.select(
      _db.productSets,
    )..where((t) => t.id.equals(setId))).getSingle();
    final items = await itemsOfSet(setId);
    await _db.transaction(() async {
      if (!allowNegative) {
        final available = await availableSets(setId);
        if (available < count) {
          throw InsufficientStockException(
            'Only $available complete set(s) available, asked $count',
          );
        }
      }
      for (final item in items) {
        var remaining = item.quantityPerSet * count;
        var query = _db.select(_db.productVariants)
          ..where(
            (t) =>
                t.productId.equals(set.productId) &
                t.sizeId.equals(item.sizeId),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]);
        if (item.colorId != null) {
          query.where((t) => t.colorId.equals(item.colorId!));
        }
        final variants = await query.get();
        for (final variant in variants) {
          if (remaining <= 0) break;
          final take = variant.stockQuantity >= remaining
              ? remaining
              : variant.stockQuantity;
          if (take > 0) {
            await _applyMovement(
              variantId: variant.id,
              change: -take,
              type: 'set_sale',
              userId: actorId,
              reason: 'Set sale: ${set.name} x$count',
              allowNegative: allowNegative,
            );
            remaining -= take;
          }
        }
        if (remaining > 0 && allowNegative && variants.isNotEmpty) {
          // Override: push the shortfall onto the last variant.
          await _applyMovement(
            variantId: variants.last.id,
            change: -remaining,
            type: 'set_sale',
            userId: actorId,
            reason: 'Set sale override: ${set.name} x$count',
            allowNegative: true,
          );
        }
      }
    });
  }

  // ----------------------------------------------------------------
  // CSV import / export
  // ----------------------------------------------------------------

  /// Header for the product CSV format (documented in TESTING/docs).
  static const List<String> csvHeader = [
    'product_code',
    'product_name',
    'size',
    'color',
    'barcode',
    'stock_quantity',
    'purchase_price',
    'wholesale_price',
    'retail_price',
    'mrp',
    'wholesale_min_qty',
    'hsn_code',
  ];

  Future<String> exportProductsCsv() async {
    final rows = <List<String>>[csvHeader];
    final variants = await allVariants();
    for (final view in variants) {
      final product = await productById(view.productId);
      if (product == null) continue;
      rows.add([
        product.productCode,
        product.name,
        view.sizeName,
        view.colorName,
        view.barcode,
        '${view.stockQuantity}',
        Money(product.purchasePricePaise).format(showSymbol: false),
        Money(product.wholesalePricePaise).format(showSymbol: false),
        product.retailPricePaise == null
            ? ''
            : Money(product.retailPricePaise!).format(showSymbol: false),
        product.mrpPaise == null
            ? ''
            : Money(product.mrpPaise!).format(showSymbol: false),
        '${product.wholesaleMinQty}',
        product.hsnCode ?? '',
      ]);
    }
    return CsvCodec.encode(rows);
  }

  /// Imports product/variant rows. Finds-or-creates sizes, colours
  /// and products (by product_code); finds-or-creates the variant
  /// and sets its stock to stock_quantity through an audited
  /// adjustment movement. Bad rows are reported, not fatal.
  Future<CsvImportResult> importProductsCsv({
    required int actorId,
    required String csvText,
  }) async {
    final result = CsvImportResult();
    final rows = CsvCodec.parse(csvText);
    if (rows.isEmpty) {
      result.errors.add('CSV is empty');
      return result;
    }
    final header = rows.first.map((h) => h.trim()).toList();
    final index = <String, int>{
      for (var i = 0; i < header.length; i++) header[i]: i,
    };
    String cell(List<String> row, String name) {
      final i = index[name];
      if (i == null || i >= row.length) return '';
      return row[i].trim();
    }

    final sizes = await listSizes();
    final colors = await listColors();
    Future<int> sizeIdFor(String name) async {
      final found = sizes.where(
        (s) => s.name.toLowerCase() == name.toLowerCase(),
      );
      if (found.isNotEmpty) return found.first.id;
      final created = await createSize(name);
      sizes.add(created);
      return created.id;
    }

    Future<int> colorIdFor(String name) async {
      final found = colors.where(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
      if (found.isNotEmpty) return found.first.id;
      final created = await createColor(name);
      colors.add(created);
      return created.id;
    }

    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      try {
        final code = cell(row, 'product_code');
        final name = cell(row, 'product_name');
        final sizeName = cell(row, 'size');
        final colorName = cell(row, 'color');
        if (code.isEmpty || name.isEmpty || sizeName.isEmpty) {
          result.errors.add(
            'Row ${r + 1}: product_code, product_name and size are required',
          );
          continue;
        }
        var product = await (_db.select(
          _db.products,
        )..where((t) => t.productCode.equals(code))).getSingleOrNull();
        if (product == null) {
          product = await createProduct(
            actorId: actorId,
            name: name,
            productCode: code,
            hsnCode: cell(row, 'hsn_code').isEmpty
                ? null
                : cell(row, 'hsn_code'),
            purchasePricePaise:
                Money.tryParse(cell(row, 'purchase_price'))?.paise ?? 0,
            wholesalePricePaise:
                Money.tryParse(cell(row, 'wholesale_price'))?.paise ?? 0,
            retailPricePaise:
                Money.tryParse(cell(row, 'retail_price'))?.paise,
            minSellingPricePaise: 0,
            mrpPaise: Money.tryParse(cell(row, 'mrp'))?.paise,
            taxRateBasisPoints: 0,
            wholesaleMinQty:
                int.tryParse(cell(row, 'wholesale_min_qty')) ?? 1,
            variants: const [],
          );
          result.productsCreated++;
        }
        final sizeId = await sizeIdFor(sizeName);
        final colorId = await colorIdFor(
          colorName.isEmpty ? 'Assorted' : colorName,
        );
        var variant = await (_db.select(_db.productVariants)..where(
              (t) =>
                  t.productId.equals(product!.id) &
                  t.sizeId.equals(sizeId) &
                  t.colorId.equals(colorId),
            ))
            .getSingleOrNull();
        if (variant == null) {
          variant = await addVariant(
            actorId: actorId,
            productId: product.id,
            sizeId: sizeId,
            colorId: colorId,
          );
          result.variantsCreated++;
        } else {
          result.variantsUpdated++;
        }
        final stockText = cell(row, 'stock_quantity');
        if (stockText.isNotEmpty) {
          final target = int.tryParse(stockText);
          if (target == null) {
            result.errors.add('Row ${r + 1}: stock_quantity is not a number');
          } else if (target != variant.stockQuantity) {
            await adjustStock(
              actorId: actorId,
              variantId: variant.id,
              change: target - variant.stockQuantity,
              reason: 'CSV import',
            );
          }
        }
      } catch (e) {
        result.errors.add('Row ${r + 1}: $e');
      }
    }
    return result;
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(
    ref.watch(appDatabaseProvider),
    audit: ref.watch(authRepositoryProvider),
  );
});

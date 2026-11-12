import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/features/auth/data/auth_repository.dart';
import 'package:garment_pos/features/auth/domain/password_hasher.dart';
import 'package:garment_pos/features/inventory/data/inventory_repository.dart';
import 'package:garment_pos/features/inventory/domain/barcode_util.dart';
import 'package:garment_pos/features/inventory/domain/inventory_models.dart';

void main() {
  group('InventoryRepository (Phase 3)', () {
    late AppDatabase database;
    late InventoryRepository repo;
    late int actorId;
    late int sizeS, sizeM, sizeL;
    late int black, white;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      final auth = AuthRepository(
        database,
        hasher: PasswordHasher(iterations: 1000),
      );
      final owner = await auth.createOwner(
        username: 'admin',
        displayName: 'Owner',
        password: 'pass',
        pin: '1234',
        recoveryKeyPlain: 'KEY',
      );
      actorId = owner.id;
      repo = InventoryRepository(database, audit: auth);
      await repo.ensureSeedData();
      final sizes = await repo.listSizes();
      sizeS = sizes.firstWhere((s) => s.name == 'S').id;
      sizeM = sizes.firstWhere((s) => s.name == 'M').id;
      sizeL = sizes.firstWhere((s) => s.name == 'L').id;
      final colors = await repo.listColors();
      black = colors.firstWhere((c) => c.name == 'Black').id;
      white = colors.firstWhere((c) => c.name == 'White').id;
    });

    tearDown(() async => database.close());

    Future<Product> makeShirt() {
      return repo.createProduct(
        actorId: actorId,
        name: "Men's T-Shirt",
        productCode: 'TSHIRT-001',
        purchasePricePaise: 20000,
        wholesalePricePaise: 35000,
        retailPricePaise: 49900,
        minSellingPricePaise: 30000,
        taxRateBasisPoints: 500,
        variants: [
          NewVariantInput(sizeId: sizeS, colorId: black, openingStock: 20),
          NewVariantInput(sizeId: sizeM, colorId: black, openingStock: 30),
          NewVariantInput(sizeId: sizeL, colorId: black, openingStock: 25),
          NewVariantInput(sizeId: sizeS, colorId: white, openingStock: 20),
          NewVariantInput(sizeId: sizeM, colorId: white, openingStock: 30),
          NewVariantInput(sizeId: sizeL, colorId: white, openingStock: 25),
        ],
      );
    }

    test('variant matrix is created with unique valid barcodes', () async {
      final product = await makeShirt();
      final variants = await repo.variantsOfProduct(product.id);
      expect(variants, hasLength(6));
      final barcodes = variants.map((v) => v.barcode).toSet();
      expect(barcodes, hasLength(6)); // all unique
      for (final v in variants) {
        expect(BarcodeUtil.isValid(v.barcode), isTrue, reason: v.barcode);
      }
      expect(await repo.totalStockOfProduct(product.id), 150);
      final byBarcode = await repo.variantByBarcode(variants.first.barcode);
      expect(byBarcode?.id, variants.first.variantId);
    });

    test('duplicate product code is rejected', () async {
      await makeShirt();
      await expectLater(makeShirt(), throwsA(isA<Exception>()));
    });

    test('stock adjustment needs a reason and cannot go negative', () async {
      final product = await makeShirt();
      final variant = (await repo.variantsOfProduct(product.id)).first;
      await expectLater(
        repo.adjustStock(
          actorId: actorId,
          variantId: variant.variantId,
          change: -999,
          reason: 'damage',
        ),
        throwsA(isA<InsufficientStockException>()),
      );
      await repo.adjustStock(
        actorId: actorId,
        variantId: variant.variantId,
        change: -5,
        reason: 'damaged pieces',
      );
      final after = (await repo.variantsOfProduct(
        product.id,
      )).firstWhere((v) => v.variantId == variant.variantId);
      expect(after.stockQuantity, variant.stockQuantity - 5);
      final movements = await repo.movementsOfVariant(variant.variantId);
      expect(movements.first.movementType, 'adjustment');
      expect(movements.first.balanceAfter, after.stockQuantity);
    });

    test('price tiers pick the right wholesale price', () async {
      final product = await makeShirt();
      await repo.setTier(productId: product.id, minQuantity: 12, pricePaise: 33000);
      await repo.setTier(productId: product.id, minQuantity: 50, pricePaise: 31000);
      await repo.setTier(productId: product.id, minQuantity: 100, pricePaise: 29000);
      expect(await repo.priceForQuantity(product.id, 1), 35000);
      expect(await repo.priceForQuantity(product.id, 11), 35000);
      expect(await repo.priceForQuantity(product.id, 12), 33000);
      expect(await repo.priceForQuantity(product.id, 60), 31000);
      expect(await repo.priceForQuantity(product.id, 500), 29000);
    });

    test('complete-set availability and set sale deduct every size', () async {
      final product = await makeShirt();
      final set = await repo.createSet(
        actorId: actorId,
        productId: product.id,
        name: 'S-M-L Set (Black)',
        setType: 'set',
        items: [
          (sizeId: sizeS, colorId: black, quantityPerSet: 1),
          (sizeId: sizeM, colorId: black, quantityPerSet: 1),
          (sizeId: sizeL, colorId: black, quantityPerSet: 1),
        ],
      );
      expect(await repo.piecesPerSet(set.id), 3);
      // Black stock S=20, M=30, L=25 -> 20 complete sets.
      expect(await repo.availableSets(set.id), 20);

      await repo.sellSets(actorId: actorId, setId: set.id, count: 5);
      final variants = await repo.variantsOfProduct(product.id);
      int stockOf(int sizeId, int colorId) => variants
          .firstWhere((v) => v.sizeId == sizeId && v.colorId == colorId)
          .stockQuantity;
      expect(stockOf(sizeS, black), 15);
      expect(stockOf(sizeM, black), 25);
      expect(stockOf(sizeL, black), 20);
      expect(stockOf(sizeS, white), 20); // untouched
      expect(await repo.availableSets(set.id), 15);

      // Selling individual pieces also reduces complete sets.
      final mBlack = variants.firstWhere(
        (v) => v.sizeId == sizeM && v.colorId == black,
      );
      await repo.changeStock(
        actorId: actorId,
        variantId: mBlack.variantId,
        change: -10,
        movementType: 'sale',
      );
      // S=15 remains the limiting size.
      expect(await repo.availableSets(set.id), 15);
      final sBlack = variants.firstWhere(
        (v) => v.sizeId == sizeS && v.colorId == black,
      );
      await repo.changeStock(
        actorId: actorId,
        variantId: sBlack.variantId,
        change: -10,
        movementType: 'sale',
      );
      expect(await repo.availableSets(set.id), 5);

      // Cannot sell more complete sets than available.
      await expectLater(
        repo.sellSets(actorId: actorId, setId: set.id, count: 99),
        throwsA(isA<InsufficientStockException>()),
      );
    });

    test('low stock list flags variants at/below threshold', () async {
      final product = await repo.createProduct(
        actorId: actorId,
        name: 'Kids Tee',
        productCode: 'KID-001',
        purchasePricePaise: 10000,
        wholesalePricePaise: 18000,
        minSellingPricePaise: 15000,
        taxRateBasisPoints: 500,
        lowStockThreshold: 5,
        variants: [
          NewVariantInput(sizeId: sizeS, colorId: black, openingStock: 3),
          NewVariantInput(sizeId: sizeM, colorId: black, openingStock: 40),
        ],
      );
      final low = await repo.lowStockVariants();
      expect(low.map((v) => v.productId), contains(product.id));
      expect(low.where((v) => v.productId == product.id), hasLength(1));
      expect(low.first.isLowStock, isTrue);
    });

    test('CSV export then import round-trips stock and prices', () async {
      await makeShirt();
      final csv = await repo.exportProductsCsv();
      expect(csv, contains('TSHIRT-001'));
      expect(csv, contains('product_code'));

      // Fresh database: import must recreate product + variants.
      final db2 = AppDatabase(NativeDatabase.memory());
      addTearDown(db2.close);
      final auth2 = AuthRepository(
        db2,
        hasher: PasswordHasher(iterations: 1000),
      );
      final owner2 = await auth2.createOwner(
        username: 'admin',
        displayName: 'Owner',
        password: 'pass',
        pin: '1234',
        recoveryKeyPlain: 'KEY',
      );
      final repo2 = InventoryRepository(db2, audit: auth2);
      await repo2.ensureSeedData();
      final result = await repo2.importProductsCsv(
        actorId: owner2.id,
        csvText: csv,
      );
      expect(result.errors, isEmpty, reason: result.errors.join('; '));
      expect(result.productsCreated, 1);
      final imported = (await repo2.listProducts()).single;
      expect(await repo2.totalStockOfProduct(imported.id), 150);
    });
  });
}

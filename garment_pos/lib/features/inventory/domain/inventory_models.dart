/// View models joining inventory tables for UI and services.
library;

/// Input for one size × colour variant when creating a product.
class NewVariantInput {
  const NewVariantInput({
    required this.sizeId,
    required this.colorId,
    this.openingStock = 0,
    this.barcode,
  });

  final int sizeId;
  final int colorId;
  final int openingStock;

  /// Manual barcode; when null one is generated from the variant id.
  final String? barcode;
}

/// Input for one price tier row.
class PriceTierInput {
  const PriceTierInput({required this.minQuantity, required this.pricePaise});

  final int minQuantity;
  final int pricePaise;
}

/// A variant joined with its size/colour/product display data.
class VariantView {
  const VariantView({
    required this.variantId,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.sizeId,
    required this.sizeName,
    required this.colorId,
    required this.colorName,
    required this.barcode,
    required this.stockQuantity,
    required this.lowStockThreshold,
  });

  final int variantId;
  final int productId;
  final String productName;
  final String productCode;
  final int sizeId;
  final String sizeName;
  final int colorId;
  final String colorName;
  final String barcode;
  final int stockQuantity;
  final int lowStockThreshold;

  bool get isLowStock => stockQuantity <= lowStockThreshold;
  bool get isOutOfStock => stockQuantity <= 0;

  String get label => '$productName ($sizeName / $colorName)';
}

/// Thrown when a stock deduction would make stock negative and no
/// authorised override was given.
class InsufficientStockException implements Exception {
  const InsufficientStockException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Result counters for a CSV import run.
class CsvImportResult {
  int productsCreated = 0;
  int variantsCreated = 0;
  int variantsUpdated = 0;
  final List<String> errors = [];

  @override
  String toString() =>
      'productsCreated=$productsCreated, variantsCreated=$variantsCreated, '
      'variantsUpdated=$variantsUpdated, errors=${errors.length}';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/money.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_models.dart';

/// Create/edit a product. On create, the size × colour matrix is
/// generated from the ticked sizes/colours, each combo getting an
/// opening-stock field and an automatic barcode. On edit, only the
/// master fields change (variants are managed on the detail screen).
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.existing, super.key});

  final Product? existing;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _subCategory = TextEditingController();
  final _fabric = TextEditingController();
  final _fit = TextEditingController();
  final _sleeve = TextEditingController();
  final _neck = TextEditingController();
  final _hsn = TextEditingController();
  final _purchase = TextEditingController();
  final _wholesale = TextEditingController();
  final _retail = TextEditingController();
  final _minSelling = TextEditingController();
  final _mrp = TextEditingController();
  final _wholesaleMinQty = TextEditingController(text: '1');
  final _lowStock = TextEditingController(text: '5');
  final _description = TextEditingController();

  int? _categoryId;
  int? _brandId;
  int _taxBasisPoints = 0;
  final Set<int> _sizeIds = {};
  final Set<int> _colorIds = {};
  final Map<String, TextEditingController> _stockControllers = {};
  final List<({TextEditingController minQty, TextEditingController price})>
  _tierRows = [];
  String? _error;
  bool _busy = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    if (p != null) {
      _name.text = p.name;
      _code.text = p.productCode;
      _subCategory.text = p.subCategory ?? '';
      _fabric.text = p.fabric ?? '';
      _fit.text = p.fit ?? '';
      _sleeve.text = p.sleeve ?? '';
      _neck.text = p.neck ?? '';
      _hsn.text = p.hsnCode ?? '';
      _purchase.text = Money(p.purchasePricePaise).format(showSymbol: false);
      _wholesale.text = Money(p.wholesalePricePaise).format(showSymbol: false);
      _retail.text = p.retailPricePaise == null
          ? ''
          : Money(p.retailPricePaise!).format(showSymbol: false);
      _minSelling.text = Money(
        p.minSellingPricePaise,
      ).format(showSymbol: false);
      _mrp.text = p.mrpPaise == null
          ? ''
          : Money(p.mrpPaise!).format(showSymbol: false);
      _wholesaleMinQty.text = '${p.wholesaleMinQty}';
      _lowStock.text = '${p.lowStockThreshold}';
      _description.text = p.description ?? '';
      _categoryId = p.categoryId;
      _brandId = p.brandId;
      _taxBasisPoints = p.taxRateBasisPoints;
    }
    Future<void>(() => ref.read(inventoryRepositoryProvider).ensureSeedData());
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _code,
      _subCategory,
      _fabric,
      _fit,
      _sleeve,
      _neck,
      _hsn,
      _purchase,
      _wholesale,
      _retail,
      _minSelling,
      _mrp,
      _wholesaleMinQty,
      _lowStock,
      _description,
      ..._stockControllers.values,
    ]) {
      c.dispose();
    }
    for (final row in _tierRows) {
      row.minQty.dispose();
      row.price.dispose();
    }
    super.dispose();
  }

  TextEditingController _stockController(int sizeId, int colorId) {
    return _stockControllers.putIfAbsent(
      '$sizeId-$colorId',
      () => TextEditingController(text: '0'),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    final purchase = Money.tryParse(_purchase.text);
    final wholesale = Money.tryParse(_wholesale.text);
    final minSelling = Money.tryParse(_minSelling.text);
    if (_name.text.trim().isEmpty ||
        _code.text.trim().isEmpty ||
        purchase == null ||
        wholesale == null ||
        minSelling == null) {
      setState(() => _error = l10n.fillAllFields);
      return;
    }
    if (!_isEdit && (_sizeIds.isEmpty || _colorIds.isEmpty)) {
      setState(() => _error = l10n.selectSizesColors);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final repo = ref.read(inventoryRepositoryProvider);
    try {
      if (_isEdit) {
        final old = widget.existing!;
        await repo.updateProduct(
          actorId: actor.id,
          product: Product(
            id: old.id,
            name: _name.text.trim(),
            productCode: old.productCode,
            categoryId: _categoryId,
            brandId: _brandId,
            subCategory: _nullIfEmpty(_subCategory.text),
            fabric: _nullIfEmpty(_fabric.text),
            fit: _nullIfEmpty(_fit.text),
            sleeve: _nullIfEmpty(_sleeve.text),
            neck: _nullIfEmpty(_neck.text),
            hsnCode: _nullIfEmpty(_hsn.text),
            purchasePricePaise: purchase.paise,
            wholesalePricePaise: wholesale.paise,
            retailPricePaise: Money.tryParse(_retail.text)?.paise,
            minSellingPricePaise: minSelling.paise,
            mrpPaise: Money.tryParse(_mrp.text)?.paise,
            taxRateBasisPoints: _taxBasisPoints,
            wholesaleMinQty: int.tryParse(_wholesaleMinQty.text) ?? 1,
            lowStockThreshold: int.tryParse(_lowStock.text) ?? 5,
            isActive: old.isActive,
            description: _nullIfEmpty(_description.text),
            createdAt: old.createdAt,
            updatedAt: old.updatedAt,
            createdBy: old.createdBy,
            updatedBy: actor.id,
            isDeleted: old.isDeleted,
            deletedAt: old.deletedAt,
          ),
        );
      } else {
        final variants = <NewVariantInput>[
          for (final sizeId in _sizeIds)
            for (final colorId in _colorIds)
              NewVariantInput(
                sizeId: sizeId,
                colorId: colorId,
                openingStock:
                    int.tryParse(_stockController(sizeId, colorId).text) ?? 0,
              ),
        ];
        final tiers = <PriceTierInput>[
          for (final row in _tierRows)
            if (int.tryParse(row.minQty.text) != null &&
                Money.tryParse(row.price.text) != null)
              PriceTierInput(
                minQuantity: int.parse(row.minQty.text),
                pricePaise: Money.tryParse(row.price.text)!.paise,
              ),
        ];
        await repo.createProduct(
          actorId: actor.id,
          name: _name.text,
          productCode: _code.text,
          categoryId: _categoryId,
          brandId: _brandId,
          subCategory: _nullIfEmpty(_subCategory.text),
          fabric: _nullIfEmpty(_fabric.text),
          fit: _nullIfEmpty(_fit.text),
          sleeve: _nullIfEmpty(_sleeve.text),
          neck: _nullIfEmpty(_neck.text),
          hsnCode: _nullIfEmpty(_hsn.text),
          purchasePricePaise: purchase.paise,
          wholesalePricePaise: wholesale.paise,
          retailPricePaise: Money.tryParse(_retail.text)?.paise,
          minSellingPricePaise: minSelling.paise,
          mrpPaise: Money.tryParse(_mrp.text)?.paise,
          taxRateBasisPoints: _taxBasisPoints,
          wholesaleMinQty: int.tryParse(_wholesaleMinQty.text) ?? 1,
          lowStockThreshold: int.tryParse(_lowStock.text) ?? 5,
          description: _nullIfEmpty(_description.text),
          variants: variants,
          tiers: tiers,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.productSaved)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _nullIfEmpty(String text) =>
      text.trim().isEmpty ? null : text.trim();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(_categoriesProvider);
    final brands = ref.watch(_brandsProvider);
    final sizes = ref.watch(_sizesProvider);
    final colors = ref.watch(_colorsProvider);
    final taxRates = ref.watch(_taxRatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editProduct : l10n.addProduct),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.productName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _code,
            enabled: !_isEdit,
            decoration: InputDecoration(labelText: l10n.productCode),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: categories.when(
                  data: (list) => DropdownButtonFormField<int?>(
                    initialValue: _categoryId,
                    decoration: InputDecoration(labelText: l10n.category),
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('-')),
                      ...list.map(
                        (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('-'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: brands.when(
                  data: (list) => DropdownButtonFormField<int?>(
                    initialValue: _brandId,
                    decoration: InputDecoration(labelText: l10n.brand),
                    items: [
                      const DropdownMenuItem<int?>(value: null, child: Text('-')),
                      ...list.map(
                        (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _brandId = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('-'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _half(TextField(controller: _subCategory, decoration: InputDecoration(labelText: l10n.subCategory))),
              _half(TextField(controller: _fabric, decoration: InputDecoration(labelText: l10n.fabric))),
              _half(TextField(controller: _fit, decoration: InputDecoration(labelText: l10n.fit))),
              _half(TextField(controller: _sleeve, decoration: InputDecoration(labelText: l10n.sleeve))),
              _half(TextField(controller: _neck, decoration: InputDecoration(labelText: l10n.neck))),
              _half(TextField(controller: _hsn, decoration: InputDecoration(labelText: l10n.hsnCode))),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _half(_moneyField(_purchase, l10n.purchasePrice)),
              _half(_moneyField(_wholesale, l10n.wholesalePrice)),
              _half(_moneyField(_retail, l10n.retailPrice)),
              _half(_moneyField(_minSelling, l10n.minSellingPrice)),
              _half(_moneyField(_mrp, l10n.mrp)),
              _half(
                taxRates.when(
                  data: (list) => DropdownButtonFormField<int>(
                    initialValue: _taxBasisPoints,
                    decoration: InputDecoration(labelText: l10n.taxRate),
                    items: list
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.rateBasisPoints,
                            child: Text(t.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _taxBasisPoints = v ?? 0),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const Text('-'),
                ),
              ),
              _half(
                TextField(
                  controller: _wholesaleMinQty,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.wholesaleMinQty),
                ),
              ),
              _half(
                TextField(
                  controller: _lowStock,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.lowStockThreshold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            maxLines: 2,
            decoration: InputDecoration(labelText: l10n.description),
          ),
          if (!_isEdit) ...[
            const Divider(height: 32),
            Text(
              l10n.selectSizesColors,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            sizes.when(
              data: (list) => Wrap(
                spacing: 8,
                children: list
                    .map(
                      (s) => FilterChip(
                        label: Text(s.name),
                        selected: _sizeIds.contains(s.id),
                        onSelected: (sel) => setState(() {
                          sel ? _sizeIds.add(s.id) : _sizeIds.remove(s.id);
                        }),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(l10n.somethingWentWrong('$e')),
            ),
            const SizedBox(height: 8),
            colors.when(
              data: (list) => Wrap(
                spacing: 8,
                children: list
                    .map(
                      (c) => FilterChip(
                        label: Text(c.name),
                        selected: _colorIds.contains(c.id),
                        onSelected: (sel) => setState(() {
                          sel ? _colorIds.add(c.id) : _colorIds.remove(c.id);
                        }),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(l10n.somethingWentWrong('$e')),
            ),
            if (_sizeIds.isNotEmpty && _colorIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.openingStock,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final sizeId in _sizeIds)
                for (final colorId in _colorIds)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${sizes.value?.firstWhere((s) => s.id == sizeId).name} / '
                            '${colors.value?.firstWhere((c) => c.id == colorId).name}',
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          child: TextField(
                            controller: _stockController(sizeId, colorId),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.stock,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
            const Divider(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.priceTiers,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _tierRows.add((
                      minQty: TextEditingController(),
                      price: TextEditingController(),
                    ));
                  }),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addTier),
                ),
              ],
            ),
            for (var i = 0; i < _tierRows.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tierRows[i].minQty,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: l10n.minQty),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _tierRows[i].price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.unitPrice,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => setState(() => _tierRows.removeAt(i)),
                    ),
                  ],
                ),
              ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _half(Widget child) => ConstrainedBox(
    constraints: const BoxConstraints(minWidth: 150, maxWidth: 320),
    child: child,
  );

  Widget _moneyField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );
  }
}

final _categoriesProvider = FutureProvider<List<Category>>(
  (ref) => ref.watch(inventoryRepositoryProvider).listCategories(),
);
final _brandsProvider = FutureProvider<List<Brand>>(
  (ref) => ref.watch(inventoryRepositoryProvider).listBrands(),
);
final _sizesProvider = FutureProvider<List<ProductSize>>(
  (ref) => ref.watch(inventoryRepositoryProvider).listSizes(),
);
final _colorsProvider = FutureProvider<List<ProductColor>>(
  (ref) => ref.watch(inventoryRepositoryProvider).listColors(),
);
final _taxRatesProvider = FutureProvider<List<TaxRate>>(
  (ref) => ref.watch(inventoryRepositoryProvider).listTaxRates(),
);

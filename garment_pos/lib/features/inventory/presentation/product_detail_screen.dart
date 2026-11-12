import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/money.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/domain/permissions.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_models.dart';
import 'product_form_screen.dart';

/// Product detail: variant matrix with barcodes and stock, manual
/// stock adjustment (reason required, audited), price tiers and
/// size-set definition/availability.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(_detailProvider(productId));
    final auth = ref.watch(authProvider);
    final canManage =
        auth is AuthSignedIn && auth.can(AppPermissions.productsManage);
    final canSeeCost =
        auth is AuthSignedIn && auth.can(AppPermissions.purchasePriceView);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.variants),
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.editProduct,
              onPressed: () async {
                final product = await ref
                    .read(inventoryRepositoryProvider)
                    .productById(productId);
                if (product == null || !context.mounted) return;
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductFormScreen(existing: product),
                  ),
                );
                ref.invalidate(_detailProvider(productId));
              },
            ),
        ],
      ),
      body: data.when(
        data: (detail) {
          final (product, variants, tiers, sets) = detail;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${product.name} (${product.productCode})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.wholesalePrice}: ${Money(product.wholesalePricePaise)}'
                '${canSeeCost ? ' • ${l10n.purchasePrice}: ${Money(product.purchasePricePaise)}' : ' • ${l10n.costHidden}'}'
                '${product.retailPricePaise == null ? ' • ${l10n.retailPriceNotSet}' : ' • ${l10n.retailPrice}: ${Money(product.retailPricePaise!)}'}',
              ),
              const SizedBox(height: 16),
              Text(
                l10n.variants,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...variants.map(
                (v) => Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 90,
                      height: 36,
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: v.barcode,
                        drawText: false,
                      ),
                    ),
                    title: Text('${v.sizeName} / ${v.colorName}'),
                    subtitle: Text('${l10n.barcode}: ${v.barcode}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text('${l10n.stock}: ${v.stockQuantity}'),
                          backgroundColor: v.isOutOfStock
                              ? Theme.of(context).colorScheme.errorContainer
                              : v.isLowStock
                              ? Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer
                              : null,
                        ),
                        if (canManage)
                          IconButton(
                            icon: const Icon(Icons.tune),
                            tooltip: l10n.adjustStock,
                            onPressed: () =>
                                _adjustDialog(context, ref, v),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 32),
              Text(
                l10n.priceTiers,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (tiers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${l10n.minQty}: — • ${l10n.unitPrice}: '
                    '${Money(product.wholesalePricePaise)}',
                  ),
                ),
              ...tiers.map(
                (t) => ListTile(
                  dense: true,
                  title: Text('${l10n.minQty}: ${t.minQuantity}+'),
                  trailing: Text(Money(t.pricePaise).format()),
                ),
              ),
              const Divider(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.sets,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (canManage)
                    TextButton.icon(
                      onPressed: () => _createSetDialog(context, ref),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createSet),
                    ),
                ],
              ),
              ...sets.map((set) => _SetTile(setId: set.id, name: set.name)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong('$e'))),
      ),
    );
  }

  Future<void> _adjustDialog(
    BuildContext context,
    WidgetRef ref,
    VariantView variant,
  ) async {
    final l10n = AppLocalizations.of(context);
    final qty = TextEditingController();
    final reason = TextEditingController();
    final actor = ref.read(currentUserProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adjustStock),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(variant.label),
            const SizedBox(height: 12),
            TextField(
              controller: qty,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
              ),
              decoration: InputDecoration(labelText: l10n.adjustmentQty),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reason,
              decoration: InputDecoration(labelText: l10n.reason),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (ok != true || actor == null) return;
    final change = int.tryParse(qty.text) ?? 0;
    try {
      await ref
          .read(inventoryRepositoryProvider)
          .adjustStock(
            actorId: actor.id,
            variantId: variant.variantId,
            change: change,
            reason: reason.text,
          );
      ref.invalidate(_detailProvider(productId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _createSetDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    final repo = ref.read(inventoryRepositoryProvider);
    final sizes = await repo.listSizes();
    if (!context.mounted) return;
    final name = TextEditingController();
    final qtyControllers = {
      for (final s in sizes) s.id: TextEditingController(text: '0'),
    };
    var setType = 'set';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.createSet),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: l10n.setName),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: setType,
                  decoration: InputDecoration(labelText: l10n.setType),
                  items: const [
                    DropdownMenuItem(value: 'set', child: Text('Set')),
                    DropdownMenuItem(value: 'bundle', child: Text('Bundle')),
                    DropdownMenuItem(value: 'carton', child: Text('Carton')),
                  ],
                  onChanged: (v) => setState(() => setType = v ?? 'set'),
                ),
                const SizedBox(height: 12),
                for (final size in sizes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: Text(size.name)),
                        SizedBox(
                          width: 90,
                          child: TextField(
                            controller: qtyControllers[size.id],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.qtyPerSet,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final items = <({int sizeId, int? colorId, int quantityPerSet})>[
      for (final size in sizes)
        if ((int.tryParse(qtyControllers[size.id]!.text) ?? 0) > 0)
          (
            sizeId: size.id,
            colorId: null,
            quantityPerSet: int.parse(qtyControllers[size.id]!.text),
          ),
    ];
    if (items.isEmpty || name.text.trim().isEmpty) return;
    await repo.createSet(
      actorId: actor.id,
      productId: productId,
      name: name.text,
      setType: setType,
      items: items,
    );
    ref.invalidate(_detailProvider(productId));
  }
}

class _SetTile extends ConsumerWidget {
  const _SetTile({required this.setId, required this.name});

  final int setId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final available = ref.watch(
      FutureProvider.autoDispose<int>(
        (ref) =>
            ref.watch(inventoryRepositoryProvider).availableSets(setId),
      ),
    );
    final pieces = ref.watch(
      FutureProvider.autoDispose<int>(
        (ref) => ref.watch(inventoryRepositoryProvider).piecesPerSet(setId),
      ),
    );
    return ListTile(
      leading: const Icon(Icons.view_module_outlined),
      title: Text(name),
      subtitle: Text(
        '${l10n.piecesPerSet(pieces.value ?? 0)} • '
        '${l10n.availableSets(available.value ?? 0)}',
      ),
    );
  }
}

final _availableSetsProvider = FutureProvider.family<int, int>((ref, setId) {
  return ref.watch(inventoryRepositoryProvider).availableSets(setId);
});

final _piecesPerSetProvider = FutureProvider.family<int, int>((ref, setId) {
  return ref.watch(inventoryRepositoryProvider).piecesPerSet(setId);
});

final _detailProvider = FutureProvider.family<
  (Product, List<VariantView>, List<PriceTier>, List<ProductSet>),
  int
>((ref, productId) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final product = await repo.productById(productId);
  if (product == null) throw StateError('Product not found');
  final variants = await repo.variantsOfProduct(productId);
  final tiers = await repo.tiersOfProduct(productId);
  final sets = await repo.setsOfProduct(productId);
  return (product, variants, tiers, sets);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/money.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../../auth/domain/permissions.dart';
import '../data/inventory_repository.dart';

/// Product list with search, stock totals and low-stock badges.
/// Purchase price is only shown with the purchase_price.view
/// permission (never to salesman by default).
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _search = '';

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      await ref.read(inventoryRepositoryProvider).ensureSeedData();
      ref.invalidate(_productsProvider(_search));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final signedIn = auth is AuthSignedIn ? auth : null;
    final canManage = signedIn?.can(AppPermissions.productsManage) ?? false;
    final canSeeCost =
        signedIn?.can(AppPermissions.purchasePriceView) ?? false;
    final products = ref.watch(_productsProvider(_search));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventory),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_outlined),
            tooltip: l10n.lowStock,
            onPressed: () => context.go(AppRoutes.lowStock),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_2),
            tooltip: l10n.labels,
            onPressed: () => context.go(AppRoutes.labels),
          ),
          IconButton(
            icon: const Icon(Icons.import_export),
            tooltip: l10n.csvTools,
            onPressed: () => context.go(AppRoutes.csvTools),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: l10n.masters,
            onPressed: () => context.go(AppRoutes.masters),
          ),
        ],
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () async {
                await context.push(AppRoutes.newProduct);
                ref.invalidate(_productsProvider);
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addProduct),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchProducts,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          Expanded(
            child: products.when(
              data: (list) => list.isEmpty
                  ? Center(child: Text(l10n.noProducts))
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = list[index];
                        return _ProductTile(
                          product: product,
                          canSeeCost: canSeeCost,
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text(l10n.somethingWentWrong('$e'))),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  const _ProductTile({required this.product, required this.canSeeCost});

  final Product product;
  final bool canSeeCost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stock = ref.watch(_stockProvider(product.id));
    return ListTile(
      title: Text('${product.name} (${product.productCode})'),
      subtitle: Text(
        '${l10n.wholesalePrice}: ${Money(product.wholesalePricePaise)}'
        '${canSeeCost ? ' • ${l10n.purchasePrice}: ${Money(product.purchasePricePaise)}' : ''}'
        '${product.retailPricePaise == null ? ' • ${l10n.retailPriceNotSet}' : ''}',
      ),
      trailing: stock.when(
        data: (count) => Chip(
          label: Text('${l10n.stock}: $count'),
          backgroundColor: count <= product.lowStockThreshold
              ? Theme.of(context).colorScheme.errorContainer
              : null,
        ),
        loading: () => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, _) => const Text('-'),
      ),
      onTap: () async {
        await context.push('${AppRoutes.inventory}/${product.id}');
        ref.invalidate(_productsProvider(''));
      },
    );
  }
}

final _productsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  search,
) {
  return ref.watch(inventoryRepositoryProvider).listProducts(search: search);
});

final _stockProvider = FutureProvider.family<int, int>((ref, productId) {
  return ref
      .watch(inventoryRepositoryProvider)
      .totalStockOfProduct(productId);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_models.dart';

/// Low-stock and out-of-stock variant list (Phase 3).
class LowStockScreen extends ConsumerWidget {
  const LowStockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final low = ref.watch(_lowStockProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.lowStock)),
      body: low.when(
        data: (list) => list.isEmpty
            ? Center(child: Text(l10n.stock))
            : ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final VariantView v = list[i];
                  return ListTile(
                    leading: Icon(
                      v.isOutOfStock
                          ? Icons.remove_shopping_cart
                          : Icons.warning_amber,
                      color: v.isOutOfStock
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                    title: Text(v.label),
                    subtitle: Text('${l10n.barcode}: ${v.barcode}'),
                    trailing: Chip(
                      label: Text(
                        v.isOutOfStock
                            ? l10n.outOfStock
                            : '${l10n.stock}: ${v.stockQuantity}',
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.somethingWentWrong('$e'))),
      ),
    );
  }
}

final _lowStockProvider = FutureProvider<List<VariantView>>((ref) {
  return ref.watch(inventoryRepositoryProvider).lowStockVariants();
});

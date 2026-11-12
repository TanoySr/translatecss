import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/inventory_repository.dart';

/// Masters management: categories, brands, sizes, colours and tax
/// rates (Phase 3). Add via the button in each tab; entries are
/// master data used by the product form.
class MastersScreen extends ConsumerStatefulWidget {
  const MastersScreen({super.key});

  @override
  ConsumerState<MastersScreen> createState() => _MastersScreenState();
}

class _MastersScreenState extends ConsumerState<MastersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
    Future<void>(() => ref.read(inventoryRepositoryProvider).ensureSeedData());
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.masters),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.categories),
            Tab(text: l10n.brands),
            Tab(text: l10n.sizes),
            Tab(text: l10n.colors),
            Tab(text: l10n.taxRates),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _MasterList(
            load: (repo) async =>
                (await repo.listCategories()).map((e) => e.name).toList(),
            add: (repo, name) => repo.createCategory(name),
          ),
          _MasterList(
            load: (repo) async =>
                (await repo.listBrands()).map((e) => e.name).toList(),
            add: (repo, name) => repo.createBrand(name),
          ),
          _MasterList(
            load: (repo) async =>
                (await repo.listSizes()).map((e) => e.name).toList(),
            add: (repo, name) => repo.createSize(name),
          ),
          _MasterList(
            load: (repo) async =>
                (await repo.listColors()).map((e) => e.name).toList(),
            add: (repo, name) => repo.createColor(name),
          ),
          _MasterList(
            load: (repo) async => (await repo.listTaxRates())
                .map((e) => '${e.name} — ${e.rateBasisPoints / 100}%')
                .toList(),
            add: (repo, name) async {
              // Format from master screen: "Name|percent" e.g. GST 5%|5
              final parts = name.split('|');
              final label = parts.first.trim();
              final percent = parts.length > 1
                  ? double.tryParse(parts[1].trim()) ?? 0
                  : 0;
              return repo.createTaxRate(label, (percent * 100).round());
            },
            hint: 'GST 28%|28',
          ),
        ],
      ),
    );
  }
}

class _MasterList extends ConsumerStatefulWidget {
  const _MasterList({required this.load, required this.add, this.hint});

  final Future<List<String>> Function(InventoryRepository repo) load;
  final Future<dynamic> Function(InventoryRepository repo, String name) add;
  final String? hint;

  @override
  ConsumerState<_MasterList> createState() => _MasterListState();
}

class _MasterListState extends ConsumerState<_MasterList> {
  late Future<List<String>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.load(ref.read(inventoryRepositoryProvider));
  }

  void _reload() {
    setState(() {
      _future = widget.load(ref.read(inventoryRepositoryProvider));
    });
  }

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.add),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.name,
            hintText: widget.hint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
    if (ok == true && controller.text.trim().isNotEmpty) {
      await widget.add(
        ref.read(inventoryRepositoryProvider),
        controller.text.trim(),
      );
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<String>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.somethingWentWrong('${snapshot.error}')));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) return Center(child: Text(l10n.noProducts));
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => ListTile(title: Text(items[i])),
          );
        },
      ),
    );
  }
}

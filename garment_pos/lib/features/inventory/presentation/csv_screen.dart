import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_provider.dart';
import '../data/inventory_repository.dart';

/// CSV export/import for products (Phase 3).
///
/// Export writes `products_export.csv` into the app documents
/// folder and previews the text. Import accepts pasted CSV or a
/// file path (typed, so it works identically on Windows/Android
/// without extra plugins). Format header:
/// product_code, product_name, size, color, barcode,
/// stock_quantity, purchase_price, wholesale_price, retail_price,
/// mrp, wholesale_min_qty, hsn_code
class CsvScreen extends ConsumerStatefulWidget {
  const CsvScreen({super.key});

  @override
  ConsumerState<CsvScreen> createState() => _CsvScreenState();
}

class _CsvScreenState extends ConsumerState<CsvScreen> {
  final _csvText = TextEditingController();
  final _path = TextEditingController();
  String? _message;
  bool _busy = false;

  @override
  void dispose() {
    _csvText.dispose();
    _path.dispose();
    super.dispose();
  }

  Future<void> _export() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final csv = await ref
          .read(inventoryRepositoryProvider)
          .exportProductsCsv();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'products_export.csv'));
      await file.writeAsString(csv);
      _csvText.text = csv;
      setState(() => _message = '${l10n.exportCsv}: ${file.path}');
    } catch (e) {
      setState(() => _message = l10n.somethingWentWrong('$e'));
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _loadFile() async {
    final l10n = AppLocalizations.of(context);
    try {
      final text = await File(_path.text.trim()).readAsString();
      setState(() => _csvText.text = text);
    } catch (e) {
      setState(() => _message = l10n.somethingWentWrong('$e'));
    }
  }

  Future<void> _import() async {
    final l10n = AppLocalizations.of(context);
    final actor = ref.read(currentUserProvider);
    if (actor == null) return;
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(inventoryRepositoryProvider)
          .importProductsCsv(actorId: actor.id, csvText: _csvText.text);
      setState(() {
        _message =
            '${l10n.importDone}: $result'
            '${result.errors.isEmpty ? '' : '\n${result.errors.join('\n')}'}';
      });
    } catch (e) {
      setState(() => _message = l10n.somethingWentWrong('$e'));
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.csvTools)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: _busy ? null : _export,
            icon: const Icon(Icons.download),
            label: Text(l10n.exportCsv),
          ),
          const SizedBox(height: 16),
          Text(l10n.csvPasteHint),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _path,
                  decoration: InputDecoration(labelText: l10n.filePath),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _loadFile, child: Text(l10n.loadFile)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _csvText,
            minLines: 8,
            maxLines: 16,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText:
                  'product_code,product_name,size,color,barcode,stock_quantity,purchase_price,wholesale_price,retail_price,mrp,wholesale_min_qty,hsn_code',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _import,
            icon: const Icon(Icons.upload),
            label: Text(l10n.runImport),
          ),
          if (_message != null) ...[
            const SizedBox(height: 16),
            SelectableText(_message!),
          ],
        ],
      ),
    );
  }
}

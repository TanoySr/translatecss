import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../l10n/app_localizations.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_models.dart';

/// Barcode label preview + PDF label printing (Phase 3).
/// Each label shows product name, size/colour, wholesale price and
/// a Code128 barcode of the variant code.
final _labelProductsProvider = FutureProvider((ref) {
  return ref.watch(inventoryRepositoryProvider).listProducts();
});

final _labelVariantsProvider = FutureProvider.family<List<VariantView>, int>((
  ref,
  productId,
) {
  return ref.watch(inventoryRepositoryProvider).variantsOfProduct(productId);
});

class LabelsScreen extends ConsumerStatefulWidget {
  const LabelsScreen({super.key});

  @override
  ConsumerState<LabelsScreen> createState() => _LabelsScreenState();
}

class _LabelsScreenState extends ConsumerState<LabelsScreen> {
  int? _productId;

  Future<void> _printLabels(List<VariantView> variants) async {
    final doc = pw.Document();
    const perRow = 3;
    final labels = <pw.Widget>[];
    for (final v in variants) {
      labels.add(
        pw.Container(
          width: 170,
          height: 100,
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                v.productName,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                maxLines: 1,
              ),
              pw.Text(
                '${v.sizeName} / ${v.colorName}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 4),
              pw.BarcodeWidget(
                barcode: pw.Barcode.code128(),
                data: v.barcode,
                width: 150,
                height: 42,
                drawText: true,
                textStyle: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
      );
    }
    final rows = <pw.Widget>[];
    for (var i = 0; i < labels.length; i += perRow) {
      rows.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var j = i; j < i + perRow && j < labels.length; j++)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 8),
                  child: labels[j],
                ),
            ],
          ),
        ),
      );
    }
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => rows,
      ),
    );
    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = ref.watch(_labelProductsProvider);
    final variants = _productId == null
        ? null
        : ref.watch(_labelVariantsProvider(_productId!));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labels)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: products.when(
              data: (list) => DropdownButtonFormField<int>(
                initialValue: _productId,
                decoration: InputDecoration(labelText: l10n.productName),
                items: list
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text('${p.name} (${p.productCode})'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _productId = v),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(l10n.somethingWentWrong('$e')),
            ),
          ),
          if (variants != null)
            Expanded(
              child: variants.when(
                data: (list) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: list.isEmpty
                              ? null
                              : () => _printLabels(list),
                          icon: const Icon(Icons.print),
                          label: Text(l10n.printLabels),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisExtent: 130,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final v = list[i];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${v.sizeName} / ${v.colorName}'),
                                  Expanded(
                                    child: BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: v.barcode,
                                      drawText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l10n.somethingWentWrong('$e'))),
              ),
            ),
        ],
      ),
    );
  }
}

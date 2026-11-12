import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/settings/app_settings_providers.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/invoice_sequence_service.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Shop settings (Phase 2). Every value is saved to the SQLite
/// `app_settings` table — shop profile, invoice, tax, printer,
/// Retail Mode, language and auto-lock. Changing Retail Mode here
/// never touches historical business data.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _gstin = TextEditingController();
  final _state = TextEditingController();
  final _stateCode = TextEditingController();
  final _phone = TextEditingController();
  final _logoPath = TextEditingController();
  final _invoicePrefix = TextEditingController();
  final _taxRate = TextEditingController();
  final _printerName = TextEditingController();

  bool _loaded = false;
  bool _pricesIncludeTax = false;
  bool _roundOff = true;
  bool _retailMode = false;
  bool _autoBackup = false;
  String _paperSize = '80mm';
  int _autoLockMinutes = 5;

  @override
  void dispose() {
    for (final c in [
      _shopName,
      _address,
      _gstin,
      _state,
      _stateCode,
      _phone,
      _logoPath,
      _invoicePrefix,
      _taxRate,
      _printerName,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    _shopName.text = await repo.getString(AppConstants.settingShopName) ?? '';
    _address.text =
        await repo.getString(AppConstants.settingShopAddress) ?? '';
    _gstin.text = await repo.getString(AppConstants.settingShopGstin) ?? '';
    _state.text = await repo.getString(AppConstants.settingShopState) ?? '';
    _stateCode.text =
        await repo.getString(AppConstants.settingShopStateCode) ?? '';
    _phone.text = await repo.getString(AppConstants.settingShopPhone) ?? '';
    _logoPath.text =
        await repo.getString(AppConstants.settingShopLogoPath) ?? '';
    _invoicePrefix.text =
        await repo.getString(AppConstants.settingInvoicePrefix) ?? 'GW';
    _taxRate.text =
        await repo.getString(AppConstants.settingDefaultTaxRatePercent) ??
        '';
    _printerName.text =
        await repo.getString(AppConstants.settingPrinterName) ?? '';
    _paperSize =
        await repo.getString(AppConstants.settingPrinterPaperSize) ?? '80mm';
    _pricesIncludeTax = await repo.getBool(
      AppConstants.settingPricesIncludeTax,
    );
    _roundOff = await repo.getBool(
      AppConstants.settingRoundOffEnabled,
      defaultValue: true,
    );
    _retailMode = await repo.getBool(AppConstants.settingRetailModeEnabled);
    _autoBackup = await repo.getBool(AppConstants.settingAutoBackupEnabled);
    _autoLockMinutes =
        await repo.getInt(AppConstants.settingAutoLockMinutes) ?? 5;
    if (mounted) {
      setState(() => _loaded = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setString(AppConstants.settingShopName, _shopName.text.trim());
    await repo.setString(
      AppConstants.settingShopAddress,
      _address.text.trim(),
    );
    await repo.setString(AppConstants.settingShopGstin, _gstin.text.trim());
    await repo.setString(AppConstants.settingShopState, _state.text.trim());
    await repo.setString(
      AppConstants.settingShopStateCode,
      _stateCode.text.trim(),
    );
    await repo.setString(AppConstants.settingShopPhone, _phone.text.trim());
    await repo.setString(
      AppConstants.settingShopLogoPath,
      _logoPath.text.trim(),
    );
    await repo.setString(
      AppConstants.settingInvoicePrefix,
      _invoicePrefix.text.trim().isEmpty ? 'GW' : _invoicePrefix.text.trim(),
    );
    await repo.setString(
      AppConstants.settingDefaultTaxRatePercent,
      _taxRate.text.trim(),
    );
    await repo.setString(
      AppConstants.settingPrinterName,
      _printerName.text.trim(),
    );
    await repo.setString(AppConstants.settingPrinterPaperSize, _paperSize);
    await repo.setBool(AppConstants.settingPricesIncludeTax, _pricesIncludeTax);
    await repo.setBool(AppConstants.settingRoundOffEnabled, _roundOff);
    await repo.setBool(AppConstants.settingRetailModeEnabled, _retailMode);
    await repo.setBool(AppConstants.settingAutoBackupEnabled, _autoBackup);
    await repo.setInt(AppConstants.settingAutoLockMinutes, _autoLockMinutes);
    ref.invalidate(autoLockMinutesProvider);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saved)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final nextInvoice = ref.watch(_nextInvoiceProvider);
    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, l10n.shopProfile),
          TextField(
            controller: _shopName,
            decoration: InputDecoration(labelText: l10n.shopName),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _address,
            maxLines: 2,
            decoration: InputDecoration(labelText: l10n.shopAddress),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            decoration: InputDecoration(labelText: l10n.shopPhone),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _gstin,
            decoration: InputDecoration(labelText: l10n.gstin),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _state,
                  decoration: InputDecoration(labelText: l10n.state),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _stateCode,
                  decoration: InputDecoration(labelText: l10n.stateCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _logoPath,
            decoration: InputDecoration(labelText: l10n.logoPath),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.invoiceSettings),
          TextField(
            controller: _invoicePrefix,
            decoration: InputDecoration(labelText: l10n.invoicePrefix),
          ),
          const SizedBox(height: 8),
          nextInvoice.when(
            data: (number) => Text(l10n.nextInvoicePreview(number)),
            loading: () => Text(l10n.loading),
            error: (e, _) => Text(l10n.somethingWentWrong('$e')),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.taxSettings),
          TextField(
            controller: _taxRate,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.defaultTaxRatePercent,
            ),
          ),
          SwitchListTile(
            title: Text(l10n.pricesIncludeTax),
            value: _pricesIncludeTax,
            onChanged: (v) => setState(() => _pricesIncludeTax = v),
          ),
          SwitchListTile(
            title: Text(l10n.roundOffEnabled),
            value: _roundOff,
            onChanged: (v) => setState(() => _roundOff = v),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.printerSettings),
          TextField(
            controller: _printerName,
            decoration: InputDecoration(labelText: l10n.printerName),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _paperSize,
            decoration: InputDecoration(labelText: l10n.paperSize),
            items: const [
              DropdownMenuItem(value: '58mm', child: Text('58mm')),
              DropdownMenuItem(value: '80mm', child: Text('80mm')),
              DropdownMenuItem(value: 'A4', child: Text('A4')),
            ],
            onChanged: (v) => setState(() => _paperSize = v ?? _paperSize),
          ),
          const Divider(height: 32),
          _sectionTitle(context, l10n.language),
          RadioGroup<Locale>(
            groupValue: locale,
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<Locale>(
                  value: AppLocales.bengali,
                  title: Text(l10n.languageBengali),
                ),
                RadioListTile<Locale>(
                  value: AppLocales.english,
                  title: Text(l10n.languageEnglish),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(l10n.retailMode),
            subtitle: Text(l10n.retailModeSubtitle),
            value: _retailMode,
            onChanged: (v) => setState(() => _retailMode = v),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _autoLockMinutes,
            decoration: InputDecoration(labelText: l10n.autoLockMinutes),
            items: const [0, 1, 5, 10, 15, 30]
                .map(
                  (m) => DropdownMenuItem(
                    value: m,
                    child: Text(m == 0 ? '0 (off)' : '$m'),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _autoLockMinutes = v ?? 5),
          ),
          SwitchListTile(
            title: Text(l10n.autoBackup),
            value: _autoBackup,
            onChanged: (v) => setState(() => _autoBackup = v),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: Text(l10n.systemStatus),
            subtitle: Text(
              '${l10n.databaseConnected} • '
              '${l10n.databaseSchemaVersion(AppDatabase.currentSchemaVersion)}',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

final _nextInvoiceProvider = FutureProvider<String>((ref) {
  return ref.watch(invoiceSequenceServiceProvider).peekNextInvoiceNumber();
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_provider.dart';
import '../domain/password_hasher.dart';

/// First-run screen: creates the one-time Owner/Admin account and
/// shows the Recovery Key exactly once (hashed in the database).
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _username = TextEditingController();
  final _displayName = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _pin = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _username.dispose();
    _displayName.dispose();
    _password.dispose();
    _confirm.dispose();
    _pin.dispose();
    super.dispose();
  }

  bool _validPin(String pin) =>
      RegExp(r'^\d{4,6}$').hasMatch(pin.trim());

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final username = _username.text.trim();
    final displayName = _displayName.text.trim();
    if (username.isEmpty ||
        displayName.isEmpty ||
        _password.text.isEmpty ||
        _pin.text.isEmpty) {
      setState(() => _error = l10n.fillAllFields);
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = l10n.passwordsDoNotMatch);
      return;
    }
    if (!_validPin(_pin.text)) {
      setState(() => _error = l10n.pinRule);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final recoveryKey = RecoveryKey.generate();
    try {
      await ref
          .read(authProvider.notifier)
          .completeSetup(
            username: username,
            displayName: displayName,
            password: _password.text,
            pin: _pin.text.trim(),
            recoveryKeyPlain: recoveryKey,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(l10n.recoveryKeyTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectableText(
                recoveryKey,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(l10n.recoveryKeyWarning),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.recoveryKeySavedButton),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = l10n.somethingWentWrong('$error'));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.setupTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(l10n.setupSubtitle, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextField(
                  controller: _username,
                  decoration: InputDecoration(labelText: l10n.username),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _displayName,
                  decoration: InputDecoration(labelText: l10n.displayName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l10n.password),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirm,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.confirmPassword,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pin,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l10n.pin),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: Text(l10n.createOwnerAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

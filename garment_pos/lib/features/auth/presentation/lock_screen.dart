import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_provider.dart';
import '../domain/app_user.dart';

/// Shown when the session is locked (auto-lock or manual lock).
/// The user unlocks with their own password or PIN, or signs out.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({required this.user, super.key});

  final AppUser user;

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _secret = TextEditingController();
  bool _usePin = true;
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _secret.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref
        .read(authProvider.notifier)
        .unlock(
          password: _usePin ? null : _secret.text,
          pin: _usePin ? _secret.text.trim() : null,
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = ok ? null : l10n.unlockFailed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_outline, size: 56),
                const SizedBox(height: 16),
                Text(
                  widget.user.displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(l10n.lockedMessage, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextField(
                  controller: _secret,
                  obscureText: true,
                  keyboardType: _usePin
                      ? TextInputType.number
                      : TextInputType.text,
                  onSubmitted: (_) => _unlock(),
                  decoration: InputDecoration(
                    labelText: _usePin ? l10n.pin : l10n.password,
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _unlock,
                  child: Text(l10n.unlock),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _usePin = !_usePin;
                    _secret.clear();
                    _error = null;
                  }),
                  child: Text(
                    _usePin ? l10n.usePasswordInstead : l10n.usePinInstead,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

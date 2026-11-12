import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_provider.dart';
import '../data/auth_repository.dart';
import '../domain/app_user.dart';

/// Offline login: username + password, or pick a user and enter PIN.
/// Also hosts the Recovery-Key password reset for the owner.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _pin = TextEditingController();
  int? _selectedUserId;
  String? _error;
  String? _info;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _username.dispose();
    _password.dispose();
    _pin.dispose();
    super.dispose();
  }

  Future<void> _loginWithPassword() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    final ok = await ref
        .read(authProvider.notifier)
        .signInWithPassword(_username.text, _password.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = ok ? null : l10n.wrongCredentials;
    });
  }

  Future<void> _loginWithPin() async {
    final l10n = AppLocalizations.of(context);
    final userId = _selectedUserId;
    if (userId == null) {
      setState(() => _error = l10n.fillAllFields);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    final ok = await ref
        .read(authProvider.notifier)
        .signInWithPin(userId, _pin.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = ok ? null : l10n.wrongCredentials;
    });
  }

  Future<void> _showRecoveryDialog() async {
    final l10n = AppLocalizations.of(context);
    final keyController = TextEditingController();
    final newPasswordController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recoveryResetTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: InputDecoration(labelText: l10n.recoveryKeyLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPassword),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final ok = await ref
                  .read(authRepositoryProvider)
                  .resetAdminPasswordWithRecoveryKey(
                    recoveryKeyPlain: keyController.text,
                    newPassword: newPasswordController.text,
                  );
              if (context.mounted) Navigator.of(context).pop(ok);
            },
            child: Text(l10n.resetPassword),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      if (result == true) {
        _info = l10n.passwordResetDone;
        _error = null;
      } else if (result == false) {
        _error = l10n.recoveryFailed;
        _info = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pinUsers = ref.watch(_pinUsersProvider);
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
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabs,
                  tabs: [
                    Tab(text: l10n.loginWithPassword),
                    Tab(text: l10n.loginWithPin),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      // Password login
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          TextField(
                            controller: _username,
                            decoration: InputDecoration(
                              labelText: l10n.username,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _password,
                            obscureText: true,
                            onSubmitted: (_) => _loginWithPassword(),
                            decoration: InputDecoration(
                              labelText: l10n.password,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _busy ? null : _loginWithPassword,
                            child: Text(l10n.login),
                          ),
                          TextButton(
                            onPressed: _showRecoveryDialog,
                            child: Text(l10n.forgotPassword),
                          ),
                        ],
                      ),
                      // PIN login
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          pinUsers.when(
                            data: (users) => DropdownButtonFormField<int>(
                              initialValue: _selectedUserId,
                              decoration: InputDecoration(
                                labelText: l10n.selectUser,
                              ),
                              items: users
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u.id,
                                      child: Text(u.displayName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedUserId = value),
                            ),
                            loading: () => const LinearProgressIndicator(),
                            error: (e, _) =>
                                Text(l10n.somethingWentWrong('$e')),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _pin,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            onSubmitted: (_) => _loginWithPin(),
                            decoration: InputDecoration(labelText: l10n.pin),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _busy ? null : _loginWithPin,
                            child: Text(l10n.login),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (_info != null)
                  Text(_info!, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _pinUsersProvider = FutureProvider<List<AppUser>>((ref) {
  return ref.watch(authRepositoryProvider).listUsersForPinLogin();
});

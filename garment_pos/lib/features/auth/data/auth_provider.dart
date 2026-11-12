import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/database_provider.dart';
import '../../../data/repositories/settings_repository.dart';
import '../domain/app_user.dart';
import 'auth_repository.dart';

/// Authentication lifecycle of the app (Phase 2).
///
/// The session lives in memory only: restarting the app always
/// requires a fresh login. [AuthLocked] keeps the user identity so
/// auto-lock can be released with that user's password or PIN
/// without losing the session.
sealed class AuthState {
  const AuthState();
}

/// Still checking whether the shop has been set up.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// No user exists yet — show the first-time owner setup.
class AuthNeedsSetup extends AuthState {
  const AuthNeedsSetup();
}

/// Users exist but nobody is signed in.
class AuthSignedOut extends AuthState {
  const AuthSignedOut();
}

/// Signed in, with the user's effective permission matrix loaded.
class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.user, this.permissions);

  final AppUser user;
  final Map<String, bool> permissions;

  bool can(String permissionKey) => permissions[permissionKey] ?? false;
}

/// Session locked by auto-lock or manually; [user] stays signed in
/// behind the lock screen.
class AuthLocked extends AuthState {
  const AuthLocked(this.user, this.permissions);

  final AppUser user;
  final Map<String, bool> permissions;
}

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    Future<void>(() async {
      await _repository.ensureSeedData();
      final hasUsers = await _repository.hasAnyUser();
      state = hasUsers ? const AuthSignedOut() : const AuthNeedsSetup();
    });
    return const AuthLoading();
  }

  /// Completes first-time setup and signs the owner in.
  Future<void> completeSetup({
    required String username,
    required String displayName,
    required String password,
    required String pin,
    required String recoveryKeyPlain,
  }) async {
    final user = await _repository.createOwner(
      username: username,
      displayName: displayName,
      password: password,
      pin: pin,
      recoveryKeyPlain: recoveryKeyPlain,
    );
    await _signIn(user);
  }

  Future<bool> signInWithPassword(String username, String password) async {
    final user = await _repository.authenticateWithPassword(
      username,
      password,
    );
    if (user == null) return false;
    await _signIn(user);
    return true;
  }

  Future<bool> signInWithPin(int userId, String pin) async {
    final user = await _repository.authenticateWithPin(userId, pin);
    if (user == null) return false;
    await _signIn(user);
    return true;
  }

  /// Releases the lock screen with the locked user's password/PIN.
  Future<bool> unlock({String? password, String? pin}) async {
    final current = state;
    if (current is! AuthLocked) return false;
    AppUser? user;
    if (password != null) {
      user = await _repository.authenticateWithPassword(
        current.user.username,
        password,
      );
    } else if (pin != null) {
      user = await _repository.authenticateWithPin(current.user.id, pin);
    }
    if (user == null) return false;
    state = AuthSignedIn(current.user, current.permissions);
    return true;
  }

  /// Locks the session (used by auto-lock and the manual lock button).
  void lock() {
    final current = state;
    if (current is AuthSignedIn) {
      state = AuthLocked(current.user, current.permissions);
    }
  }

  Future<void> signOut() async {
    final current = state;
    final user = switch (current) {
      AuthSignedIn(:final user) => user,
      AuthLocked(:final user) => user,
      _ => null,
    };
    if (user != null) {
      await _repository.logAction(userId: user.id, action: 'auth.logout');
    }
    state = const AuthSignedOut();
  }

  Future<void> _signIn(AppUser user) async {
    final permissions = await _repository.effectivePermissions(user.id);
    state = AuthSignedIn(user, permissions);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(appDatabaseProvider),
    settings: ref.watch(settingsRepositoryProvider),
  );
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

/// Convenience: the signed-in (or locked) user, else null.
final currentUserProvider = Provider<AppUser?>((ref) {
  return switch (ref.watch(authProvider)) {
    AuthSignedIn(:final user) => user,
    AuthLocked(:final user) => user,
    _ => null,
  };
});

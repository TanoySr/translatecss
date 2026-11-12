import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Salted PBKDF2-HMAC-SHA256 password / PIN hashing.
///
/// A plain SHA-256 of a password is NOT safe (fast to brute-force).
/// PBKDF2 deliberately repeats the hash many times and uses a random
/// per-secret salt, so two users with the same password still get
/// different stored values and rainbow tables are useless.
///
/// Stored format (single text column, self-describing):
/// `pbkdf2-sha256$<iterations>$<base64 salt>$<base64 hash>`
class PasswordHasher {
  PasswordHasher({this.iterations = defaultIterations});

  /// OWASP-recommended order of magnitude for PBKDF2-HMAC-SHA256.
  static const int defaultIterations = 120000;

  static const int _saltBytes = 16;
  static const int _hashBits = 256;

  final int iterations;

  final Random _random = Random.secure();

  /// Hashes [secret] with a fresh random salt.
  Future<String> hash(String secret) async {
    final salt = Uint8List.fromList(
      List<int>.generate(_saltBytes, (_) => _random.nextInt(256)),
    );
    final derived = await _derive(secret, salt, iterations);
    return 'pbkdf2-sha256\$$iterations\$${base64Encode(salt)}\$'
        '${base64Encode(derived)}';
  }

  /// Verifies [secret] against a stored [encoded] hash produced by
  /// [hash]. Returns false for malformed stored values instead of
  /// throwing, so login can simply report "wrong password".
  Future<bool> verify(String secret, String encoded) async {
    try {
      final parts = encoded.split('\$');
      if (parts.length != 4 || parts[0] != 'pbkdf2-sha256') return false;
      final storedIterations = int.parse(parts[1]);
      final salt = base64Decode(parts[2]);
      final expected = base64Decode(parts[3]);
      final derived = await _derive(secret, salt, storedIterations);
      return _constantTimeEquals(derived, expected);
    } catch (_) {
      return false;
    }
  }

  Future<List<int>> _derive(
    String secret,
    List<int> salt,
    int iterationCount,
  ) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterationCount,
      bits: _hashBits,
    );
    final key = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(secret)),
      nonce: salt,
    );
    return key.extractBytes();
  }

  /// Compares byte lists without leaking where they first differ.
  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

/// Generates and validates the one-time owner Recovery Key.
///
/// Format: 20 characters from an unambiguous alphabet (no 0/O, 1/I),
/// grouped in fours, e.g. `K7QX-9M2P-R4TD-8WZK-3H6N`.
/// Only a PBKDF2 hash of the key is stored; the plain key is shown
/// once during setup so the owner can print/save it.
class RecoveryKey {
  const RecoveryKey._();

  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Creates a new random recovery key (plain text, shown once).
  static String generate() {
    final random = Random.secure();
    final chars = List<String>.generate(
      20,
      (_) => _alphabet[random.nextInt(_alphabet.length)],
    );
    final groups = <String>[];
    for (var i = 0; i < chars.length; i += 4) {
      groups.add(chars.sublist(i, i + 4).join());
    }
    return groups.join('-');
  }

  /// Removes grouping/space and upper-cases user input for hashing
  /// and comparison, so `k7qx 9m2p ...` also works.
  static String normalize(String input) {
    return input.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  }

  /// A key the owner types must normalize to exactly 20 characters.
  static bool looksValid(String input) => normalize(input).length == 20;
}

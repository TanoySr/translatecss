import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/features/auth/domain/password_hasher.dart';

void main() {
  group('PasswordHasher (PBKDF2 salted)', () {
    final hasher = PasswordHasher(iterations: 2000);

    test('hash is not the plain password and is self-describing', () async {
      final stored = await hasher.hash('secret123');
      expect(stored, isNot(contains('secret123')));
      expect(stored.startsWith('pbkdf2-sha256\$2000\$'), isTrue);
      expect(stored.split('\$'), hasLength(4));
    });

    test('correct password verifies, wrong password fails', () async {
      final stored = await hasher.hash('my-password');
      expect(await hasher.verify('my-password', stored), isTrue);
      expect(await hasher.verify('other-password', stored), isFalse);
    });

    test('same password hashes differently (random salt)', () async {
      final a = await hasher.hash('same');
      final b = await hasher.hash('same');
      expect(a, isNot(equals(b)));
      expect(await hasher.verify('same', a), isTrue);
      expect(await hasher.verify('same', b), isTrue);
    });

    test('malformed stored values fail safely', () async {
      expect(await hasher.verify('x', 'not-a-hash'), isFalse);
      expect(await hasher.verify('x', ''), isFalse);
    });
  });

  group('RecoveryKey', () {
    test('generated key has 20 significant characters', () {
      final key = RecoveryKey.generate();
      expect(RecoveryKey.normalize(key), hasLength(20));
      expect(RecoveryKey.looksValid(key), isTrue);
    });

    test('normalization accepts lowercase and spaces', () {
      expect(RecoveryKey.normalize('k7qx-9m2p r4td'), 'K7QX9M2PR4TD');
      expect(RecoveryKey.looksValid('too-short'), isFalse);
    });
  });
}

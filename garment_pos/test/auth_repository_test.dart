import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/features/auth/data/auth_repository.dart';
import 'package:garment_pos/features/auth/domain/password_hasher.dart';
import 'package:garment_pos/features/auth/domain/permissions.dart';

void main() {
  group('AuthRepository (Phase 2)', () {
    late AppDatabase database;
    late AuthRepository repo;
    late int ownerId;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      repo = AuthRepository(
        database,
        hasher: PasswordHasher(iterations: 1000),
      );
      final owner = await repo.createOwner(
        username: 'admin',
        displayName: 'Shop Owner',
        password: 'owner-pass',
        pin: '1234',
        recoveryKeyPlain: 'TEST-RECOVERY-KEY-0001',
      );
      ownerId = owner.id;
    });

    tearDown(() async => database.close());

    test('owner setup creates an admin who can login by password', () async {
      expect(await repo.hasAnyUser(), isTrue);
      final user = await repo.authenticateWithPassword(
        'admin',
        'owner-pass',
      );
      expect(user, isNotNull);
      expect(user!.roleName, AppRoles.admin);
      expect(await repo.authenticateWithPassword('admin', 'wrong'), isNull);
      expect(await repo.authenticateWithPassword('ghost', 'x'), isNull);
    });

    test('PIN login works and wrong PIN fails', () async {
      expect(await repo.authenticateWithPin(ownerId, '1234'), isNotNull);
      expect(await repo.authenticateWithPin(ownerId, '9999'), isNull);
    });

    test('admin can create a salesman; duplicates are rejected', () async {
      final salesman = await repo.createUser(
        actorId: ownerId,
        username: 'sales1',
        displayName: 'Sales One',
        password: 'sales-pass',
        pin: '4321',
        roleName: AppRoles.salesman,
      );
      expect(salesman.roleName, AppRoles.salesman);
      await expectLater(
        repo.createUser(
          actorId: ownerId,
          username: 'sales1',
          displayName: 'Duplicate',
          password: 'x',
          roleName: AppRoles.salesman,
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('salesman cannot see purchase price, cost or profit', () async {
      final salesman = await repo.createUser(
        actorId: ownerId,
        username: 'sales1',
        displayName: 'Sales One',
        password: 'sales-pass',
        roleName: AppRoles.salesman,
      );
      expect(await repo.can(salesman.id, AppPermissions.purchasePriceView), isFalse);
      expect(await repo.can(salesman.id, AppPermissions.productCostView), isFalse);
      expect(await repo.can(salesman.id, AppPermissions.profitView), isFalse);
      expect(await repo.can(salesman.id, AppPermissions.posUse), isTrue);
      // Admin can see everything, including profit.
      expect(await repo.can(ownerId, AppPermissions.profitView), isTrue);
    });

    test('disabled user cannot login', () async {
      final salesman = await repo.createUser(
        actorId: ownerId,
        username: 'sales1',
        displayName: 'Sales One',
        password: 'sales-pass',
        roleName: AppRoles.salesman,
      );
      await repo.setUserActive(
        actorId: ownerId,
        userId: salesman.id,
        active: false,
      );
      expect(
        await repo.authenticateWithPassword('sales1', 'sales-pass'),
        isNull,
      );
    });

    test('admin password reset and recovery-key reset are audited', () async {
      final salesman = await repo.createUser(
        actorId: ownerId,
        username: 'sales1',
        displayName: 'Sales One',
        password: 'sales-pass',
        roleName: AppRoles.salesman,
      );
      await repo.resetPassword(
        actorId: ownerId,
        targetUserId: salesman.id,
        newPassword: 'new-pass',
      );
      expect(
        await repo.authenticateWithPassword('sales1', 'new-pass'),
        isNotNull,
      );

      expect(
        await repo.resetAdminPasswordWithRecoveryKey(
          recoveryKeyPlain: 'WRONG-KEY',
          newPassword: 'hacked',
        ),
        isFalse,
      );
      expect(
        await repo.resetAdminPasswordWithRecoveryKey(
          recoveryKeyPlain: 'TEST-RECOVERY-KEY-0001',
          newPassword: 'recovered-pass',
        ),
        isTrue,
      );
      expect(
        await repo.authenticateWithPassword('admin', 'recovered-pass'),
        isNotNull,
      );

      final actions = (await repo.recentAuditLogs())
          .map((e) => e.action)
          .toList();
      expect(actions, contains('password.reset'));
      expect(actions, contains('password.recovery_reset'));
      expect(actions, contains('user.create'));
    });

    test('role matrix change takes effect for role members', () async {
      final salesman = await repo.createUser(
        actorId: ownerId,
        username: 'sales1',
        displayName: 'Sales One',
        password: 'sales-pass',
        roleName: AppRoles.salesman,
      );
      expect(await repo.can(salesman.id, AppPermissions.reportsView), isFalse);
      final salesmanRole = await repo.roleByName(AppRoles.salesman);
      await repo.setRolePermission(
        actorId: ownerId,
        roleId: salesmanRole.id,
        permissionKey: AppPermissions.reportsView,
        allowed: true,
      );
      expect(await repo.can(salesman.id, AppPermissions.reportsView), isTrue);
    });
  });
}

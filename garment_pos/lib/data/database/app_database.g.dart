// GENERATED CODE - DO NOT MODIFY BY HAND

// Regenerate with: dart run build_runner build

part of 'app_database.dart';

// ignore_for_file: type=lint

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>('key', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>('value', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}
class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final int updatedAt;
  const AppSetting({required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }
  factory AppSetting.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(map['key']),
      value: serializer.fromJson<String>(map['value']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('AppSetting(')..write('key: $key, value: $value, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AppSetting && other.key == key && other.value == value && other.updatedAt == updatedAt);
  AppSetting copyWith({String? key, String? value, int? updatedAt}) {
    return AppSetting(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key), value = Value(value), updatedAt = Value(updatedAt);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users
    with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _usernameMeta = VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>('username', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta = VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>('display_name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordHashMeta = VerificationMeta('passwordHash');
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>('password_hash', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinHashMeta = VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>('pin_hash', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleIdMeta = VerificationMeta('roleId');
  @override
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>('role_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta = VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta = VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>('created_by', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, username, displayName, passwordHash, pinHash, roleId, isActive, createdAt, updatedAt, createdBy];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta, username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(_passwordHashMeta, passwordHash.isAcceptableOrUnknown(data['password_hash']!, _passwordHashMeta));
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta, pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta, roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta, isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      passwordHash: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}password_hash'])!,
      pinHash: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      roleId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}role_id'])!,
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_by']),
    );
  }
  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}
class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String displayName;
  final String passwordHash;
  final String? pinHash;
  final int roleId;
  final bool isActive;
  final int createdAt;
  final int updatedAt;
  final int? createdBy;
  const User({required this.id, required this.username, required this.displayName, required this.passwordHash, this.pinHash, required this.roleId, required this.isActive, required this.createdAt, required this.updatedAt, this.createdBy});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    map['password_hash'] = Variable<String>(passwordHash);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    map['role_id'] = Variable<int>(roleId);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<int>(createdBy);
    }
    return map;
  }
  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      passwordHash: Value(passwordHash),
      pinHash: pinHash == null && nullToAbsent ? const Value.absent() : Value(pinHash),
      roleId: Value(roleId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),
    );
  }
  factory User.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(map['id']),
      username: serializer.fromJson<String>(map['username']),
      displayName: serializer.fromJson<String>(map['displayName']),
      passwordHash: serializer.fromJson<String>(map['passwordHash']),
      pinHash: serializer.fromJson<String?>(map['pinHash']),
      roleId: serializer.fromJson<int>(map['roleId']),
      isActive: serializer.fromJson<bool>(map['isActive']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
      createdBy: serializer.fromJson<int?>(map['createdBy']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('User(')..write('id: $id, username: $username, displayName: $displayName, passwordHash: $passwordHash, pinHash: $pinHash, roleId: $roleId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, username, displayName, passwordHash, pinHash, roleId, isActive, createdAt, updatedAt, createdBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is User && other.id == id && other.username == username && other.displayName == displayName && other.passwordHash == passwordHash && other.pinHash == pinHash && other.roleId == roleId && other.isActive == isActive && other.createdAt == createdAt && other.updatedAt == updatedAt && other.createdBy == createdBy);
  User copyWith({int? id, String? username, String? displayName, String? passwordHash, String? pinHash, int? roleId, bool? isActive, int? createdAt, int? updatedAt, int? createdBy}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      roleId: roleId ?? this.roleId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String> passwordHash;
  final Value<String?> pinHash;
  final Value<int> roleId;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> createdBy;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.roleId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String displayName,
    required String passwordHash,
    this.pinHash = const Value.absent(),
    required int roleId,
    required bool isActive,
    required int createdAt,
    required int updatedAt,
    this.createdBy = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : username = Value(username), displayName = Value(displayName), passwordHash = Value(passwordHash), roleId = Value(roleId), isActive = Value(isActive), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? passwordHash,
    Expression<String>? pinHash,
    Expression<int>? roleId,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? createdBy,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (pinHash != null) 'pin_hash': pinHash,
      if (roleId != null) 'role_id': roleId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (rowid != null) 'rowid': rowid,
    });
  }
  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? displayName,
    Value<String>? passwordHash,
    Value<String?>? pinHash,
    Value<int>? roleId,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? createdBy,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      passwordHash: passwordHash ?? this.passwordHash,
      pinHash: pinHash ?? this.pinHash,
      roleId: roleId ?? this.roleId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('pinHash: $pinHash, ')
          ..write('roleId: $roleId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolesTable extends Roles
    with TableInfo<$RolesTable, Role> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta = VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>('display_name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSystemMeta = VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>('is_system', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, displayName, isSystem, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(Insertable<Role> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta, isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    } else if (isInserting) {
      context.missing(_isSystemMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Role(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      isSystem: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}
class Role extends DataClass implements Insertable<Role> {
  final int id;
  final String name;
  final String displayName;
  final bool isSystem;
  final int createdAt;
  final int updatedAt;
  const Role({required this.id, required this.name, required this.displayName, required this.isSystem, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    map['is_system'] = Variable<bool>(isSystem);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      name: Value(name),
      displayName: Value(displayName),
      isSystem: Value(isSystem),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory Role.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      displayName: serializer.fromJson<String>(map['displayName']),
      isSystem: serializer.fromJson<bool>(map['isSystem']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('Role(')..write('id: $id, name: $name, displayName: $displayName, isSystem: $isSystem, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, displayName, isSystem, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Role && other.id == id && other.name == name && other.displayName == displayName && other.isSystem == isSystem && other.createdAt == createdAt && other.updatedAt == updatedAt);
  Role copyWith({int? id, String? name, String? displayName, bool? isSystem, int? createdAt, int? updatedAt}) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class RolesCompanion extends UpdateCompanion<Role> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> displayName;
  final Value<bool> isSystem;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String displayName,
    required bool isSystem,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), displayName = Value(displayName), isSystem = Value(isSystem), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<Role> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<bool>? isSystem,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (isSystem != null) 'is_system': isSystem,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  RolesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? displayName,
    Value<bool>? isSystem,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PermissionsTable extends Permissions
    with TableInfo<$PermissionsTable, Permission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _permissionKeyMeta = VerificationMeta('permissionKey');
  @override
  late final GeneratedColumn<String> permissionKey = GeneratedColumn<String>('permission_key', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta = VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>('display_name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, permissionKey, displayName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'permissions';
  @override
  VerificationContext validateIntegrity(Insertable<Permission> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('permission_key')) {
      context.handle(_permissionKeyMeta, permissionKey.isAcceptableOrUnknown(data['permission_key']!, _permissionKeyMeta));
    } else if (isInserting) {
      context.missing(_permissionKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Permission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Permission(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      permissionKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}permission_key'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $PermissionsTable createAlias(String alias) {
    return $PermissionsTable(attachedDatabase, alias);
  }
}
class Permission extends DataClass implements Insertable<Permission> {
  final int id;
  final String permissionKey;
  final String displayName;
  final int createdAt;
  final int updatedAt;
  const Permission({required this.id, required this.permissionKey, required this.displayName, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['permission_key'] = Variable<String>(permissionKey);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  PermissionsCompanion toCompanion(bool nullToAbsent) {
    return PermissionsCompanion(
      id: Value(id),
      permissionKey: Value(permissionKey),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory Permission.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Permission(
      id: serializer.fromJson<int>(map['id']),
      permissionKey: serializer.fromJson<String>(map['permissionKey']),
      displayName: serializer.fromJson<String>(map['displayName']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('Permission(')..write('id: $id, permissionKey: $permissionKey, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, permissionKey, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Permission && other.id == id && other.permissionKey == permissionKey && other.displayName == displayName && other.createdAt == createdAt && other.updatedAt == updatedAt);
  Permission copyWith({int? id, String? permissionKey, String? displayName, int? createdAt, int? updatedAt}) {
    return Permission(
      id: id ?? this.id,
      permissionKey: permissionKey ?? this.permissionKey,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class PermissionsCompanion extends UpdateCompanion<Permission> {
  final Value<int> id;
  final Value<String> permissionKey;
  final Value<String> displayName;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PermissionsCompanion({
    this.id = const Value.absent(),
    this.permissionKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PermissionsCompanion.insert({
    this.id = const Value.absent(),
    required String permissionKey,
    required String displayName,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : permissionKey = Value(permissionKey), displayName = Value(displayName), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<Permission> custom({
    Expression<int>? id,
    Expression<String>? permissionKey,
    Expression<String>? displayName,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (permissionKey != null) 'permission_key': permissionKey,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  PermissionsCompanion copyWith({
    Value<int>? id,
    Value<String>? permissionKey,
    Value<String>? displayName,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PermissionsCompanion(
      id: id ?? this.id,
      permissionKey: permissionKey ?? this.permissionKey,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (permissionKey.present) {
      map['permission_key'] = Variable<String>(permissionKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('PermissionsCompanion(')
          ..write('id: $id, ')
          ..write('permissionKey: $permissionKey, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RolePermissionsTable extends RolePermissions
    with TableInfo<$RolePermissionsTable, RolePermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolePermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _roleIdMeta = VerificationMeta('roleId');
  @override
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>('role_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _permissionIdMeta = VerificationMeta('permissionId');
  @override
  late final GeneratedColumn<int> permissionId = GeneratedColumn<int>('permission_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allowedMeta = VerificationMeta('allowed');
  @override
  late final GeneratedColumn<bool> allowed = GeneratedColumn<bool>('allowed', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, roleId, permissionId, allowed, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'role_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<RolePermission> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role_id')) {
      context.handle(_roleIdMeta, roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta));
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    if (data.containsKey('permission_id')) {
      context.handle(_permissionIdMeta, permissionId.isAcceptableOrUnknown(data['permission_id']!, _permissionIdMeta));
    } else if (isInserting) {
      context.missing(_permissionIdMeta);
    }
    if (data.containsKey('allowed')) {
      context.handle(_allowedMeta, allowed.isAcceptableOrUnknown(data['allowed']!, _allowedMeta));
    } else if (isInserting) {
      context.missing(_allowedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RolePermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RolePermission(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      roleId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}role_id'])!,
      permissionId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}permission_id'])!,
      allowed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}allowed'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $RolePermissionsTable createAlias(String alias) {
    return $RolePermissionsTable(attachedDatabase, alias);
  }
}
class RolePermission extends DataClass implements Insertable<RolePermission> {
  final int id;
  final int roleId;
  final int permissionId;
  final bool allowed;
  final int createdAt;
  final int updatedAt;
  const RolePermission({required this.id, required this.roleId, required this.permissionId, required this.allowed, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role_id'] = Variable<int>(roleId);
    map['permission_id'] = Variable<int>(permissionId);
    map['allowed'] = Variable<bool>(allowed);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  RolePermissionsCompanion toCompanion(bool nullToAbsent) {
    return RolePermissionsCompanion(
      id: Value(id),
      roleId: Value(roleId),
      permissionId: Value(permissionId),
      allowed: Value(allowed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory RolePermission.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RolePermission(
      id: serializer.fromJson<int>(map['id']),
      roleId: serializer.fromJson<int>(map['roleId']),
      permissionId: serializer.fromJson<int>(map['permissionId']),
      allowed: serializer.fromJson<bool>(map['allowed']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('RolePermission(')..write('id: $id, roleId: $roleId, permissionId: $permissionId, allowed: $allowed, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, roleId, permissionId, allowed, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RolePermission && other.id == id && other.roleId == roleId && other.permissionId == permissionId && other.allowed == allowed && other.createdAt == createdAt && other.updatedAt == updatedAt);
  RolePermission copyWith({int? id, int? roleId, int? permissionId, bool? allowed, int? createdAt, int? updatedAt}) {
    return RolePermission(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      allowed: allowed ?? this.allowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class RolePermissionsCompanion extends UpdateCompanion<RolePermission> {
  final Value<int> id;
  final Value<int> roleId;
  final Value<int> permissionId;
  final Value<bool> allowed;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const RolePermissionsCompanion({
    this.id = const Value.absent(),
    this.roleId = const Value.absent(),
    this.permissionId = const Value.absent(),
    this.allowed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RolePermissionsCompanion.insert({
    this.id = const Value.absent(),
    required int roleId,
    required int permissionId,
    required bool allowed,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : roleId = Value(roleId), permissionId = Value(permissionId), allowed = Value(allowed), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<RolePermission> custom({
    Expression<int>? id,
    Expression<int>? roleId,
    Expression<int>? permissionId,
    Expression<bool>? allowed,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roleId != null) 'role_id': roleId,
      if (permissionId != null) 'permission_id': permissionId,
      if (allowed != null) 'allowed': allowed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  RolePermissionsCompanion copyWith({
    Value<int>? id,
    Value<int>? roleId,
    Value<int>? permissionId,
    Value<bool>? allowed,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return RolePermissionsCompanion(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      permissionId: permissionId ?? this.permissionId,
      allowed: allowed ?? this.allowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (permissionId.present) {
      map['permission_id'] = Variable<int>(permissionId.value);
    }
    if (allowed.present) {
      map['allowed'] = Variable<bool>(allowed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('RolePermissionsCompanion(')
          ..write('id: $id, ')
          ..write('roleId: $roleId, ')
          ..write('permissionId: $permissionId, ')
          ..write('allowed: $allowed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPermissionsTable extends UserPermissions
    with TableInfo<$UserPermissionsTable, UserPermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>('user_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _permissionIdMeta = VerificationMeta('permissionId');
  @override
  late final GeneratedColumn<int> permissionId = GeneratedColumn<int>('permission_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _allowedMeta = VerificationMeta('allowed');
  @override
  late final GeneratedColumn<bool> allowed = GeneratedColumn<bool>('allowed', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, permissionId, allowed, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<UserPermission> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('permission_id')) {
      context.handle(_permissionIdMeta, permissionId.isAcceptableOrUnknown(data['permission_id']!, _permissionIdMeta));
    } else if (isInserting) {
      context.missing(_permissionIdMeta);
    }
    if (data.containsKey('allowed')) {
      context.handle(_allowedMeta, allowed.isAcceptableOrUnknown(data['allowed']!, _allowedMeta));
    } else if (isInserting) {
      context.missing(_allowedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPermission(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      permissionId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}permission_id'])!,
      allowed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}allowed'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $UserPermissionsTable createAlias(String alias) {
    return $UserPermissionsTable(attachedDatabase, alias);
  }
}
class UserPermission extends DataClass implements Insertable<UserPermission> {
  final int id;
  final int userId;
  final int permissionId;
  final bool allowed;
  final int createdAt;
  final int updatedAt;
  const UserPermission({required this.id, required this.userId, required this.permissionId, required this.allowed, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['permission_id'] = Variable<int>(permissionId);
    map['allowed'] = Variable<bool>(allowed);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  UserPermissionsCompanion toCompanion(bool nullToAbsent) {
    return UserPermissionsCompanion(
      id: Value(id),
      userId: Value(userId),
      permissionId: Value(permissionId),
      allowed: Value(allowed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory UserPermission.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPermission(
      id: serializer.fromJson<int>(map['id']),
      userId: serializer.fromJson<int>(map['userId']),
      permissionId: serializer.fromJson<int>(map['permissionId']),
      allowed: serializer.fromJson<bool>(map['allowed']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('UserPermission(')..write('id: $id, userId: $userId, permissionId: $permissionId, allowed: $allowed, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, userId, permissionId, allowed, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserPermission && other.id == id && other.userId == userId && other.permissionId == permissionId && other.allowed == allowed && other.createdAt == createdAt && other.updatedAt == updatedAt);
  UserPermission copyWith({int? id, int? userId, int? permissionId, bool? allowed, int? createdAt, int? updatedAt}) {
    return UserPermission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permissionId: permissionId ?? this.permissionId,
      allowed: allowed ?? this.allowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class UserPermissionsCompanion extends UpdateCompanion<UserPermission> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> permissionId;
  final Value<bool> allowed;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const UserPermissionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.permissionId = const Value.absent(),
    this.allowed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPermissionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int permissionId,
    required bool allowed,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId), permissionId = Value(permissionId), allowed = Value(allowed), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<UserPermission> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? permissionId,
    Expression<bool>? allowed,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (permissionId != null) 'permission_id': permissionId,
      if (allowed != null) 'allowed': allowed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  UserPermissionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? permissionId,
    Value<bool>? allowed,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserPermissionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permissionId: permissionId ?? this.permissionId,
      allowed: allowed ?? this.allowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (permissionId.present) {
      map['permission_id'] = Variable<int>(permissionId.value);
    }
    if (allowed.present) {
      map['allowed'] = Variable<bool>(allowed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('UserPermissionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('permissionId: $permissionId, ')
          ..write('allowed: $allowed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>('user_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _actionMeta = VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>('action', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta = VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>('entity_type', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityIdMeta = VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>('entity_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _detailsMeta = VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>('details', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, action, entityType, entityId, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta, action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(_entityTypeMeta, entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta, entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta, details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      action: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      entityType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity_type']),
      entityId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}entity_id']),
      details: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }
  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}
class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final int? userId;
  final String action;
  final String? entityType;
  final int? entityId;
  final String? details;
  final int createdAt;
  const AuditLog({required this.id, this.userId, required this.action, this.entityType, this.entityId, this.details, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(entityType);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }
  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      action: Value(action),
      entityType: entityType == null && nullToAbsent ? const Value.absent() : Value(entityType),
      entityId: entityId == null && nullToAbsent ? const Value.absent() : Value(entityId),
      details: details == null && nullToAbsent ? const Value.absent() : Value(details),
      createdAt: Value(createdAt),
    );
  }
  factory AuditLog.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(map['id']),
      userId: serializer.fromJson<int?>(map['userId']),
      action: serializer.fromJson<String>(map['action']),
      entityType: serializer.fromJson<String?>(map['entityType']),
      entityId: serializer.fromJson<int?>(map['entityId']),
      details: serializer.fromJson<String?>(map['details']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('AuditLog(')..write('id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, details: $details, createdAt: $createdAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, userId, action, entityType, entityId, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuditLog && other.id == id && other.userId == userId && other.action == action && other.entityType == entityType && other.entityId == entityId && other.details == details && other.createdAt == createdAt);
  AuditLog copyWith({int? id, int? userId, String? action, String? entityType, int? entityId, String? details, int? createdAt}) {
    return AuditLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> action;
  final Value<String?> entityType;
  final Value<int?> entityId;
  final Value<String?> details;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String action,
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : action = Value(action), createdAt = Value(createdAt);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? details,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  AuditLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<String>? action,
    Value<String?>? entityType,
    Value<int?>? entityId,
    Value<String?>? details,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NumberSequencesTable extends NumberSequences
    with TableInfo<$NumberSequencesTable, NumberSequence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NumberSequencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sequenceKeyMeta = VerificationMeta('sequenceKey');
  @override
  late final GeneratedColumn<String> sequenceKey = GeneratedColumn<String>('sequence_key', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNumberMeta = VerificationMeta('lastNumber');
  @override
  late final GeneratedColumn<int> lastNumber = GeneratedColumn<int>('last_number', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sequenceKey, lastNumber, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'number_sequences';
  @override
  VerificationContext validateIntegrity(Insertable<NumberSequence> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sequence_key')) {
      context.handle(_sequenceKeyMeta, sequenceKey.isAcceptableOrUnknown(data['sequence_key']!, _sequenceKeyMeta));
    } else if (isInserting) {
      context.missing(_sequenceKeyMeta);
    }
    if (data.containsKey('last_number')) {
      context.handle(_lastNumberMeta, lastNumber.isAcceptableOrUnknown(data['last_number']!, _lastNumberMeta));
    } else if (isInserting) {
      context.missing(_lastNumberMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NumberSequence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NumberSequence(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sequenceKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sequence_key'])!,
      lastNumber: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}last_number'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $NumberSequencesTable createAlias(String alias) {
    return $NumberSequencesTable(attachedDatabase, alias);
  }
}
class NumberSequence extends DataClass implements Insertable<NumberSequence> {
  final int id;
  final String sequenceKey;
  final int lastNumber;
  final int updatedAt;
  const NumberSequence({required this.id, required this.sequenceKey, required this.lastNumber, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sequence_key'] = Variable<String>(sequenceKey);
    map['last_number'] = Variable<int>(lastNumber);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  NumberSequencesCompanion toCompanion(bool nullToAbsent) {
    return NumberSequencesCompanion(
      id: Value(id),
      sequenceKey: Value(sequenceKey),
      lastNumber: Value(lastNumber),
      updatedAt: Value(updatedAt),
    );
  }
  factory NumberSequence.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NumberSequence(
      id: serializer.fromJson<int>(map['id']),
      sequenceKey: serializer.fromJson<String>(map['sequenceKey']),
      lastNumber: serializer.fromJson<int>(map['lastNumber']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('NumberSequence(')..write('id: $id, sequenceKey: $sequenceKey, lastNumber: $lastNumber, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, sequenceKey, lastNumber, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is NumberSequence && other.id == id && other.sequenceKey == sequenceKey && other.lastNumber == lastNumber && other.updatedAt == updatedAt);
  NumberSequence copyWith({int? id, String? sequenceKey, int? lastNumber, int? updatedAt}) {
    return NumberSequence(
      id: id ?? this.id,
      sequenceKey: sequenceKey ?? this.sequenceKey,
      lastNumber: lastNumber ?? this.lastNumber,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class NumberSequencesCompanion extends UpdateCompanion<NumberSequence> {
  final Value<int> id;
  final Value<String> sequenceKey;
  final Value<int> lastNumber;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const NumberSequencesCompanion({
    this.id = const Value.absent(),
    this.sequenceKey = const Value.absent(),
    this.lastNumber = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NumberSequencesCompanion.insert({
    this.id = const Value.absent(),
    required String sequenceKey,
    required int lastNumber,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : sequenceKey = Value(sequenceKey), lastNumber = Value(lastNumber), updatedAt = Value(updatedAt);
  static Insertable<NumberSequence> custom({
    Expression<int>? id,
    Expression<String>? sequenceKey,
    Expression<int>? lastNumber,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sequenceKey != null) 'sequence_key': sequenceKey,
      if (lastNumber != null) 'last_number': lastNumber,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  NumberSequencesCompanion copyWith({
    Value<int>? id,
    Value<String>? sequenceKey,
    Value<int>? lastNumber,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return NumberSequencesCompanion(
      id: id ?? this.id,
      sequenceKey: sequenceKey ?? this.sequenceKey,
      lastNumber: lastNumber ?? this.lastNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sequenceKey.present) {
      map['sequence_key'] = Variable<String>(sequenceKey.value);
    }
    if (lastNumber.present) {
      map['last_number'] = Variable<int>(lastNumber.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('NumberSequencesCompanion(')
          ..write('id: $id, ')
          ..write('sequenceKey: $sequenceKey, ')
          ..write('lastNumber: $lastNumber, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta = VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>('parent_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta, parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int? parentId;
  final int createdAt;
  final int updatedAt;
  const Category({required this.id, required this.name, this.parentId, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent ? const Value.absent() : Value(parentId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory Category.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      parentId: serializer.fromJson<int?>(map['parentId']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('Category(')..write('id: $id, name: $name, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, parentId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Category && other.id == id && other.name == name && other.parentId == parentId && other.createdAt == createdAt && other.updatedAt == updatedAt);
  Category copyWith({int? id, String? name, int? parentId, int? createdAt, int? updatedAt}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands
    with TableInfo<$BrandsTable, Brand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(Insertable<Brand> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Brand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Brand(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }
}
class Brand extends DataClass implements Insertable<Brand> {
  final int id;
  final String name;
  final int createdAt;
  final int updatedAt;
  const Brand({required this.id, required this.name, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory Brand.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Brand(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('Brand(')..write('id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Brand && other.id == id && other.name == name && other.createdAt == createdAt && other.updatedAt == updatedAt);
  Brand copyWith({int? id, String? name, int? createdAt, int? updatedAt}) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class BrandsCompanion extends UpdateCompanion<Brand> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<Brand> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  BrandsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductSizesTable extends ProductSizes
    with TableInfo<$ProductSizesTable, ProductSize> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSizesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta = VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>('sort_order', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta = VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_sizes';
  @override
  VerificationContext validateIntegrity(Insertable<ProductSize> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta, isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductSize map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSize(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $ProductSizesTable createAlias(String alias) {
    return $ProductSizesTable(attachedDatabase, alias);
  }
}
class ProductSize extends DataClass implements Insertable<ProductSize> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;
  final int createdAt;
  final int updatedAt;
  const ProductSize({required this.id, required this.name, required this.sortOrder, required this.isActive, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  ProductSizesCompanion toCompanion(bool nullToAbsent) {
    return ProductSizesCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory ProductSize.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSize(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      sortOrder: serializer.fromJson<int>(map['sortOrder']),
      isActive: serializer.fromJson<bool>(map['isActive']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('ProductSize(')..write('id: $id, name: $name, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductSize && other.id == id && other.name == name && other.sortOrder == sortOrder && other.isActive == isActive && other.createdAt == createdAt && other.updatedAt == updatedAt);
  ProductSize copyWith({int? id, String? name, int? sortOrder, bool? isActive, int? createdAt, int? updatedAt}) {
    return ProductSize(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class ProductSizesCompanion extends UpdateCompanion<ProductSize> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductSizesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSizesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int sortOrder,
    required bool isActive,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), sortOrder = Value(sortOrder), isActive = Value(isActive), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<ProductSize> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductSizesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductSizesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductSizesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductColorsTable extends ProductColors
    with TableInfo<$ProductColorsTable, ProductColor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hexCodeMeta = VerificationMeta('hexCode');
  @override
  late final GeneratedColumn<String> hexCode = GeneratedColumn<String>('hex_code', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta = VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, hexCode, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_colors';
  @override
  VerificationContext validateIntegrity(Insertable<ProductColor> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hex_code')) {
      context.handle(_hexCodeMeta, hexCode.isAcceptableOrUnknown(data['hex_code']!, _hexCodeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta, isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductColor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductColor(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      hexCode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hex_code']),
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $ProductColorsTable createAlias(String alias) {
    return $ProductColorsTable(attachedDatabase, alias);
  }
}
class ProductColor extends DataClass implements Insertable<ProductColor> {
  final int id;
  final String name;
  final String? hexCode;
  final bool isActive;
  final int createdAt;
  final int updatedAt;
  const ProductColor({required this.id, required this.name, this.hexCode, required this.isActive, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || hexCode != null) {
      map['hex_code'] = Variable<String>(hexCode);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  ProductColorsCompanion toCompanion(bool nullToAbsent) {
    return ProductColorsCompanion(
      id: Value(id),
      name: Value(name),
      hexCode: hexCode == null && nullToAbsent ? const Value.absent() : Value(hexCode),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory ProductColor.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductColor(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      hexCode: serializer.fromJson<String?>(map['hexCode']),
      isActive: serializer.fromJson<bool>(map['isActive']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('ProductColor(')..write('id: $id, name: $name, hexCode: $hexCode, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, hexCode, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductColor && other.id == id && other.name == name && other.hexCode == hexCode && other.isActive == isActive && other.createdAt == createdAt && other.updatedAt == updatedAt);
  ProductColor copyWith({int? id, String? name, String? hexCode, bool? isActive, int? createdAt, int? updatedAt}) {
    return ProductColor(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class ProductColorsCompanion extends UpdateCompanion<ProductColor> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> hexCode;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductColorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hexCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductColorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.hexCode = const Value.absent(),
    required bool isActive,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), isActive = Value(isActive), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<ProductColor> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? hexCode,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hexCode != null) 'hex_code': hexCode,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductColorsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? hexCode,
    Value<bool>? isActive,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductColorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hexCode.present) {
      map['hex_code'] = Variable<String>(hexCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductColorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hexCode: $hexCode, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaxRatesTable extends TaxRates
    with TableInfo<$TaxRatesTable, TaxRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateBasisPointsMeta = VerificationMeta('rateBasisPoints');
  @override
  late final GeneratedColumn<int> rateBasisPoints = GeneratedColumn<int>('rate_basis_points', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta = VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>('is_default', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, rateBasisPoints, isDefault, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_rates';
  @override
  VerificationContext validateIntegrity(Insertable<TaxRate> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rate_basis_points')) {
      context.handle(_rateBasisPointsMeta, rateBasisPoints.isAcceptableOrUnknown(data['rate_basis_points']!, _rateBasisPointsMeta));
    } else if (isInserting) {
      context.missing(_rateBasisPointsMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta, isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    } else if (isInserting) {
      context.missing(_isDefaultMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxRate(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      rateBasisPoints: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}rate_basis_points'])!,
      isDefault: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $TaxRatesTable createAlias(String alias) {
    return $TaxRatesTable(attachedDatabase, alias);
  }
}
class TaxRate extends DataClass implements Insertable<TaxRate> {
  final int id;
  final String name;
  final int rateBasisPoints;
  final bool isDefault;
  final int createdAt;
  final int updatedAt;
  const TaxRate({required this.id, required this.name, required this.rateBasisPoints, required this.isDefault, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['rate_basis_points'] = Variable<int>(rateBasisPoints);
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  TaxRatesCompanion toCompanion(bool nullToAbsent) {
    return TaxRatesCompanion(
      id: Value(id),
      name: Value(name),
      rateBasisPoints: Value(rateBasisPoints),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory TaxRate.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxRate(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      rateBasisPoints: serializer.fromJson<int>(map['rateBasisPoints']),
      isDefault: serializer.fromJson<bool>(map['isDefault']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('TaxRate(')..write('id: $id, name: $name, rateBasisPoints: $rateBasisPoints, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, rateBasisPoints, isDefault, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is TaxRate && other.id == id && other.name == name && other.rateBasisPoints == rateBasisPoints && other.isDefault == isDefault && other.createdAt == createdAt && other.updatedAt == updatedAt);
  TaxRate copyWith({int? id, String? name, int? rateBasisPoints, bool? isDefault, int? createdAt, int? updatedAt}) {
    return TaxRate(
      id: id ?? this.id,
      name: name ?? this.name,
      rateBasisPoints: rateBasisPoints ?? this.rateBasisPoints,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class TaxRatesCompanion extends UpdateCompanion<TaxRate> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rateBasisPoints;
  final Value<bool> isDefault;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const TaxRatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rateBasisPoints = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaxRatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int rateBasisPoints,
    required bool isDefault,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : name = Value(name), rateBasisPoints = Value(rateBasisPoints), isDefault = Value(isDefault), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<TaxRate> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rateBasisPoints,
    Expression<bool>? isDefault,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rateBasisPoints != null) 'rate_basis_points': rateBasisPoints,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  TaxRatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? rateBasisPoints,
    Value<bool>? isDefault,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaxRatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rateBasisPoints: rateBasisPoints ?? this.rateBasisPoints,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rateBasisPoints.present) {
      map['rate_basis_points'] = Variable<int>(rateBasisPoints.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('TaxRatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rateBasisPoints: $rateBasisPoints, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productCodeMeta = VerificationMeta('productCode');
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>('product_code', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta = VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>('category_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _brandIdMeta = VerificationMeta('brandId');
  @override
  late final GeneratedColumn<int> brandId = GeneratedColumn<int>('brand_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _subCategoryMeta = VerificationMeta('subCategory');
  @override
  late final GeneratedColumn<String> subCategory = GeneratedColumn<String>('sub_category', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fabricMeta = VerificationMeta('fabric');
  @override
  late final GeneratedColumn<String> fabric = GeneratedColumn<String>('fabric', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fitMeta = VerificationMeta('fit');
  @override
  late final GeneratedColumn<String> fit = GeneratedColumn<String>('fit', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sleeveMeta = VerificationMeta('sleeve');
  @override
  late final GeneratedColumn<String> sleeve = GeneratedColumn<String>('sleeve', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _neckMeta = VerificationMeta('neck');
  @override
  late final GeneratedColumn<String> neck = GeneratedColumn<String>('neck', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hsnCodeMeta = VerificationMeta('hsnCode');
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>('hsn_code', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchasePricePaiseMeta = VerificationMeta('purchasePricePaise');
  @override
  late final GeneratedColumn<int> purchasePricePaise = GeneratedColumn<int>('purchase_price_paise', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wholesalePricePaiseMeta = VerificationMeta('wholesalePricePaise');
  @override
  late final GeneratedColumn<int> wholesalePricePaise = GeneratedColumn<int>('wholesale_price_paise', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _retailPricePaiseMeta = VerificationMeta('retailPricePaise');
  @override
  late final GeneratedColumn<int> retailPricePaise = GeneratedColumn<int>('retail_price_paise', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _minSellingPricePaiseMeta = VerificationMeta('minSellingPricePaise');
  @override
  late final GeneratedColumn<int> minSellingPricePaise = GeneratedColumn<int>('min_selling_price_paise', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _mrpPaiseMeta = VerificationMeta('mrpPaise');
  @override
  late final GeneratedColumn<int> mrpPaise = GeneratedColumn<int>('mrp_paise', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _taxRateBasisPointsMeta = VerificationMeta('taxRateBasisPoints');
  @override
  late final GeneratedColumn<int> taxRateBasisPoints = GeneratedColumn<int>('tax_rate_basis_points', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _wholesaleMinQtyMeta = VerificationMeta('wholesaleMinQty');
  @override
  late final GeneratedColumn<int> wholesaleMinQty = GeneratedColumn<int>('wholesale_min_qty', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lowStockThresholdMeta = VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>('low_stock_threshold', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta = VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>('is_active', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta = VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdByMeta = VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>('created_by', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedByMeta = VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<int> updatedBy = GeneratedColumn<int>('updated_by', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta = VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>('is_deleted', aliasedName, false, type: DriftSqlType.bool, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta = VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>('deleted_at', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, productCode, categoryId, brandId, subCategory, fabric, fit, sleeve, neck, hsnCode, purchasePricePaise, wholesalePricePaise, retailPricePaise, minSellingPricePaise, mrpPaise, taxRateBasisPoints, wholesaleMinQty, lowStockThreshold, isActive, description, createdAt, updatedAt, createdBy, updatedBy, isDeleted, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(_productCodeMeta, productCode.isAcceptableOrUnknown(data['product_code']!, _productCodeMeta));
    } else if (isInserting) {
      context.missing(_productCodeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta, categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('brand_id')) {
      context.handle(_brandIdMeta, brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta));
    }
    if (data.containsKey('sub_category')) {
      context.handle(_subCategoryMeta, subCategory.isAcceptableOrUnknown(data['sub_category']!, _subCategoryMeta));
    }
    if (data.containsKey('fabric')) {
      context.handle(_fabricMeta, fabric.isAcceptableOrUnknown(data['fabric']!, _fabricMeta));
    }
    if (data.containsKey('fit')) {
      context.handle(_fitMeta, fit.isAcceptableOrUnknown(data['fit']!, _fitMeta));
    }
    if (data.containsKey('sleeve')) {
      context.handle(_sleeveMeta, sleeve.isAcceptableOrUnknown(data['sleeve']!, _sleeveMeta));
    }
    if (data.containsKey('neck')) {
      context.handle(_neckMeta, neck.isAcceptableOrUnknown(data['neck']!, _neckMeta));
    }
    if (data.containsKey('hsn_code')) {
      context.handle(_hsnCodeMeta, hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta));
    }
    if (data.containsKey('purchase_price_paise')) {
      context.handle(_purchasePricePaiseMeta, purchasePricePaise.isAcceptableOrUnknown(data['purchase_price_paise']!, _purchasePricePaiseMeta));
    } else if (isInserting) {
      context.missing(_purchasePricePaiseMeta);
    }
    if (data.containsKey('wholesale_price_paise')) {
      context.handle(_wholesalePricePaiseMeta, wholesalePricePaise.isAcceptableOrUnknown(data['wholesale_price_paise']!, _wholesalePricePaiseMeta));
    } else if (isInserting) {
      context.missing(_wholesalePricePaiseMeta);
    }
    if (data.containsKey('retail_price_paise')) {
      context.handle(_retailPricePaiseMeta, retailPricePaise.isAcceptableOrUnknown(data['retail_price_paise']!, _retailPricePaiseMeta));
    }
    if (data.containsKey('min_selling_price_paise')) {
      context.handle(_minSellingPricePaiseMeta, minSellingPricePaise.isAcceptableOrUnknown(data['min_selling_price_paise']!, _minSellingPricePaiseMeta));
    } else if (isInserting) {
      context.missing(_minSellingPricePaiseMeta);
    }
    if (data.containsKey('mrp_paise')) {
      context.handle(_mrpPaiseMeta, mrpPaise.isAcceptableOrUnknown(data['mrp_paise']!, _mrpPaiseMeta));
    }
    if (data.containsKey('tax_rate_basis_points')) {
      context.handle(_taxRateBasisPointsMeta, taxRateBasisPoints.isAcceptableOrUnknown(data['tax_rate_basis_points']!, _taxRateBasisPointsMeta));
    } else if (isInserting) {
      context.missing(_taxRateBasisPointsMeta);
    }
    if (data.containsKey('wholesale_min_qty')) {
      context.handle(_wholesaleMinQtyMeta, wholesaleMinQty.isAcceptableOrUnknown(data['wholesale_min_qty']!, _wholesaleMinQtyMeta));
    } else if (isInserting) {
      context.missing(_wholesaleMinQtyMeta);
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(_lowStockThresholdMeta, lowStockThreshold.isAcceptableOrUnknown(data['low_stock_threshold']!, _lowStockThresholdMeta));
    } else if (isInserting) {
      context.missing(_lowStockThresholdMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta, isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta, createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta, updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta, isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      productCode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}product_code'])!,
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      brandId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}brand_id']),
      subCategory: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sub_category']),
      fabric: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fabric']),
      fit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}fit']),
      sleeve: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sleeve']),
      neck: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}neck']),
      hsnCode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}hsn_code']),
      purchasePricePaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}purchase_price_paise'])!,
      wholesalePricePaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}wholesale_price_paise'])!,
      retailPricePaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}retail_price_paise']),
      minSellingPricePaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}min_selling_price_paise'])!,
      mrpPaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}mrp_paise']),
      taxRateBasisPoints: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}tax_rate_basis_points'])!,
      wholesaleMinQty: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}wholesale_min_qty'])!,
      lowStockThreshold: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}low_stock_threshold'])!,
      isActive: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      createdBy: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_by']),
      updatedBy: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_by']),
      isDeleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}deleted_at']),
    );
  }
  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}
class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String productCode;
  final int? categoryId;
  final int? brandId;
  final String? subCategory;
  final String? fabric;
  final String? fit;
  final String? sleeve;
  final String? neck;
  final String? hsnCode;
  final int purchasePricePaise;
  final int wholesalePricePaise;
  final int? retailPricePaise;
  final int minSellingPricePaise;
  final int? mrpPaise;
  final int taxRateBasisPoints;
  final int wholesaleMinQty;
  final int lowStockThreshold;
  final bool isActive;
  final String? description;
  final int createdAt;
  final int updatedAt;
  final int? createdBy;
  final int? updatedBy;
  final bool isDeleted;
  final int? deletedAt;
  const Product({required this.id, required this.name, required this.productCode, this.categoryId, this.brandId, this.subCategory, this.fabric, this.fit, this.sleeve, this.neck, this.hsnCode, required this.purchasePricePaise, required this.wholesalePricePaise, this.retailPricePaise, required this.minSellingPricePaise, this.mrpPaise, required this.taxRateBasisPoints, required this.wholesaleMinQty, required this.lowStockThreshold, required this.isActive, this.description, required this.createdAt, required this.updatedAt, this.createdBy, this.updatedBy, required this.isDeleted, this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['product_code'] = Variable<String>(productCode);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || brandId != null) {
      map['brand_id'] = Variable<int>(brandId);
    }
    if (!nullToAbsent || subCategory != null) {
      map['sub_category'] = Variable<String>(subCategory);
    }
    if (!nullToAbsent || fabric != null) {
      map['fabric'] = Variable<String>(fabric);
    }
    if (!nullToAbsent || fit != null) {
      map['fit'] = Variable<String>(fit);
    }
    if (!nullToAbsent || sleeve != null) {
      map['sleeve'] = Variable<String>(sleeve);
    }
    if (!nullToAbsent || neck != null) {
      map['neck'] = Variable<String>(neck);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['purchase_price_paise'] = Variable<int>(purchasePricePaise);
    map['wholesale_price_paise'] = Variable<int>(wholesalePricePaise);
    if (!nullToAbsent || retailPricePaise != null) {
      map['retail_price_paise'] = Variable<int>(retailPricePaise);
    }
    map['min_selling_price_paise'] = Variable<int>(minSellingPricePaise);
    if (!nullToAbsent || mrpPaise != null) {
      map['mrp_paise'] = Variable<int>(mrpPaise);
    }
    map['tax_rate_basis_points'] = Variable<int>(taxRateBasisPoints);
    map['wholesale_min_qty'] = Variable<int>(wholesaleMinQty);
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<int>(createdBy);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<int>(updatedBy);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }
  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      productCode: Value(productCode),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      brandId: brandId == null && nullToAbsent ? const Value.absent() : Value(brandId),
      subCategory: subCategory == null && nullToAbsent ? const Value.absent() : Value(subCategory),
      fabric: fabric == null && nullToAbsent ? const Value.absent() : Value(fabric),
      fit: fit == null && nullToAbsent ? const Value.absent() : Value(fit),
      sleeve: sleeve == null && nullToAbsent ? const Value.absent() : Value(sleeve),
      neck: neck == null && nullToAbsent ? const Value.absent() : Value(neck),
      hsnCode: hsnCode == null && nullToAbsent ? const Value.absent() : Value(hsnCode),
      purchasePricePaise: Value(purchasePricePaise),
      wholesalePricePaise: Value(wholesalePricePaise),
      retailPricePaise: retailPricePaise == null && nullToAbsent ? const Value.absent() : Value(retailPricePaise),
      minSellingPricePaise: Value(minSellingPricePaise),
      mrpPaise: mrpPaise == null && nullToAbsent ? const Value.absent() : Value(mrpPaise),
      taxRateBasisPoints: Value(taxRateBasisPoints),
      wholesaleMinQty: Value(wholesaleMinQty),
      lowStockThreshold: Value(lowStockThreshold),
      isActive: Value(isActive),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      createdBy: createdBy == null && nullToAbsent ? const Value.absent() : Value(createdBy),
      updatedBy: updatedBy == null && nullToAbsent ? const Value.absent() : Value(updatedBy),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
    );
  }
  factory Product.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(map['id']),
      name: serializer.fromJson<String>(map['name']),
      productCode: serializer.fromJson<String>(map['productCode']),
      categoryId: serializer.fromJson<int?>(map['categoryId']),
      brandId: serializer.fromJson<int?>(map['brandId']),
      subCategory: serializer.fromJson<String?>(map['subCategory']),
      fabric: serializer.fromJson<String?>(map['fabric']),
      fit: serializer.fromJson<String?>(map['fit']),
      sleeve: serializer.fromJson<String?>(map['sleeve']),
      neck: serializer.fromJson<String?>(map['neck']),
      hsnCode: serializer.fromJson<String?>(map['hsnCode']),
      purchasePricePaise: serializer.fromJson<int>(map['purchasePricePaise']),
      wholesalePricePaise: serializer.fromJson<int>(map['wholesalePricePaise']),
      retailPricePaise: serializer.fromJson<int?>(map['retailPricePaise']),
      minSellingPricePaise: serializer.fromJson<int>(map['minSellingPricePaise']),
      mrpPaise: serializer.fromJson<int?>(map['mrpPaise']),
      taxRateBasisPoints: serializer.fromJson<int>(map['taxRateBasisPoints']),
      wholesaleMinQty: serializer.fromJson<int>(map['wholesaleMinQty']),
      lowStockThreshold: serializer.fromJson<int>(map['lowStockThreshold']),
      isActive: serializer.fromJson<bool>(map['isActive']),
      description: serializer.fromJson<String?>(map['description']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
      createdBy: serializer.fromJson<int?>(map['createdBy']),
      updatedBy: serializer.fromJson<int?>(map['updatedBy']),
      isDeleted: serializer.fromJson<bool>(map['isDeleted']),
      deletedAt: serializer.fromJson<int?>(map['deletedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('Product(')..write('id: $id, name: $name, productCode: $productCode, categoryId: $categoryId, brandId: $brandId, subCategory: $subCategory, fabric: $fabric, fit: $fit, sleeve: $sleeve, neck: $neck, hsnCode: $hsnCode, purchasePricePaise: $purchasePricePaise, wholesalePricePaise: $wholesalePricePaise, retailPricePaise: $retailPricePaise, minSellingPricePaise: $minSellingPricePaise, mrpPaise: $mrpPaise, taxRateBasisPoints: $taxRateBasisPoints, wholesaleMinQty: $wholesaleMinQty, lowStockThreshold: $lowStockThreshold, isActive: $isActive, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, isDeleted: $isDeleted, deletedAt: $deletedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, name, productCode, categoryId, brandId, subCategory, fabric, fit, sleeve, neck, hsnCode, purchasePricePaise, wholesalePricePaise, retailPricePaise, minSellingPricePaise, mrpPaise, taxRateBasisPoints, wholesaleMinQty, lowStockThreshold, isActive, description, createdAt, updatedAt, createdBy, updatedBy, isDeleted, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Product && other.id == id && other.name == name && other.productCode == productCode && other.categoryId == categoryId && other.brandId == brandId && other.subCategory == subCategory && other.fabric == fabric && other.fit == fit && other.sleeve == sleeve && other.neck == neck && other.hsnCode == hsnCode && other.purchasePricePaise == purchasePricePaise && other.wholesalePricePaise == wholesalePricePaise && other.retailPricePaise == retailPricePaise && other.minSellingPricePaise == minSellingPricePaise && other.mrpPaise == mrpPaise && other.taxRateBasisPoints == taxRateBasisPoints && other.wholesaleMinQty == wholesaleMinQty && other.lowStockThreshold == lowStockThreshold && other.isActive == isActive && other.description == description && other.createdAt == createdAt && other.updatedAt == updatedAt && other.createdBy == createdBy && other.updatedBy == updatedBy && other.isDeleted == isDeleted && other.deletedAt == deletedAt);
  Product copyWith({int? id, String? name, String? productCode, int? categoryId, int? brandId, String? subCategory, String? fabric, String? fit, String? sleeve, String? neck, String? hsnCode, int? purchasePricePaise, int? wholesalePricePaise, int? retailPricePaise, int? minSellingPricePaise, int? mrpPaise, int? taxRateBasisPoints, int? wholesaleMinQty, int? lowStockThreshold, bool? isActive, String? description, int? createdAt, int? updatedAt, int? createdBy, int? updatedBy, bool? isDeleted, int? deletedAt}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      productCode: productCode ?? this.productCode,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      subCategory: subCategory ?? this.subCategory,
      fabric: fabric ?? this.fabric,
      fit: fit ?? this.fit,
      sleeve: sleeve ?? this.sleeve,
      neck: neck ?? this.neck,
      hsnCode: hsnCode ?? this.hsnCode,
      purchasePricePaise: purchasePricePaise ?? this.purchasePricePaise,
      wholesalePricePaise: wholesalePricePaise ?? this.wholesalePricePaise,
      retailPricePaise: retailPricePaise ?? this.retailPricePaise,
      minSellingPricePaise: minSellingPricePaise ?? this.minSellingPricePaise,
      mrpPaise: mrpPaise ?? this.mrpPaise,
      taxRateBasisPoints: taxRateBasisPoints ?? this.taxRateBasisPoints,
      wholesaleMinQty: wholesaleMinQty ?? this.wholesaleMinQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> productCode;
  final Value<int?> categoryId;
  final Value<int?> brandId;
  final Value<String?> subCategory;
  final Value<String?> fabric;
  final Value<String?> fit;
  final Value<String?> sleeve;
  final Value<String?> neck;
  final Value<String?> hsnCode;
  final Value<int> purchasePricePaise;
  final Value<int> wholesalePricePaise;
  final Value<int?> retailPricePaise;
  final Value<int> minSellingPricePaise;
  final Value<int?> mrpPaise;
  final Value<int> taxRateBasisPoints;
  final Value<int> wholesaleMinQty;
  final Value<int> lowStockThreshold;
  final Value<bool> isActive;
  final Value<String?> description;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> createdBy;
  final Value<int?> updatedBy;
  final Value<bool> isDeleted;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.productCode = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.fabric = const Value.absent(),
    this.fit = const Value.absent(),
    this.sleeve = const Value.absent(),
    this.neck = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.purchasePricePaise = const Value.absent(),
    this.wholesalePricePaise = const Value.absent(),
    this.retailPricePaise = const Value.absent(),
    this.minSellingPricePaise = const Value.absent(),
    this.mrpPaise = const Value.absent(),
    this.taxRateBasisPoints = const Value.absent(),
    this.wholesaleMinQty = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String productCode,
    this.categoryId = const Value.absent(),
    this.brandId = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.fabric = const Value.absent(),
    this.fit = const Value.absent(),
    this.sleeve = const Value.absent(),
    this.neck = const Value.absent(),
    this.hsnCode = const Value.absent(),
    required int purchasePricePaise,
    required int wholesalePricePaise,
    this.retailPricePaise = const Value.absent(),
    required int minSellingPricePaise,
    this.mrpPaise = const Value.absent(),
    required int taxRateBasisPoints,
    required int wholesaleMinQty,
    required int lowStockThreshold,
    required bool isActive,
    this.description = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.createdBy = const Value.absent(),
    this.updatedBy = const Value.absent(),
    required bool isDeleted,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name), productCode = Value(productCode), purchasePricePaise = Value(purchasePricePaise), wholesalePricePaise = Value(wholesalePricePaise), minSellingPricePaise = Value(minSellingPricePaise), taxRateBasisPoints = Value(taxRateBasisPoints), wholesaleMinQty = Value(wholesaleMinQty), lowStockThreshold = Value(lowStockThreshold), isActive = Value(isActive), createdAt = Value(createdAt), updatedAt = Value(updatedAt), isDeleted = Value(isDeleted);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? productCode,
    Expression<int>? categoryId,
    Expression<int>? brandId,
    Expression<String>? subCategory,
    Expression<String>? fabric,
    Expression<String>? fit,
    Expression<String>? sleeve,
    Expression<String>? neck,
    Expression<String>? hsnCode,
    Expression<int>? purchasePricePaise,
    Expression<int>? wholesalePricePaise,
    Expression<int>? retailPricePaise,
    Expression<int>? minSellingPricePaise,
    Expression<int>? mrpPaise,
    Expression<int>? taxRateBasisPoints,
    Expression<int>? wholesaleMinQty,
    Expression<int>? lowStockThreshold,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? createdBy,
    Expression<int>? updatedBy,
    Expression<bool>? isDeleted,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (productCode != null) 'product_code': productCode,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (subCategory != null) 'sub_category': subCategory,
      if (fabric != null) 'fabric': fabric,
      if (fit != null) 'fit': fit,
      if (sleeve != null) 'sleeve': sleeve,
      if (neck != null) 'neck': neck,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (purchasePricePaise != null) 'purchase_price_paise': purchasePricePaise,
      if (wholesalePricePaise != null) 'wholesale_price_paise': wholesalePricePaise,
      if (retailPricePaise != null) 'retail_price_paise': retailPricePaise,
      if (minSellingPricePaise != null) 'min_selling_price_paise': minSellingPricePaise,
      if (mrpPaise != null) 'mrp_paise': mrpPaise,
      if (taxRateBasisPoints != null) 'tax_rate_basis_points': taxRateBasisPoints,
      if (wholesaleMinQty != null) 'wholesale_min_qty': wholesaleMinQty,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? productCode,
    Value<int?>? categoryId,
    Value<int?>? brandId,
    Value<String?>? subCategory,
    Value<String?>? fabric,
    Value<String?>? fit,
    Value<String?>? sleeve,
    Value<String?>? neck,
    Value<String?>? hsnCode,
    Value<int>? purchasePricePaise,
    Value<int>? wholesalePricePaise,
    Value<int?>? retailPricePaise,
    Value<int>? minSellingPricePaise,
    Value<int?>? mrpPaise,
    Value<int>? taxRateBasisPoints,
    Value<int>? wholesaleMinQty,
    Value<int>? lowStockThreshold,
    Value<bool>? isActive,
    Value<String?>? description,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? createdBy,
    Value<int?>? updatedBy,
    Value<bool>? isDeleted,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      productCode: productCode ?? this.productCode,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      subCategory: subCategory ?? this.subCategory,
      fabric: fabric ?? this.fabric,
      fit: fit ?? this.fit,
      sleeve: sleeve ?? this.sleeve,
      neck: neck ?? this.neck,
      hsnCode: hsnCode ?? this.hsnCode,
      purchasePricePaise: purchasePricePaise ?? this.purchasePricePaise,
      wholesalePricePaise: wholesalePricePaise ?? this.wholesalePricePaise,
      retailPricePaise: retailPricePaise ?? this.retailPricePaise,
      minSellingPricePaise: minSellingPricePaise ?? this.minSellingPricePaise,
      mrpPaise: mrpPaise ?? this.mrpPaise,
      taxRateBasisPoints: taxRateBasisPoints ?? this.taxRateBasisPoints,
      wholesaleMinQty: wholesaleMinQty ?? this.wholesaleMinQty,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<int>(brandId.value);
    }
    if (subCategory.present) {
      map['sub_category'] = Variable<String>(subCategory.value);
    }
    if (fabric.present) {
      map['fabric'] = Variable<String>(fabric.value);
    }
    if (fit.present) {
      map['fit'] = Variable<String>(fit.value);
    }
    if (sleeve.present) {
      map['sleeve'] = Variable<String>(sleeve.value);
    }
    if (neck.present) {
      map['neck'] = Variable<String>(neck.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (purchasePricePaise.present) {
      map['purchase_price_paise'] = Variable<int>(purchasePricePaise.value);
    }
    if (wholesalePricePaise.present) {
      map['wholesale_price_paise'] = Variable<int>(wholesalePricePaise.value);
    }
    if (retailPricePaise.present) {
      map['retail_price_paise'] = Variable<int>(retailPricePaise.value);
    }
    if (minSellingPricePaise.present) {
      map['min_selling_price_paise'] = Variable<int>(minSellingPricePaise.value);
    }
    if (mrpPaise.present) {
      map['mrp_paise'] = Variable<int>(mrpPaise.value);
    }
    if (taxRateBasisPoints.present) {
      map['tax_rate_basis_points'] = Variable<int>(taxRateBasisPoints.value);
    }
    if (wholesaleMinQty.present) {
      map['wholesale_min_qty'] = Variable<int>(wholesaleMinQty.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<int>(updatedBy.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('productCode: $productCode, ')
          ..write('categoryId: $categoryId, ')
          ..write('brandId: $brandId, ')
          ..write('subCategory: $subCategory, ')
          ..write('fabric: $fabric, ')
          ..write('fit: $fit, ')
          ..write('sleeve: $sleeve, ')
          ..write('neck: $neck, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('purchasePricePaise: $purchasePricePaise, ')
          ..write('wholesalePricePaise: $wholesalePricePaise, ')
          ..write('retailPricePaise: $retailPricePaise, ')
          ..write('minSellingPricePaise: $minSellingPricePaise, ')
          ..write('mrpPaise: $mrpPaise, ')
          ..write('taxRateBasisPoints: $taxRateBasisPoints, ')
          ..write('wholesaleMinQty: $wholesaleMinQty, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductVariantsTable extends ProductVariants
    with TableInfo<$ProductVariantsTable, ProductVariant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta = VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>('product_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sizeIdMeta = VerificationMeta('sizeId');
  @override
  late final GeneratedColumn<int> sizeId = GeneratedColumn<int>('size_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorIdMeta = VerificationMeta('colorId');
  @override
  late final GeneratedColumn<int> colorId = GeneratedColumn<int>('color_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta = VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>('barcode', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockQuantityMeta = VerificationMeta('stockQuantity');
  @override
  late final GeneratedColumn<int> stockQuantity = GeneratedColumn<int>('stock_quantity', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, productId, sizeId, colorId, barcode, stockQuantity, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_variants';
  @override
  VerificationContext validateIntegrity(Insertable<ProductVariant> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta, productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('size_id')) {
      context.handle(_sizeIdMeta, sizeId.isAcceptableOrUnknown(data['size_id']!, _sizeIdMeta));
    } else if (isInserting) {
      context.missing(_sizeIdMeta);
    }
    if (data.containsKey('color_id')) {
      context.handle(_colorIdMeta, colorId.isAcceptableOrUnknown(data['color_id']!, _colorIdMeta));
    } else if (isInserting) {
      context.missing(_colorIdMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta, barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(_stockQuantityMeta, stockQuantity.isAcceptableOrUnknown(data['stock_quantity']!, _stockQuantityMeta));
    } else if (isInserting) {
      context.missing(_stockQuantityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductVariant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductVariant(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      sizeId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}size_id'])!,
      colorId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}color_id'])!,
      barcode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
      stockQuantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}stock_quantity'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $ProductVariantsTable createAlias(String alias) {
    return $ProductVariantsTable(attachedDatabase, alias);
  }
}
class ProductVariant extends DataClass implements Insertable<ProductVariant> {
  final int id;
  final int productId;
  final int sizeId;
  final int colorId;
  final String barcode;
  final int stockQuantity;
  final int createdAt;
  final int updatedAt;
  const ProductVariant({required this.id, required this.productId, required this.sizeId, required this.colorId, required this.barcode, required this.stockQuantity, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['size_id'] = Variable<int>(sizeId);
    map['color_id'] = Variable<int>(colorId);
    map['barcode'] = Variable<String>(barcode);
    map['stock_quantity'] = Variable<int>(stockQuantity);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  ProductVariantsCompanion toCompanion(bool nullToAbsent) {
    return ProductVariantsCompanion(
      id: Value(id),
      productId: Value(productId),
      sizeId: Value(sizeId),
      colorId: Value(colorId),
      barcode: Value(barcode),
      stockQuantity: Value(stockQuantity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory ProductVariant.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductVariant(
      id: serializer.fromJson<int>(map['id']),
      productId: serializer.fromJson<int>(map['productId']),
      sizeId: serializer.fromJson<int>(map['sizeId']),
      colorId: serializer.fromJson<int>(map['colorId']),
      barcode: serializer.fromJson<String>(map['barcode']),
      stockQuantity: serializer.fromJson<int>(map['stockQuantity']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('ProductVariant(')..write('id: $id, productId: $productId, sizeId: $sizeId, colorId: $colorId, barcode: $barcode, stockQuantity: $stockQuantity, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, productId, sizeId, colorId, barcode, stockQuantity, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductVariant && other.id == id && other.productId == productId && other.sizeId == sizeId && other.colorId == colorId && other.barcode == barcode && other.stockQuantity == stockQuantity && other.createdAt == createdAt && other.updatedAt == updatedAt);
  ProductVariant copyWith({int? id, int? productId, int? sizeId, int? colorId, String? barcode, int? stockQuantity, int? createdAt, int? updatedAt}) {
    return ProductVariant(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sizeId: sizeId ?? this.sizeId,
      colorId: colorId ?? this.colorId,
      barcode: barcode ?? this.barcode,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class ProductVariantsCompanion extends UpdateCompanion<ProductVariant> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> sizeId;
  final Value<int> colorId;
  final Value<String> barcode;
  final Value<int> stockQuantity;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductVariantsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.sizeId = const Value.absent(),
    this.colorId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductVariantsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int sizeId,
    required int colorId,
    required String barcode,
    required int stockQuantity,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId), sizeId = Value(sizeId), colorId = Value(colorId), barcode = Value(barcode), stockQuantity = Value(stockQuantity), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<ProductVariant> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? sizeId,
    Expression<int>? colorId,
    Expression<String>? barcode,
    Expression<int>? stockQuantity,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (sizeId != null) 'size_id': sizeId,
      if (colorId != null) 'color_id': colorId,
      if (barcode != null) 'barcode': barcode,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductVariantsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? sizeId,
    Value<int>? colorId,
    Value<String>? barcode,
    Value<int>? stockQuantity,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductVariantsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sizeId: sizeId ?? this.sizeId,
      colorId: colorId ?? this.colorId,
      barcode: barcode ?? this.barcode,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (sizeId.present) {
      map['size_id'] = Variable<int>(sizeId.value);
    }
    if (colorId.present) {
      map['color_id'] = Variable<int>(colorId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<int>(stockQuantity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductVariantsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('sizeId: $sizeId, ')
          ..write('colorId: $colorId, ')
          ..write('barcode: $barcode, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceTiersTable extends PriceTiers
    with TableInfo<$PriceTiersTable, PriceTier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceTiersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta = VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>('product_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minQuantityMeta = VerificationMeta('minQuantity');
  @override
  late final GeneratedColumn<int> minQuantity = GeneratedColumn<int>('min_quantity', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricePaiseMeta = VerificationMeta('pricePaise');
  @override
  late final GeneratedColumn<int> pricePaise = GeneratedColumn<int>('price_paise', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, productId, minQuantity, pricePaise, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_tiers';
  @override
  VerificationContext validateIntegrity(Insertable<PriceTier> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta, productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('min_quantity')) {
      context.handle(_minQuantityMeta, minQuantity.isAcceptableOrUnknown(data['min_quantity']!, _minQuantityMeta));
    } else if (isInserting) {
      context.missing(_minQuantityMeta);
    }
    if (data.containsKey('price_paise')) {
      context.handle(_pricePaiseMeta, pricePaise.isAcceptableOrUnknown(data['price_paise']!, _pricePaiseMeta));
    } else if (isInserting) {
      context.missing(_pricePaiseMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceTier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceTier(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      minQuantity: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}min_quantity'])!,
      pricePaise: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}price_paise'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $PriceTiersTable createAlias(String alias) {
    return $PriceTiersTable(attachedDatabase, alias);
  }
}
class PriceTier extends DataClass implements Insertable<PriceTier> {
  final int id;
  final int productId;
  final int minQuantity;
  final int pricePaise;
  final int createdAt;
  final int updatedAt;
  const PriceTier({required this.id, required this.productId, required this.minQuantity, required this.pricePaise, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['min_quantity'] = Variable<int>(minQuantity);
    map['price_paise'] = Variable<int>(pricePaise);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  PriceTiersCompanion toCompanion(bool nullToAbsent) {
    return PriceTiersCompanion(
      id: Value(id),
      productId: Value(productId),
      minQuantity: Value(minQuantity),
      pricePaise: Value(pricePaise),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory PriceTier.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceTier(
      id: serializer.fromJson<int>(map['id']),
      productId: serializer.fromJson<int>(map['productId']),
      minQuantity: serializer.fromJson<int>(map['minQuantity']),
      pricePaise: serializer.fromJson<int>(map['pricePaise']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('PriceTier(')..write('id: $id, productId: $productId, minQuantity: $minQuantity, pricePaise: $pricePaise, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, productId, minQuantity, pricePaise, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is PriceTier && other.id == id && other.productId == productId && other.minQuantity == minQuantity && other.pricePaise == pricePaise && other.createdAt == createdAt && other.updatedAt == updatedAt);
  PriceTier copyWith({int? id, int? productId, int? minQuantity, int? pricePaise, int? createdAt, int? updatedAt}) {
    return PriceTier(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      minQuantity: minQuantity ?? this.minQuantity,
      pricePaise: pricePaise ?? this.pricePaise,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class PriceTiersCompanion extends UpdateCompanion<PriceTier> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> minQuantity;
  final Value<int> pricePaise;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PriceTiersCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.minQuantity = const Value.absent(),
    this.pricePaise = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceTiersCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int minQuantity,
    required int pricePaise,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId), minQuantity = Value(minQuantity), pricePaise = Value(pricePaise), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<PriceTier> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? minQuantity,
    Expression<int>? pricePaise,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (minQuantity != null) 'min_quantity': minQuantity,
      if (pricePaise != null) 'price_paise': pricePaise,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  PriceTiersCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<int>? minQuantity,
    Value<int>? pricePaise,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PriceTiersCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      minQuantity: minQuantity ?? this.minQuantity,
      pricePaise: pricePaise ?? this.pricePaise,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (minQuantity.present) {
      map['min_quantity'] = Variable<int>(minQuantity.value);
    }
    if (pricePaise.present) {
      map['price_paise'] = Variable<int>(pricePaise.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('PriceTiersCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('minQuantity: $minQuantity, ')
          ..write('pricePaise: $pricePaise, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductSetsTable extends ProductSets
    with TableInfo<$ProductSetsTable, ProductSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta = VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>('product_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setTypeMeta = VerificationMeta('setType');
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>('set_type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, productId, name, setType, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_sets';
  @override
  VerificationContext validateIntegrity(Insertable<ProductSet> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta, productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(_setTypeMeta, setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta));
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSet(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      setType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}set_type'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $ProductSetsTable createAlias(String alias) {
    return $ProductSetsTable(attachedDatabase, alias);
  }
}
class ProductSet extends DataClass implements Insertable<ProductSet> {
  final int id;
  final int productId;
  final String name;
  final String setType;
  final int createdAt;
  final int updatedAt;
  const ProductSet({required this.id, required this.productId, required this.name, required this.setType, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['name'] = Variable<String>(name);
    map['set_type'] = Variable<String>(setType);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  ProductSetsCompanion toCompanion(bool nullToAbsent) {
    return ProductSetsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(name),
      setType: Value(setType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory ProductSet.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSet(
      id: serializer.fromJson<int>(map['id']),
      productId: serializer.fromJson<int>(map['productId']),
      name: serializer.fromJson<String>(map['name']),
      setType: serializer.fromJson<String>(map['setType']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('ProductSet(')..write('id: $id, productId: $productId, name: $name, setType: $setType, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, productId, name, setType, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductSet && other.id == id && other.productId == productId && other.name == name && other.setType == setType && other.createdAt == createdAt && other.updatedAt == updatedAt);
  ProductSet copyWith({int? id, int? productId, String? name, String? setType, int? createdAt, int? updatedAt}) {
    return ProductSet(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      setType: setType ?? this.setType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class ProductSetsCompanion extends UpdateCompanion<ProductSet> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> name;
  final Value<String> setType;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductSetsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.setType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSetsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String name,
    required String setType,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : productId = Value(productId), name = Value(name), setType = Value(setType), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<ProductSet> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? name,
    Expression<String>? setType,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (setType != null) 'set_type': setType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? name,
    Value<String>? setType,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductSetsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      setType: setType ?? this.setType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductSetsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('setType: $setType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductSetItemsTable extends ProductSetItems
    with TableInfo<$ProductSetItemsTable, ProductSetItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductSetItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _setIdMeta = VerificationMeta('setId');
  @override
  late final GeneratedColumn<int> setId = GeneratedColumn<int>('set_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sizeIdMeta = VerificationMeta('sizeId');
  @override
  late final GeneratedColumn<int> sizeId = GeneratedColumn<int>('size_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorIdMeta = VerificationMeta('colorId');
  @override
  late final GeneratedColumn<int> colorId = GeneratedColumn<int>('color_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _quantityPerSetMeta = VerificationMeta('quantityPerSet');
  @override
  late final GeneratedColumn<int> quantityPerSet = GeneratedColumn<int>('quantity_per_set', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta = VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>('updated_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, setId, sizeId, colorId, quantityPerSet, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_set_items';
  @override
  VerificationContext validateIntegrity(Insertable<ProductSetItem> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('set_id')) {
      context.handle(_setIdMeta, setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta));
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('size_id')) {
      context.handle(_sizeIdMeta, sizeId.isAcceptableOrUnknown(data['size_id']!, _sizeIdMeta));
    } else if (isInserting) {
      context.missing(_sizeIdMeta);
    }
    if (data.containsKey('color_id')) {
      context.handle(_colorIdMeta, colorId.isAcceptableOrUnknown(data['color_id']!, _colorIdMeta));
    }
    if (data.containsKey('quantity_per_set')) {
      context.handle(_quantityPerSetMeta, quantityPerSet.isAcceptableOrUnknown(data['quantity_per_set']!, _quantityPerSetMeta));
    } else if (isInserting) {
      context.missing(_quantityPerSetMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductSetItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductSetItem(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      setId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}set_id'])!,
      sizeId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}size_id'])!,
      colorId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}color_id']),
      quantityPerSet: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity_per_set'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  $ProductSetItemsTable createAlias(String alias) {
    return $ProductSetItemsTable(attachedDatabase, alias);
  }
}
class ProductSetItem extends DataClass implements Insertable<ProductSetItem> {
  final int id;
  final int setId;
  final int sizeId;
  final int? colorId;
  final int quantityPerSet;
  final int createdAt;
  final int updatedAt;
  const ProductSetItem({required this.id, required this.setId, required this.sizeId, this.colorId, required this.quantityPerSet, required this.createdAt, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['set_id'] = Variable<int>(setId);
    map['size_id'] = Variable<int>(sizeId);
    if (!nullToAbsent || colorId != null) {
      map['color_id'] = Variable<int>(colorId);
    }
    map['quantity_per_set'] = Variable<int>(quantityPerSet);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }
  ProductSetItemsCompanion toCompanion(bool nullToAbsent) {
    return ProductSetItemsCompanion(
      id: Value(id),
      setId: Value(setId),
      sizeId: Value(sizeId),
      colorId: colorId == null && nullToAbsent ? const Value.absent() : Value(colorId),
      quantityPerSet: Value(quantityPerSet),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
  factory ProductSetItem.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductSetItem(
      id: serializer.fromJson<int>(map['id']),
      setId: serializer.fromJson<int>(map['setId']),
      sizeId: serializer.fromJson<int>(map['sizeId']),
      colorId: serializer.fromJson<int?>(map['colorId']),
      quantityPerSet: serializer.fromJson<int>(map['quantityPerSet']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
      updatedAt: serializer.fromJson<int>(map['updatedAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('ProductSetItem(')..write('id: $id, setId: $setId, sizeId: $sizeId, colorId: $colorId, quantityPerSet: $quantityPerSet, createdAt: $createdAt, updatedAt: $updatedAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, setId, sizeId, colorId, quantityPerSet, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductSetItem && other.id == id && other.setId == setId && other.sizeId == sizeId && other.colorId == colorId && other.quantityPerSet == quantityPerSet && other.createdAt == createdAt && other.updatedAt == updatedAt);
  ProductSetItem copyWith({int? id, int? setId, int? sizeId, int? colorId, int? quantityPerSet, int? createdAt, int? updatedAt}) {
    return ProductSetItem(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      sizeId: sizeId ?? this.sizeId,
      colorId: colorId ?? this.colorId,
      quantityPerSet: quantityPerSet ?? this.quantityPerSet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
class ProductSetItemsCompanion extends UpdateCompanion<ProductSetItem> {
  final Value<int> id;
  final Value<int> setId;
  final Value<int> sizeId;
  final Value<int?> colorId;
  final Value<int> quantityPerSet;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProductSetItemsCompanion({
    this.id = const Value.absent(),
    this.setId = const Value.absent(),
    this.sizeId = const Value.absent(),
    this.colorId = const Value.absent(),
    this.quantityPerSet = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductSetItemsCompanion.insert({
    this.id = const Value.absent(),
    required int setId,
    required int sizeId,
    this.colorId = const Value.absent(),
    required int quantityPerSet,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : setId = Value(setId), sizeId = Value(sizeId), quantityPerSet = Value(quantityPerSet), createdAt = Value(createdAt), updatedAt = Value(updatedAt);
  static Insertable<ProductSetItem> custom({
    Expression<int>? id,
    Expression<int>? setId,
    Expression<int>? sizeId,
    Expression<int>? colorId,
    Expression<int>? quantityPerSet,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setId != null) 'set_id': setId,
      if (sizeId != null) 'size_id': sizeId,
      if (colorId != null) 'color_id': colorId,
      if (quantityPerSet != null) 'quantity_per_set': quantityPerSet,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  ProductSetItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? setId,
    Value<int>? sizeId,
    Value<int?>? colorId,
    Value<int>? quantityPerSet,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProductSetItemsCompanion(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      sizeId: sizeId ?? this.sizeId,
      colorId: colorId ?? this.colorId,
      quantityPerSet: quantityPerSet ?? this.quantityPerSet,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<int>(setId.value);
    }
    if (sizeId.present) {
      map['size_id'] = Variable<int>(sizeId.value);
    }
    if (colorId.present) {
      map['color_id'] = Variable<int>(colorId.value);
    }
    if (quantityPerSet.present) {
      map['quantity_per_set'] = Variable<int>(quantityPerSet.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('ProductSetItemsCompanion(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('sizeId: $sizeId, ')
          ..write('colorId: $colorId, ')
          ..write('quantityPerSet: $quantityPerSet, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _variantIdMeta = VerificationMeta('variantId');
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>('variant_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _movementTypeMeta = VerificationMeta('movementType');
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>('movement_type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityChangeMeta = VerificationMeta('quantityChange');
  @override
  late final GeneratedColumn<int> quantityChange = GeneratedColumn<int>('quantity_change', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _balanceAfterMeta = VerificationMeta('balanceAfter');
  @override
  late final GeneratedColumn<int> balanceAfter = GeneratedColumn<int>('balance_after', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>('reason', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>('user_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, variantId, movementType, quantityChange, balanceAfter, reason, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<StockMovement> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta, variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('movement_type')) {
      context.handle(_movementTypeMeta, movementType.isAcceptableOrUnknown(data['movement_type']!, _movementTypeMeta));
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('quantity_change')) {
      context.handle(_quantityChangeMeta, quantityChange.isAcceptableOrUnknown(data['quantity_change']!, _quantityChangeMeta));
    } else if (isInserting) {
      context.missing(_quantityChangeMeta);
    }
    if (data.containsKey('balance_after')) {
      context.handle(_balanceAfterMeta, balanceAfter.isAcceptableOrUnknown(data['balance_after']!, _balanceAfterMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta, reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      variantId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}variant_id'])!,
      movementType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}movement_type'])!,
      quantityChange: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity_change'])!,
      balanceAfter: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}balance_after'])!,
      reason: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reason']),
      userId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }
  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}
class StockMovement extends DataClass implements Insertable<StockMovement> {
  final int id;
  final int variantId;
  final String movementType;
  final int quantityChange;
  final int balanceAfter;
  final String? reason;
  final int? userId;
  final int createdAt;
  const StockMovement({required this.id, required this.variantId, required this.movementType, required this.quantityChange, required this.balanceAfter, this.reason, this.userId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['variant_id'] = Variable<int>(variantId);
    map['movement_type'] = Variable<String>(movementType);
    map['quantity_change'] = Variable<int>(quantityChange);
    map['balance_after'] = Variable<int>(balanceAfter);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }
  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      variantId: Value(variantId),
      movementType: Value(movementType),
      quantityChange: Value(quantityChange),
      balanceAfter: Value(balanceAfter),
      reason: reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      userId: userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
    );
  }
  factory StockMovement.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<int>(map['id']),
      variantId: serializer.fromJson<int>(map['variantId']),
      movementType: serializer.fromJson<String>(map['movementType']),
      quantityChange: serializer.fromJson<int>(map['quantityChange']),
      balanceAfter: serializer.fromJson<int>(map['balanceAfter']),
      reason: serializer.fromJson<String?>(map['reason']),
      userId: serializer.fromJson<int?>(map['userId']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('StockMovement(')..write('id: $id, variantId: $variantId, movementType: $movementType, quantityChange: $quantityChange, balanceAfter: $balanceAfter, reason: $reason, userId: $userId, createdAt: $createdAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, variantId, movementType, quantityChange, balanceAfter, reason, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StockMovement && other.id == id && other.variantId == variantId && other.movementType == movementType && other.quantityChange == quantityChange && other.balanceAfter == balanceAfter && other.reason == reason && other.userId == userId && other.createdAt == createdAt);
  StockMovement copyWith({int? id, int? variantId, String? movementType, int? quantityChange, int? balanceAfter, String? reason, int? userId, int? createdAt}) {
    return StockMovement(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      movementType: movementType ?? this.movementType,
      quantityChange: quantityChange ?? this.quantityChange,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<int> id;
  final Value<int> variantId;
  final Value<String> movementType;
  final Value<int> quantityChange;
  final Value<int> balanceAfter;
  final Value<String?> reason;
  final Value<int?> userId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.quantityChange = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.reason = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int variantId,
    required String movementType,
    required int quantityChange,
    required int balanceAfter,
    this.reason = const Value.absent(),
    this.userId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : variantId = Value(variantId), movementType = Value(movementType), quantityChange = Value(quantityChange), balanceAfter = Value(balanceAfter), createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<int>? id,
    Expression<int>? variantId,
    Expression<String>? movementType,
    Expression<int>? quantityChange,
    Expression<int>? balanceAfter,
    Expression<String>? reason,
    Expression<int>? userId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variantId != null) 'variant_id': variantId,
      if (movementType != null) 'movement_type': movementType,
      if (quantityChange != null) 'quantity_change': quantityChange,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (reason != null) 'reason': reason,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  StockMovementsCompanion copyWith({
    Value<int>? id,
    Value<int>? variantId,
    Value<String>? movementType,
    Value<int>? quantityChange,
    Value<int>? balanceAfter,
    Value<String?>? reason,
    Value<int?>? userId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      movementType: movementType ?? this.movementType,
      quantityChange: quantityChange ?? this.quantityChange,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (quantityChange.present) {
      map['quantity_change'] = Variable<int>(quantityChange.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<int>(balanceAfter.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('movementType: $movementType, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('reason: $reason, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockAdjustmentsTable extends StockAdjustments
    with TableInfo<$StockAdjustmentsTable, StockAdjustment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAdjustmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _variantIdMeta = VerificationMeta('variantId');
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>('variant_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityChangeMeta = VerificationMeta('quantityChange');
  @override
  late final GeneratedColumn<int> quantityChange = GeneratedColumn<int>('quantity_change', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>('reason', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>('user_id', aliasedName, true, type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>('created_at', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, variantId, quantityChange, reason, userId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_adjustments';
  @override
  VerificationContext validateIntegrity(Insertable<StockAdjustment> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('variant_id')) {
      context.handle(_variantIdMeta, variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta));
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('quantity_change')) {
      context.handle(_quantityChangeMeta, quantityChange.isAcceptableOrUnknown(data['quantity_change']!, _quantityChangeMeta));
    } else if (isInserting) {
      context.missing(_quantityChangeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta, reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAdjustment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAdjustment(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      variantId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}variant_id'])!,
      quantityChange: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}quantity_change'])!,
      reason: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }
  @override
  $StockAdjustmentsTable createAlias(String alias) {
    return $StockAdjustmentsTable(attachedDatabase, alias);
  }
}
class StockAdjustment extends DataClass implements Insertable<StockAdjustment> {
  final int id;
  final int variantId;
  final int quantityChange;
  final String reason;
  final int? userId;
  final int createdAt;
  const StockAdjustment({required this.id, required this.variantId, required this.quantityChange, required this.reason, this.userId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['variant_id'] = Variable<int>(variantId);
    map['quantity_change'] = Variable<int>(quantityChange);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }
  StockAdjustmentsCompanion toCompanion(bool nullToAbsent) {
    return StockAdjustmentsCompanion(
      id: Value(id),
      variantId: Value(variantId),
      quantityChange: Value(quantityChange),
      reason: Value(reason),
      userId: userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
    );
  }
  factory StockAdjustment.fromMap(Map<String, dynamic> map, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAdjustment(
      id: serializer.fromJson<int>(map['id']),
      variantId: serializer.fromJson<int>(map['variantId']),
      quantityChange: serializer.fromJson<int>(map['quantityChange']),
      reason: serializer.fromJson<String>(map['reason']),
      userId: serializer.fromJson<int?>(map['userId']),
      createdAt: serializer.fromJson<int>(map['createdAt']),
    );
  }
  @override
  String toString() {
    return (StringBuffer('StockAdjustment(')..write('id: $id, variantId: $variantId, quantityChange: $quantityChange, reason: $reason, userId: $userId, createdAt: $createdAt')..write(')')).toString();
  }
  @override
  int get hashCode => Object.hash(id, variantId, quantityChange, reason, userId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StockAdjustment && other.id == id && other.variantId == variantId && other.quantityChange == quantityChange && other.reason == reason && other.userId == userId && other.createdAt == createdAt);
  StockAdjustment copyWith({int? id, int? variantId, int? quantityChange, String? reason, int? userId, int? createdAt}) {
    return StockAdjustment(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      quantityChange: quantityChange ?? this.quantityChange,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
class StockAdjustmentsCompanion extends UpdateCompanion<StockAdjustment> {
  final Value<int> id;
  final Value<int> variantId;
  final Value<int> quantityChange;
  final Value<String> reason;
  final Value<int?> userId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StockAdjustmentsCompanion({
    this.id = const Value.absent(),
    this.variantId = const Value.absent(),
    this.quantityChange = const Value.absent(),
    this.reason = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockAdjustmentsCompanion.insert({
    this.id = const Value.absent(),
    required int variantId,
    required int quantityChange,
    required String reason,
    this.userId = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : variantId = Value(variantId), quantityChange = Value(quantityChange), reason = Value(reason), createdAt = Value(createdAt);
  static Insertable<StockAdjustment> custom({
    Expression<int>? id,
    Expression<int>? variantId,
    Expression<int>? quantityChange,
    Expression<String>? reason,
    Expression<int>? userId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variantId != null) 'variant_id': variantId,
      if (quantityChange != null) 'quantity_change': quantityChange,
      if (reason != null) 'reason': reason,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }
  StockAdjustmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? variantId,
    Value<int>? quantityChange,
    Value<String>? reason,
    Value<int?>? userId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StockAdjustmentsCompanion(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      quantityChange: quantityChange ?? this.quantityChange,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
    }
    if (quantityChange.present) {
      map['quantity_change'] = Variable<int>(quantityChange.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }
  @override
  String toString() {
    return (StringBuffer('StockAdjustmentsCompanion(')
          ..write('id: $id, ')
          ..write('variantId: $variantId, ')
          ..write('quantityChange: $quantityChange, ')
          ..write('reason: $reason, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {

  _$AppDatabase(QueryExecutor e) : super(e);

  late final $AppSettingsTable appSettings = $AppSettingsTable(this);

  late final $UsersTable users = $UsersTable(this);

  late final $RolesTable roles = $RolesTable(this);

  late final $PermissionsTable permissions = $PermissionsTable(this);

  late final $RolePermissionsTable rolePermissions = $RolePermissionsTable(this);

  late final $UserPermissionsTable userPermissions = $UserPermissionsTable(this);

  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);

  late final $NumberSequencesTable numberSequences = $NumberSequencesTable(this);

  late final $CategoriesTable categories = $CategoriesTable(this);

  late final $BrandsTable brands = $BrandsTable(this);

  late final $ProductSizesTable productSizes = $ProductSizesTable(this);

  late final $ProductColorsTable productColors = $ProductColorsTable(this);

  late final $TaxRatesTable taxRates = $TaxRatesTable(this);

  late final $ProductsTable products = $ProductsTable(this);

  late final $ProductVariantsTable productVariants = $ProductVariantsTable(this);

  late final $PriceTiersTable priceTiers = $PriceTiersTable(this);

  late final $ProductSetsTable productSets = $ProductSetsTable(this);

  late final $ProductSetItemsTable productSetItems = $ProductSetItemsTable(this);

  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);

  late final $StockAdjustmentsTable stockAdjustments = $StockAdjustmentsTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appSettings, users, roles, permissions, rolePermissions, userPermissions, auditLogs, numberSequences, categories, brands, productSizes, productColors, taxRates, products, productVariants, priceTiers, productSets, productSetItems, stockMovements, stockAdjustments];

}

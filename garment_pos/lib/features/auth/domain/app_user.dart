/// Immutable view of a user account for UI and permission checks.
/// Built from the `users` + `roles` tables; never carries hashes.
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.roleId,
    required this.roleName,
    required this.isActive,
    required this.hasPin,
  });

  final int id;
  final String username;
  final String displayName;
  final int roleId;

  /// Machine role name: admin / manager / salesman.
  final String roleName;

  final bool isActive;
  final bool hasPin;

  bool get isAdmin => roleName == 'admin';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          other.id == id &&
          other.username == username &&
          other.displayName == displayName &&
          other.roleId == roleId &&
          other.roleName == roleName &&
          other.isActive == isActive &&
          other.hasPin == hasPin);

  @override
  int get hashCode => Object.hash(
    id,
    username,
    displayName,
    roleId,
    roleName,
    isActive,
    hasPin,
  );
}

/// Permission keys, role names and the default permission matrix.
///
/// Every sensitive capability in Garment POS is a permission key.
/// UI code asks "can the current user do X?" through these keys —
/// never through role names — so the matrix can be customised per
/// shop from the Permissions screen without code changes.
///
/// Business rule from the master specification: purchase price,
/// product cost and profit are visible to Admin/Manager only.
/// That is expressed by [purchasePriceView], [productCostView] and
/// [profitView] defaulting to `false` for salesman below.
class AppRoles {
  const AppRoles._();

  static const String admin = 'admin';
  static const String manager = 'manager';
  static const String salesman = 'salesman';

  static const List<String> all = [admin, manager, salesman];

  static String displayName(String role) => switch (role) {
    admin => 'Admin',
    manager => 'Manager',
    salesman => 'Salesman',
    _ => role,
  };
}

/// Permission keys used across the app (dot style: area.action).
class AppPermissions {
  const AppPermissions._();

  static const String dashboardView = 'dashboard.view';
  static const String posUse = 'pos.use';
  static const String posPriceOverride = 'pos.price_override';
  static const String posCancelInvoice = 'pos.cancel_invoice';
  static const String productsView = 'products.view';
  static const String productsManage = 'products.manage';
  static const String purchaseView = 'purchase.view';
  static const String purchaseManage = 'purchase.manage';
  static const String purchasePriceView = 'purchase_price.view';
  static const String productCostView = 'product_cost.view';
  static const String profitView = 'profit.view';
  static const String customersManage = 'customers.manage';
  static const String suppliersManage = 'suppliers.manage';
  static const String accountsView = 'accounts.view';
  static const String expensesManage = 'expenses.manage';
  static const String reportsView = 'reports.view';
  static const String usersManage = 'users.manage';
  static const String settingsManage = 'settings.manage';
  static const String auditView = 'audit.view';
  static const String backupManage = 'backup.manage';

  /// All keys with the display names seeded into the database.
  static const Map<String, String> all = {
    dashboardView: 'View dashboard',
    posUse: 'Use POS billing',
    posPriceOverride: 'Sell below minimum price (override)',
    posCancelInvoice: 'Cancel invoice',
    productsView: 'View products',
    productsManage: 'Create/edit products',
    purchaseView: 'View purchases',
    purchaseManage: 'Create/edit purchases',
    purchasePriceView: 'View purchase price',
    productCostView: 'View product cost',
    profitView: 'View profit',
    customersManage: 'Manage customers',
    suppliersManage: 'Manage suppliers',
    accountsView: 'View accounts',
    expensesManage: 'Manage expenses',
    reportsView: 'View reports',
    usersManage: 'Manage users',
    settingsManage: 'Manage shop settings',
    auditView: 'View audit log',
    backupManage: 'Backup / restore',
  };

  /// Default matrix used when the database is first seeded.
  /// Admin gets everything; Manager everything except user
  /// management; Salesman gets selling-only access and can never
  /// see purchase price, cost or profit.
  static Map<String, bool> defaultsForRole(String role) {
    final result = <String, bool>{};
    for (final key in all.keys) {
      result[key] = switch (role) {
        AppRoles.admin => true,
        AppRoles.manager => key != usersManage,
        AppRoles.salesman =>
          key == dashboardView ||
              key == posUse ||
              key == productsView ||
              key == customersManage,
        _ => false,
      };
    }
    return result;
  }
}

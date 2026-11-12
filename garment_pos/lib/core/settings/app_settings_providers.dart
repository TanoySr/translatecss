import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../../data/repositories/settings_repository.dart';

/// Whether Retail Mode is enabled (Phase 2 setting, default OFF).
///
/// This only controls UI and rules for *new* transactions. Toggling
/// it never modifies existing invoices, products, stock or ledger
/// data — the value is a single settings row.
final retailModeProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(settingsRepositoryProvider)
      .watchString(AppConstants.settingRetailModeEnabled)
      .map((value) => value == 'true');
});

/// Auto-lock timeout in minutes (0 = disabled). Default 5 minutes.
final autoLockMinutesProvider = FutureProvider<int>((ref) async {
  final minutes = await ref
      .watch(settingsRepositoryProvider)
      .getInt(AppConstants.settingAutoLockMinutes);
  if (minutes == null || minutes < 0 || minutes > 120) return 5;
  return minutes;
});

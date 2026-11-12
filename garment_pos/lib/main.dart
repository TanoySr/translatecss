import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Garment POS entry point.
///
/// The whole application is offline-first: no network call is needed
/// to start, log in (Phase 2) or sell (Phase 5). Business data lives
/// in a local SQLite database opened lazily by
/// `appDatabaseProvider` (lib/data/database/database_provider.dart).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GarmentPosApp()));
}

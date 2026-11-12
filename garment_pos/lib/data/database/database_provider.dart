import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import 'app_database.dart';

/// Opens the on-device SQLite database file.
///
/// The file lives in the application documents directory, so it
/// survives app updates on Android and Windows and is included in
/// ordinary device backups. `NativeDatabase.createInBackground` runs
/// queries on a background isolate so the UI never blocks on disk I/O.
///
/// The native SQLite library itself is bundled by the `sqlite3` 3.x
/// package through Dart build hooks — the deprecated
/// `sqlite3_flutter_libs` package is deliberately not used.
QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}

/// The single [AppDatabase] instance for the whole application.
///
/// Tests override this provider with an in-memory database:
/// `AppDatabase(NativeDatabase.memory())`.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openDatabaseConnection());
  ref.onDispose(database.close);
  return database;
});

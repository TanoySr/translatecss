import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garment_pos/app.dart';
import 'package:garment_pos/core/localization/locale_provider.dart';
import 'package:garment_pos/data/database/app_database.dart';
import 'package:garment_pos/data/database/database_provider.dart';

void main() {
  testWidgets('app starts in Bengali and switches to English', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const GarmentPosApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Default language is Bengali.
    expect(find.text('গার্মেন্ট POS'), findsOneWidget);
    expect(find.text('ব্যবসার মডিউলসমূহ'), findsOneWidget);

    // Switching the locale re-renders every label in English and
    // persists the choice in the settings table.
    await container
        .read(localeProvider.notifier)
        .setLocale(AppLocales.english);
    await tester.pumpAndSettle();

    expect(find.text('Garment POS'), findsOneWidget);
    expect(find.text('Business Modules'), findsOneWidget);
  });
}

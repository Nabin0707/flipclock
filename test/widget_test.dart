// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_clean_architecture/core/providers/shared_preferences_provider.dart';
import 'package:flutter_clean_architecture/features/clock/providers/clock_provider.dart';
import 'package:flutter_clean_architecture/main.dart';
import 'package:flutter_clean_architecture/router/app_router.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Clock screen renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWith(
            (ref) => Stream<DateTime>.value(DateTime(2026, 4, 6, 10, 0, 0)),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Clock'), findsOneWidget);
  });

  testWidgets('Current route is preserved across rebuilds',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    Future<void> pumpApp() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            clockProvider.overrideWith(
              (ref) => Stream<DateTime>.value(DateTime(2026, 4, 6, 10, 0, 0)),
            ),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpApp();
    expect(find.text('Clock'), findsOneWidget);

    AppRouter.router.go(Routes.focus);
    await tester.pumpAndSettle();
    expect(find.text('Focus Mode'), findsOneWidget);

    // Simulate an app rebuild (similar effect to configuration changes).
    await pumpApp();
    expect(find.text('Focus Mode'), findsOneWidget);
  });
}

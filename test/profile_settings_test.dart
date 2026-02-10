import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/profile/profile_screen.dart';
import 'package:vidnoz_ai/features/profile/sections/app_prefs_section.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'package:vidnoz_ai/core/utils/haptics.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Profile Screen renders and toggles preferences', (WidgetTester tester) async {
    // 1. Setup Mock Prefs with default
    SharedPreferences.setMockInitialValues({}); // Defaults used

    // Set size
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.pumpAndSettle(); // Init

    // 2. Verify UI
    expect(find.text('Profile'), findsOneWidget);
    expect(find.byType(AppPrefsSection), findsOneWidget);

    // Check Haptics Toggle (Default is True)
    // Find SwitchListTile for Haptics
    final hapticsFinder = find.widgetWithText(SwitchListTile, 'Haptics');
    expect(hapticsFinder, findsOneWidget);

    SwitchListTile hapticsTile = tester.widget(hapticsFinder);
    expect(hapticsTile.value, isTrue);
    expect(AppHaptics.enabled, isTrue);

    // 3. Toggle Haptics OFF
    await tester.tap(hapticsFinder);
    await tester.pumpAndSettle();

    // Verify State Change
    hapticsTile = tester.widget(hapticsFinder);
    expect(hapticsTile.value, isFalse);
    expect(AppHaptics.enabled, isFalse);

    // 4. Test "Clear App Data"
    await tester.scrollUntilVisible(find.text('Clear App Data'), 100);
    await tester.tap(find.text('Clear App Data'));
    await tester.pumpAndSettle();

    // Verify Dialog
    expect(find.text('Clear All Data?'), findsOneWidget);

    // Confirm
    await tester.tap(find.text('Clear Data'));
    await tester.pumpAndSettle();

    // Verify SnackBar
    expect(find.text('App data cleared. Restarting...'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/create/create_screen.dart';
import 'package:vidnoz_ai/features/create/widgets/generate_progress_sheet.dart';
import 'package:vidnoz_ai/features/result/result_screen.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Generation Flow: Start -> Progress -> Result', (WidgetTester tester) async {
    // Set screen size to portrait to avoid overflow in ResultScreen layout
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Setup Wallet with sufficient tokens
    SharedPreferences.setMockInitialValues({
      PrefsKeys.walletTokens: jsonEncode({
        'balance': 100,
        'lifetimeSpent': 0,
        'lifetimePurchased': 0,
        'lastTransactionAt': DateTime.now().toIso8601String(),
      }),
    });

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));
    await tester.pumpAndSettle(); // Init

    // 2. Navigate to Review
    await tester.tap(find.text('Next')); // Upload -> Style
    await tester.pumpAndSettle();

    // Select Style
    final firstStyleKey = find.byKey(const ValueKey('style_card_t1'));
    await tester.scrollUntilVisible(firstStyleKey, 100);
    await tester.tap(firstStyleKey);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next')); // Style -> Duration
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next')); // Duration -> Review
    await tester.pumpAndSettle();

    // Confirm
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // 3. Generate
    await tester.tap(find.text('Generate'));
    await tester.pump(); // Trigger logic
    await tester.pump(const Duration(milliseconds: 100)); // Show sheet

    // Verify Progress Sheet
    expect(find.byType(GenerateProgressSheet), findsOneWidget);
    // Initial state is "Initializing..." before first stream event
    expect(find.text('Initializing...'), findsOneWidget);

    // 4. Wait for Completion
    // MockGenerationService takes 8-18s by default in MockConstants.
    // But tests run fast?
    // We used `MockConstants.useMockDelay = true`.
    // We should probably pump for a long time or rely on `pumpAndSettle`?
    // `pumpAndSettle` might timeout if stream is emitting periodically.
    // We need to pump frames manually to advance time.

    // Pump 20 seconds
    await tester.pump(const Duration(seconds: 20));
    await tester.pumpAndSettle();

    // Handle Random Failure (10% chance)
    if (find.text('Generation Failed').evaluate().isNotEmpty) {
      // Tap Retry
      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 20)); // Wait again
      await tester.pumpAndSettle();
    }

    // 5. Verify Result Screen
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('Generation Complete'), findsOneWidget);

    // Check if wallet deducted?
    // Hard to check from UI here as we are in ResultScreen.
    // ResultScreen has no wallet.
    // But flow succeeded.
  });
}

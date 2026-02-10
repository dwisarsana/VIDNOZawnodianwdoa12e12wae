import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/create/create_screen.dart';
import 'package:vidnoz_ai/features/profile/paywall/paywall_screen.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Paywall triggered on Low Tokens', (WidgetTester tester) async {
    // 1. Setup Wallet with 0 tokens
    SharedPreferences.setMockInitialValues({
      PrefsKeys.walletTokens: jsonEncode({
        'balance': 0,
        'lifetimeSpent': 0,
        'lifetimePurchased': 0,
        'lastTransactionAt': DateTime.now().toIso8601String(),
      }),
    });

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));
    await tester.pumpAndSettle(); // Init

    // 2. Navigate to Review (Step 4)
    // Step 1: Upload (mock proceed)
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 2: Style (Select one)
    // Tap first style
    final firstStyleKey = find.byKey(const ValueKey('style_card_t1'));
    await tester.scrollUntilVisible(firstStyleKey, 100);
    await tester.tap(firstStyleKey);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next')); // Go to Step 3
    await tester.pumpAndSettle();

    // Step 3: Duration
    await tester.tap(find.text('Next')); // Go to Step 4 (Review)
    await tester.pumpAndSettle();

    expect(find.text('Step 4/4'), findsOneWidget);

    // 3. Confirm Checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // 4. Click Generate
    // Should trigger check. Cost > 0. Balance 0.
    // Expect Paywall
    await tester.tap(find.text('Generate'));
    await tester.pumpAndSettle();

    // Verify Paywall Screen appears
    expect(find.byType(PaywallScreen), findsOneWidget);
    expect(find.text('Get More Tokens'), findsOneWidget);

    // 5. Mock Purchase (Starter Pack)
    // Paywall controller has delay 1500ms
    await tester.tap(find.text('Starter Pack'));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    // Should have popped Paywall
    expect(find.byType(PaywallScreen), findsNothing);

    // Should see success snackbar
    expect(find.text('Successfully added 20 tokens!'), findsOneWidget);

    // Wait for snackbar to disappear or handle queue
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Balance updated? Can't easily check internal state, but can try Generate again.
    // Cost for default settings ~10. Balance 20.
    // Generate should proceed.

    await tester.tap(find.text('Generate'));
    await tester.pumpAndSettle();

    // Should see "Generation Started! (Mock)"
    expect(find.text('Generation Started! (Mock)'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/create/create_screen.dart';
import 'package:vidnoz_ai/features/create/steps/duration_step.dart';
import 'package:vidnoz_ai/features/create/widgets/cost_breakdown_card.dart';

void main() {
  testWidgets('Duration Step and Cost Calculation UI Test', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));
    await tester.pump(const Duration(milliseconds: 600)); // Wait for template load
    await tester.pumpAndSettle();

    // 1. Navigate to Step 3 (Duration)
    // Step 1 -> Step 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 2 -> Step 3 (Select a template first to enable Next)
    // Assuming mock templates are loaded and displayed.
    // Tap the first template card
    // We need to find a StyleCard.
    // But since we can't easily find by type without context if offstage,
    // let's just tap the first GestureDetector inside the GridView if possible or use a key.
    // However, finding "Eternal Romance" text from MockTemplateData should work.

    // Find the first style card by key
    final firstStyleKey = find.byKey(const ValueKey('style_card_t1')); // 'Eternal Romance' is t1
    await tester.scrollUntilVisible(firstStyleKey, 100);
    await tester.tap(firstStyleKey);
    await tester.pumpAndSettle(); // Select template

    // Note: In CreateController, selectTemplate does NOT automatically advance step.
    // It updates state and persists.
    // So we need to tap Next again to go to Step 3.

    // Check Next is enabled (by tapping it)
    // Sometimes tap fails if button is disabled in previous frames and rebuild is delayed?
    // Let's pump again
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // 2. Verify Step 3 Content
    expect(find.text('Step 3/4'), findsOneWidget);
    expect(find.byType(DurationStep), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Quality'), findsOneWidget);

    // 3. Verify Cost Breakdown presence
    expect(find.byType(CostBreakdownCard), findsOneWidget);
    expect(find.text('Token Cost Breakdown'), findsOneWidget);

    // Initial Cost Check (Default 5s = 10 base, Standard = x1, No addons)
    // Wait, "Eternal Romance" has default settings.
    // defaultSettings: duration 5s, quality Standard, moodIntensity 0.7.
    // Addons: none by default in that mock except maybe if we added logic.
    // Cost formula: base(5s)=10. multiplier(std)=1. addons=0.
    // Total = 10.
    // Check for "10" text near token icon.
    // Note: CostBreakdownCard shows "Total Estimated" then "10".

    expect(find.text('10'), findsAtLeastNWidgets(1)); // Base cost row and Total row might both say 10

    // 4. Change Duration to 8s
    await tester.tap(find.text('8s'));
    await tester.pumpAndSettle();

    // Cost should update. 8s = 16 base. Total 16.
    expect(find.text('16'), findsAtLeastNWidgets(1));

    // 5. Toggle Enhancement (Cinematic Motion +2)
    // Find SwitchListTile for 'Cinematic Motion'
    // It might need scrolling if screen small

    // Tap the SwitchListTile specifically to avoid ambiguity with CostBreakdownCard
    // Use ensureVisible first
    final switchTile = find.widgetWithText(SwitchListTile, 'Cinematic Motion');
    await tester.ensureVisible(switchTile);
    await tester.tap(switchTile, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Cost: 16 + 2 = 18.
    expect(find.text('18'), findsOneWidget);

  });
}

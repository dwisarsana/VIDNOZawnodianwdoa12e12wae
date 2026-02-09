import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/create/create_screen.dart';
import 'package:vidnoz_ai/features/create/widgets/step_header.dart';
import 'package:vidnoz_ai/features/create/steps/upload_step.dart';
import 'package:vidnoz_ai/features/create/steps/style_step.dart';
import 'package:vidnoz_ai/core/widgets/bottom_action_bar.dart';
import 'package:vidnoz_ai/core/widgets/glass_button.dart';
import 'package:vidnoz_ai/core/widgets/secondary_button.dart';

void main() {
  testWidgets('Create Wizard Navigation flow', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));
    await tester.pumpAndSettle(); // Wait for controller init

    // 1. Initial State: Step 1 (Upload)
    expect(find.text('Step 1/4'), findsOneWidget);
    expect(find.byType(UploadStep), findsOneWidget);
    expect(find.byType(StyleStep), findsNothing); // IndexedStack hides it but it might be in tree? IndexedStack children are in tree but offstage.
    // Actually find.byType finds offstage widgets too usually unless skipOffstage is true (default is true).
    // Let's check text content of visible step
    expect(find.text('Step 1: Upload Photos (Placeholder)'), findsOneWidget);

    // Bottom Bar
    expect(find.byType(BottomActionBar), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Back'), findsNothing); // First step has no back button

    // 2. Click Next
    // Ensure the button is enabled and found
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle(); // Wait for animation

    // 3. Step 2 (Style)
    // Note: IndexedStack keeps all children alive, but only one visible.
    // However, find.text might find offstage widgets if not careful.
    // Standard flutter_test finds only onscreen widgets by default.
    // If nextStep() failed, we would still be on Step 1.
    // Check if we advanced.
    expect(find.text('Step 2/4'), findsOneWidget);
    expect(find.text('Step 2: Choose Style (Placeholder)'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget); // Back button appears

    // 4. Click Back
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // 5. Back to Step 1
    expect(find.text('Step 1/4'), findsOneWidget);
    expect(find.text('Step 1: Upload Photos (Placeholder)'), findsOneWidget);
  });
}

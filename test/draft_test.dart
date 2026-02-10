import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/create/create_screen.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Draft Resume/Discard Dialog appears when draft exists', (WidgetTester tester) async {
    // 1. Mock SharedPreferences with a pre-existing draft
    final mockDraft = {
      'selectedImages': ['path/to/img1.jpg'],
      'templateId': 't1',
      'styleId': null,
      'durationSeconds': 5,
      'quality': 0, // standard
      'enhancementFlags': false,
      'decorationLevel': 0.5,
      'cameraMotion': true,
      'moodIntensity': 0.5,
      'estimatedCost': 10,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    SharedPreferences.setMockInitialValues({
      PrefsKeys.wizardDraftJson: jsonEncode(mockDraft),
    });

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));

    // Wait for init and repository checks
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // 2. Verify Dialog Appears
    expect(find.text('Resume Draft?'), findsOneWidget);
    expect(find.text('You have an unsaved project draft. Would you like to resume it?'), findsOneWidget);

    // 3. Test Discard
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('Resume Draft?'), findsNothing);

    // Verify draft cleared (cannot verify prefs direct write easily without mock spy, but UI behaves correctly)
  });

  testWidgets('Draft Resume restores state', (WidgetTester tester) async {
    final mockDraft = {
      'selectedImages': ['path/to/img1.jpg'],
      'templateId': 't1',
      'styleId': null,
      'durationSeconds': 12, // Distinct value
      'quality': 0,
      'enhancementFlags': false,
      'decorationLevel': 0.5,
      'cameraMotion': true,
      'moodIntensity': 0.5,
      'estimatedCost': 24, // 12s cost
      'updatedAt': DateTime.now().toIso8601String(),
    };

    SharedPreferences.setMockInitialValues({
      PrefsKeys.wizardDraftJson: jsonEncode(mockDraft),
    });

    await tester.pumpWidget(const MaterialApp(home: CreateScreen()));

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Resume
    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    // Check if state restored (Step should be potentially 0, but fields populated)
    // Wait, CreateController init state is step 0. restoreDraft doesn't change step explicitly?
    // Let's check CreateController.restoreDraft code.
    // It updates settings, templateId, etc.
    // It does NOT change currentStep. So user starts at Upload step but with data.

    // Verify Template is selected (t1 = Eternal Romance)
    // Navigate to Style step (Step 2)
    // Need to click Next. Step 1 needs image. Draft has image path.
    // CanProceed should be true.

    // Note: UploadStep UI might mock image if path invalid, but controller has it.

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Should be on Step 2 (Style)
    expect(find.text('Step 2/4'), findsOneWidget);

    // Check if t1 is selected.
    // We can check if "Next" is enabled? (It requires selection)
    // Or check UI state if visible.

    // Let's check Duration (Step 3) since we set it to 12s
    await tester.tap(find.text('Next')); // Go to Step 3
    await tester.pumpAndSettle();

    expect(find.text('Step 3/4'), findsOneWidget);

    // Find 12s chip selected.
    // GlassChip displays label '12s'.
    // We can check if '12s' chip is selected.
    // How to check selection?
    // GlassChip implementation: color changes.
    // Hard to test via finder properties unless we exposed it.

    // But CostBreakdown should show base cost for 12s => 24 tokens.
    // Let's check cost text "24".

    expect(find.text('24'), findsAtLeastNWidgets(1));
  });
}

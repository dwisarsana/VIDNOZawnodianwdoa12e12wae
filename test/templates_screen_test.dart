import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/templates/templates_screen.dart';
import 'package:vidnoz_ai/features/templates/widgets/category_tabs.dart';
import 'package:vidnoz_ai/features/templates/widgets/template_grid_item.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Templates Screen loads and displays categories/grid', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Init shared prefs for controller
    SharedPreferences.setMockInitialValues({});

    // We render TemplatesScreen directly (without RootShell to isolate)
    bool useTemplateCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: TemplatesScreen(
        onUseTemplate: (t) {
          useTemplateCalled = true;
        },
      ),
    ));

    // Wait for Mock Repo (500ms)
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // 1. Verify UI
    expect(find.text('Templates'), findsOneWidget);
    expect(find.byType(CategoryTabs), findsOneWidget);
    expect(find.text('All'), findsOneWidget);

    // Featured hero should be visible (mock data has premium template)
    // "Eternal Romance" is t1 (not premium).
    // "Cyberpunk City" is t2 (premium).
    // Featured picks first premium.
    // Check for "FEATURED" badge
    expect(find.text('FEATURED'), findsOneWidget);

    // 2. Check Grid
    expect(find.byType(TemplateGridItem), findsWidgets);

    // 3. Test Filter
    // Tap "Cinematic" category (assuming mock data has it)
    // Find glass chip for "Cinematic"
    await tester.scrollUntilVisible(find.text('Cinematic'), 100, scrollable: find.descendant(of: find.byType(CategoryTabs), matching: find.byType(Scrollable)));
    await tester.tap(find.text('Cinematic'));
    await tester.pumpAndSettle();

    // Verify only cinematic items are shown?
    // Hard to verify count without knowing exact mock data count, but UI shouldn't crash.

    // 4. Test Use Template
    // Find a grid item and tap it
    // Grid items usually have "PRO" or Name.
    // Let's find "Documentary" (t5) if visible or just first one.
    // "Documentary" is category "Documentary".
    // We are on "Cinematic" tab. "Cinematic Epic" (t4) should be there.

    await tester.tap(find.text('Cinematic Epic'));
    await tester.pumpAndSettle();

    // Should open Preview Sheet
    expect(find.text('Use Template'), findsOneWidget);

    // Tap Use Template
    await tester.tap(find.text('Use Template'));
    await tester.pumpAndSettle();

    // Verify callback
    expect(useTemplateCalled, isTrue);
  });
}

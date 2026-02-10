import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/projects/projects_screen.dart';
import 'package:vidnoz_ai/features/projects/widgets/project_list_item.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Projects Screen renders tabs and list', (WidgetTester tester) async {
    // 1. Setup Mock Projects
    final mockProject = {
      'id': 'p1',
      'title': 'Awesome Video',
      'thumbnailPath': '',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'styleId': 't1',
      'styleName': 'Romantic',
      'durationSeconds': 5,
      'quality': 0,
      'tokenCostEstimated': 10,
      'tokenCostCharged': 10,
      'status': 2, // success
      'favorite': false,
    };

    SharedPreferences.setMockInitialValues({
      PrefsKeys.projectsHistoryJson: jsonEncode([mockProject]),
    });

    // Set size to avoid overflow
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: ProjectsScreen()));
    await tester.pumpAndSettle();

    // 2. Verify Tabs
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Drafts'), findsOneWidget);

    // 3. Verify List Item
    expect(find.text('Awesome Video'), findsOneWidget);
    expect(find.byType(ProjectListItem), findsOneWidget);

    // 4. Test Filter (Search)
    await tester.enterText(find.byType(TextField), 'Nothing');
    await tester.pumpAndSettle();

    expect(find.text('Awesome Video'), findsNothing);
    expect(find.text('You haven\'t created any videos yet.'), findsOneWidget); // Empty state

    await tester.enterText(find.byType(TextField), 'Awesome');
    await tester.pumpAndSettle();
    expect(find.text('Awesome Video'), findsOneWidget);

    // 5. Test Tab Switching
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Awesome Video'), findsNothing); // Not favorite
    expect(find.text('No favorites yet.'), findsOneWidget);

    // 6. Test Favorite Action
    // Go back to All
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    // Open menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap Favorite
    await tester.tap(find.text('Favorite'));
    await tester.pumpAndSettle();

    // Go to Favorites tab
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();

    // Should be present now
    expect(find.text('Awesome Video'), findsOneWidget);
  });
}

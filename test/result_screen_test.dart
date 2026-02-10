import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/features/result/result_screen.dart';
import 'package:vidnoz_ai/features/result/widgets/action_row.dart';
import 'package:vidnoz_ai/features/result/widgets/prompt_snapshot_panel.dart';
import 'package:vidnoz_ai/app/constants/prefs_keys.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'package:vidnoz_ai/domain/enums/project_status.dart';
import 'dart:convert';

void main() {
  setUp(() {
    SharedPrefsService.reset();
  });

  testWidgets('Result Screen displays project details and actions', (WidgetTester tester) async {
    // Set portrait size
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Setup Mock Project in History
    final mockProject = {
      'id': 'p1',
      'title': 'Test Project',
      'thumbnailPath': 'assets/mock/thumb.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'styleId': 't1',
      'styleName': 'Eternal Romance',
      'durationSeconds': 5,
      'quality': 0, // standard
      'tokenCostEstimated': 10,
      'tokenCostCharged': 10,
      'status': 2, // success
      'mockVideoUrlOrPath': 'assets/mock/video.mp4',
      'settingsSnapshotJson': null,
    };

    SharedPreferences.setMockInitialValues({
      PrefsKeys.projectsHistoryJson: jsonEncode([mockProject]),
    });

    // 2. Pump ResultScreen with projectId
    await tester.pumpWidget(const MaterialApp(home: ResultScreen(projectId: 'p1')));
    await tester.pumpAndSettle(); // Wait for controller load

    // 3. Verify UI Elements
    expect(find.text('Result Studio'), findsOneWidget);
    expect(find.text('Your masterpiece is ready!'), findsOneWidget);

    // Metadata Chips
    expect(find.text('Eternal Romance'), findsOneWidget);
    expect(find.text('5s'), findsOneWidget);
    expect(find.text('STANDARD'), findsOneWidget);

    // Action Row
    expect(find.byType(ActionRow), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Remix'), findsOneWidget);

    // Prompt Panel
    expect(find.byType(PromptSnapshotPanel), findsOneWidget);
    expect(find.text('Settings Snapshot'), findsOneWidget);

    // 4. Test Expand Panel
    await tester.tap(find.text('Settings Snapshot'));
    await tester.pumpAndSettle();
    expect(find.text('Token Cost'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidnoz_ai/main.dart';
import 'package:vidnoz_ai/core/widgets/app_scaffold.dart';
import 'package:vidnoz_ai/core/widgets/glass_card.dart';
import 'package:vidnoz_ai/data/local/shared_prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts and shows placeholder', (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const VidnozAIApp());
    await tester.pumpAndSettle();

    expect(find.text('Phase 1 Complete'), findsOneWidget);
    expect(find.byType(AppScaffold), findsOneWidget);
    expect(find.byType(GlassCard), findsOneWidget);
  });
}

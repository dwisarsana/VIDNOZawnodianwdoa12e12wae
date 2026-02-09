import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidnoz_ai/main.dart';
import 'package:vidnoz_ai/features/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('App starts with Splash and navigates to Onboarding by default', (WidgetTester tester) async {
    // Mock SharedPreferences - onboarding_done = false (default)
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const VidnozAIApp());

    // Splash Screen logic involves delay
    // Advance time by 2 seconds to cover the 1500ms splash delay
    await tester.pump(const Duration(seconds: 2));

    // Allow navigation transition to complete
    await tester.pumpAndSettle();

    // Should find Onboarding Screen content
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Create cinematic AI videos from your photos'), findsOneWidget);
  });
}

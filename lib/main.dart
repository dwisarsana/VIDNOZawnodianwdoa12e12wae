import 'package:flutter/material.dart';
import 'app/constants/app_constants.dart';
import 'app/theme/app_theme.dart';
import 'core/widgets/app_scaffold.dart';
import 'core/widgets/glass_card.dart';
import 'core/widgets/glass_button.dart';
import 'data/local/shared_prefs_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.getInstance();

  runApp(const VidnozAIApp());
}

class VidnozAIApp extends StatelessWidget {
  const VidnozAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PlaceholderHome(),
    );
  }
}

class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: GlassCard(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Phase 1 Complete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Foundation, Theme, Models, and Persistence are ready.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              GlassButton(
                text: 'Start Phase 2',
                isPrimary: true,
                onPressed: () {
                  // Next phase
                  print('Phase 2 Triggered');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

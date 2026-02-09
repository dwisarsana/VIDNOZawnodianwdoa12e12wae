import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/constants/app_constants.dart';
import 'app/theme/app_theme.dart';
import 'data/local/shared_prefs_service.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce preferred orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Shared Prefs
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
      home: const SplashScreen(),
    );
  }
}

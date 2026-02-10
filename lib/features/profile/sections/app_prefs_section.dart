import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../domain/models/app_preferences.dart';

class AppPrefsSection extends StatelessWidget {
  final AppPreferences prefs;
  final ValueChanged<bool> onHapticsChanged;
  final ValueChanged<bool> onAutoSaveChanged;
  final ValueChanged<bool> onReducedMotionChanged;

  const AppPrefsSection({
    super.key,
    required this.prefs,
    required this.onHapticsChanged,
    required this.onAutoSaveChanged,
    required this.onReducedMotionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preferences', style: AppTypography.h3),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Haptics', style: AppTypography.body),
            value: prefs.hapticsEnabled,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: onHapticsChanged,
          ),
          SwitchListTile(
            title: const Text('Auto-save Drafts', style: AppTypography.body),
            value: prefs.autoSaveDrafts,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: onAutoSaveChanged,
          ),
          SwitchListTile(
            title: const Text('Reduced Motion', style: AppTypography.body),
            value: prefs.reducedMotion,
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: onReducedMotionChanged,
          ),
        ],
      ),
    );
  }
}

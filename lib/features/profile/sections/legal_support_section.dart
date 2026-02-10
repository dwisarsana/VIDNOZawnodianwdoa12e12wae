import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';

class LegalSupportSection extends StatelessWidget {
  const LegalSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support & Legal', style: AppTypography.h3),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Privacy Policy', style: AppTypography.body),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // Mock URL Launch
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Privacy Policy...')),
              );
            },
          ),
          ListTile(
            title: const Text('Terms of Service', style: AppTypography.body),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Terms...')),
              );
            },
          ),
          ListTile(
            title: const Text('Contact Support', style: AppTypography.body),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contacting Support...')),
              );
            },
          ),
        ],
      ),
    );
  }
}

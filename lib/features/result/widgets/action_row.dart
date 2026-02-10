import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/secondary_button.dart';

class ActionRow extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onRemix;

  const ActionRow({
    super.key,
    required this.onSave,
    required this.onShare,
    required this.onRemix,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: 'Save',
            icon: const Icon(Icons.download, size: 20),
            onPressed: onSave,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SecondaryButton(
            text: 'Share',
            icon: const Icon(Icons.share, size: 20),
            onPressed: onShare,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SecondaryButton(
            text: 'Remix',
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: onRemix,
          ),
        ),
      ],
    );
  }
}

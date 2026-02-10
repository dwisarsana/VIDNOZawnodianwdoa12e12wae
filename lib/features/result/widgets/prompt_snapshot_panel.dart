import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../domain/models/generation_settings.dart';
import '../../../../domain/models/project_item.dart';

class PromptSnapshotPanel extends StatefulWidget {
  final ProjectItem project;

  const PromptSnapshotPanel({super.key, required this.project});

  @override
  State<PromptSnapshotPanel> createState() => _PromptSnapshotPanelState();
}

class _PromptSnapshotPanelState extends State<PromptSnapshotPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Reconstruct settings from JSON for display
    GenerationSettings? settings;
    if (widget.project.settingsSnapshotJson != null) {
      settings = GenerationSettings.fromJson(widget.project.settingsSnapshotJson!);
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text('Settings Snapshot', style: AppTypography.h3.copyWith(fontSize: 16)),
        trailing: Icon(
          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: AppColors.textSecondary,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow('Style', widget.project.styleName),
                _DetailRow('Duration', '${widget.project.durationSeconds}s'),
                if (settings != null) ...[
                  _DetailRow('Quality', settings.quality.toString().split('.').last),
                  if (settings.cinematicMotion) _DetailRow('Enhancements', 'Cinematic Motion'),
                  if (settings.includeTransitions) _DetailRow('Enhancements', 'Transitions'),
                ],
                const SizedBox(height: 8),
                _DetailRow('Token Cost', '${widget.project.tokenCostCharged}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
          Text(value, style: AppTypography.body.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}

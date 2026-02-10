import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radii.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/glass_chip.dart';
import '../../../../domain/enums/duration_option.dart';
import '../create_controller.dart';

class DurationSelector extends StatelessWidget {
  final int selectedSeconds;
  final ValueChanged<int> onDurationChanged;

  const DurationSelector({
    super.key,
    required this.selectedSeconds,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Duration',
            style: AppTypography.h3,
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: DurationOption.values.map((option) {
            return GlassChip(
              label: '${option.seconds}s',
              isSelected: selectedSeconds == option.seconds,
              onSelected: () => onDurationChanged(option.seconds),
            );
          }).toList(),
        ),
      ],
    );
  }
}

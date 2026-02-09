import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../create_controller.dart';
import '../widgets/style_card.dart';

class StyleStep extends StatelessWidget {
  final CreateController controller;

  const StyleStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.state.isLoadingTemplates) {
      return const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primary)),
      );
    }

    final templates = controller.state.templates;
    final selectedId = controller.state.selectedTemplateId;

    if (templates.isEmpty) {
      return const Center(child: Text('No templates available.', style: AppTypography.body));
    }

    // Grid layout for templates
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75, // Taller for cinematic feel
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return GestureDetector(
          onTap: () => controller.selectTemplate(template.id),
          child: StyleCard(
            template: template,
            isSelected: template.id == selectedId,
            onTap: () => controller.selectTemplate(template.id),
          ),
        );
      },
    );
  }
}

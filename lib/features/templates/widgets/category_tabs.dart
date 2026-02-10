import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_chip.dart';
import '../../../../domain/enums/template_category.dart';

class CategoryTabs extends StatelessWidget {
  final TemplateCategory? selectedCategory;
  final ValueChanged<TemplateCategory?> onSelect;

  const CategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          GlassChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onSelected: () => onSelect(null),
          ),
          const SizedBox(width: 12),
          ...TemplateCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GlassChip(
                label: category.toString().split('.').last.capitalize(),
                isSelected: selectedCategory == category,
                onSelected: () => onSelect(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

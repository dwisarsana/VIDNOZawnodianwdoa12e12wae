import 'package:flutter/foundation.dart';
import '../../domain/enums/template_category.dart';
import '../../domain/models/template_item.dart';

@immutable
class TemplatesState {
  final List<TemplateItem> templates;
  final List<TemplateItem> filteredTemplates;
  final bool isLoading;
  final TemplateCategory? selectedCategory; // null = all
  final TemplateItem? featuredTemplate;

  const TemplatesState({
    this.templates = const [],
    this.filteredTemplates = const [],
    this.isLoading = true,
    this.selectedCategory,
    this.featuredTemplate,
  });

  TemplatesState copyWith({
    List<TemplateItem>? templates,
    List<TemplateItem>? filteredTemplates,
    bool? isLoading,
    TemplateCategory? selectedCategory,
    TemplateItem? featuredTemplate,
  }) {
    return TemplatesState(
      templates: templates ?? this.templates,
      filteredTemplates: filteredTemplates ?? this.filteredTemplates,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      featuredTemplate: featuredTemplate ?? this.featuredTemplate,
    );
  }
}

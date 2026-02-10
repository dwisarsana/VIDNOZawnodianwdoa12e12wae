import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/template_repository.dart';
import '../../domain/models/template_item.dart';
import 'templates_controller.dart';
import 'widgets/category_tabs.dart';
import 'widgets/template_grid_item.dart';
import 'widgets/template_hero_card.dart';

class TemplatesScreen extends StatefulWidget {
  final Function(TemplateItem)? onUseTemplate;

  const TemplatesScreen({super.key, this.onUseTemplate});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  TemplatesController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // In real app, inject repository
    // Since TemplateRepository is stateless mock, new instance is fine.
    final repo = TemplateRepository();
    if (!mounted) return;
    setState(() {
      _controller = TemplatesController(repo);
    });
  }

  void _handleUseTemplate(TemplateItem template) {
    if (widget.onUseTemplate != null) {
      widget.onUseTemplate!(template);
    } else {
      // Fallback: Notify parent via context or other means?
      // Since RootShell builds this, we can't easily reach up without explicit callback passing.
      // We will update RootShell to pass this callback.
      print('Use Template: ${template.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, _) {
          final state = _controller!.state;

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Categories
              CategoryTabs(
                selectedCategory: state.selectedCategory,
                onSelect: _controller!.setCategory,
              ),

              // Content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Featured
                          if (state.selectedCategory == null && state.featuredTemplate != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: TemplateHeroCard(
                                template: state.featuredTemplate!,
                                onUseTemplate: () => _handleUseTemplate(state.featuredTemplate!),
                              ),
                            ),
                        ]),
                      ),
                    ),

                    // Grid
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final template = state.filteredTemplates[index];
                            return TemplateGridItem(
                              template: template,
                              onTap: () {
                                _showPreviewSheet(context, template);
                              },
                            );
                          },
                          childCount: state.filteredTemplates.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPreviewSheet(BuildContext context, TemplateItem template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Preview Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(
                  template.previewAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black26),
                ),
              ),
            ),

            // Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(template.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(template.subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _handleUseTemplate(template);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Use Template'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

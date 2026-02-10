import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/glass_button.dart';
import '../../core/widgets/glass_chip.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/project_repository.dart';
import '../create/create_controller.dart';
import 'result_controller.dart';
import 'widgets/action_row.dart';
import 'widgets/prompt_snapshot_panel.dart';
import 'widgets/video_preview_card.dart';

class ResultScreen extends StatefulWidget {
  final String? resultPath;
  final String projectId;

  const ResultScreen({
    super.key,
    this.resultPath,
    required this.projectId,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    final repo = ProjectRepository(prefs);
    if (!mounted) return;

    final controller = ResultController(repo);
    // Load project if ID exists
    if (widget.projectId.isNotEmpty) {
      await controller.loadProject(widget.projectId);
    }

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _controller!.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final project = _controller!.project;
    if (project == null) {
      // Fallback if project not found (e.g. freshly generated without ID passed correctly in mock?)
      // Actually Phase 8 passed ID.
      // But let's handle graceful error.
      return const Scaffold(body: Center(child: Text('Project not found')));
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Result Studio'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      child: Column(
        children: [
          // Video Preview
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: VideoPreviewCard(path: widget.resultPath ?? project.mockVideoUrlOrPath),
            ),
          ),

          // Metadata Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GlassChip(label: project.styleName, icon: const Icon(Icons.style, size: 14, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                GlassChip(label: '${project.durationSeconds}s', icon: const Icon(Icons.timer, size: 14, color: AppColors.textSecondary)),
                const SizedBox(width: 8),
                GlassChip(label: project.quality.toString().split('.').last.toUpperCase(), icon: const Icon(Icons.hd, size: 14, color: AppColors.textSecondary)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions & Details
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your masterpiece is ready!', style: AppTypography.h2),
                    const SizedBox(height: 24),

                    ActionRow(
                      onSave: _controller!.saveVideo,
                      onShare: _controller!.shareVideo,
                      onRemix: () {
                        // Remix Logic:
                        // 1. Pop to root
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // 2. We need to tell CreateController to apply settings.
                        // Since CreateScreen is in the Shell, we can't easily access its state from here
                        // unless we use a global bus or passed callback.
                        // However, prompt says "Use template -> deep link to Create".
                        // Remix is similar.
                        // For Phase 9, we mock this by just popping.
                        // Phase 11 will handle Deep Links properly.
                        // But let's try to notify if possible?
                        // Actually, we can't easily.
                        // Let's just pop for now and log it.
                        print('Remix requested for project ${project.id}');
                      },
                    ),

                    const SizedBox(height: 24),
                    PromptSnapshotPanel(project: project),

                    const SizedBox(height: 24),
                    GlassButton(
                      text: 'Create Another Video',
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

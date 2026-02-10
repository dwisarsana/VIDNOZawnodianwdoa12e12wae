import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../data/local/shared_prefs_service.dart';
import '../../data/repositories/project_repository.dart';
import 'projects_controller.dart';
import 'widgets/project_filter_bar.dart';
import 'widgets/project_list_item.dart';
import 'widgets/project_empty_state.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProjectsController? _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _init();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.animation!.value == _tabController.index) {
        _controller?.setTab(_tabController.index);
      }
    });
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    final repo = ProjectRepository(prefs);
    if (!mounted) return;
    setState(() {
      _controller = ProjectsController(repo);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Drafts'),
            Tab(text: 'Failed'),
          ],
        ),
      ),
      child: Column(
        children: [
          // Filter Bar
          AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) => ProjectFilterBar(
              currentSort: _controller!.state.sortOption,
              onSearchChanged: _controller!.setSearchQuery,
              onSortChanged: _controller!.setSortOption,
            ),
          ),

          // List
          Expanded(
            child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                final state = _controller!.state;
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.filteredProjects.isEmpty) {
                  return _buildEmptyState(state.selectedTab);
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100), // Space for nav bar
                  itemCount: state.filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = state.filteredProjects[index];
                    return ProjectListItem(
                      project: project,
                      onTap: () {
                        // Navigate to Result or Detail
                        // For drafts, maybe Create?
                        // For success, ResultScreen?
                        // Implement navigation logic here or later
                      },
                      onFavorite: () => _controller!.toggleFavorite(project.id),
                      onDelete: () => _controller!.deleteProject(project.id),
                      onDuplicate: () {
                        _controller!.duplicateProject(project.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Project duplicated as draft')),
                        );
                      },
                      onShare: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return const ProjectEmptyState(message: 'No favorites yet.');
      case 2:
        return const ProjectEmptyState(message: 'No drafts saved.');
      case 3:
        return const ProjectEmptyState(message: 'No failed projects.');
      default:
        return const ProjectEmptyState(
          message: 'You haven\'t created any videos yet.',
          actionLabel: 'Create New',
          // onAction: ... navigate to create tab?
        );
    }
  }
}

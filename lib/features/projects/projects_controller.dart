import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/project_repository.dart';
import '../../domain/enums/project_sort_option.dart';
import '../../domain/enums/project_status.dart';
import '../../domain/models/project_item.dart';
import 'projects_state.dart';

class ProjectsController extends ChangeNotifier {
  final ProjectRepository _repo;
  ProjectsState _state = const ProjectsState();

  ProjectsController(this._repo) {
    loadProjects();
  }

  ProjectsState get state => _state;

  Future<void> loadProjects() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await _refreshList();
  }

  Future<void> _refreshList() async {
    final allProjects = await _repo.getProjects();
    _state = _state.copyWith(
      projects: allProjects,
      isLoading: false,
    );
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _state = _state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setSortOption(ProjectSortOption option) {
    _state = _state.copyWith(sortOption: option);
    _applyFilters();
  }

  void setTab(int index) {
    _state = _state.copyWith(selectedTab: index);
    _applyFilters();
  }

  Future<void> toggleFavorite(String id) async {
    final project = await _repo.getProjectById(id);
    if (project != null) {
      final updated = project.copyWith(favorite: !project.favorite);
      await _repo.saveProject(updated);
      await _refreshList();
    }
  }

  Future<void> deleteProject(String id) async {
    await _repo.deleteProject(id);
    await _refreshList();
  }

  Future<void> duplicateProject(String id) async {
    final project = await _repo.getProjectById(id);
    if (project != null) {
      final newProject = ProjectItem(
        id: const Uuid().v4(),
        title: '${project.title} (Copy)',
        thumbnailPath: project.thumbnailPath,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        styleId: project.styleId,
        styleName: project.styleName,
        durationSeconds: project.durationSeconds,
        quality: project.quality,
        tokenCostEstimated: project.tokenCostEstimated,
        tokenCostCharged: 0, // Draft copy hasn't charged yet logic?
        // Prompt says "Duplicate to create".
        // If we duplicate as a LIST item, it should probably be 'draft' or 'queued'?
        // Let's make it a 'draft' status so user can edit it.
        status: ProjectStatus.draft,
        settingsSnapshotJson: project.settingsSnapshotJson,
        favorite: false,
      );
      await _repo.saveProject(newProject);
      await _refreshList();
    }
  }

  void _applyFilters() {
    // 1. Tab Filter
    List<ProjectItem> result;
    switch (_state.selectedTab) {
      case 1: // Favorites
        result = _state.projects.where((p) => p.favorite).toList();
        break;
      case 2: // Drafts
        result = _state.projects.where((p) => p.status == ProjectStatus.draft).toList();
        break;
      case 3: // Failed
        result = _state.projects.where((p) => p.status == ProjectStatus.failed).toList();
        break;
      case 0: // All
      default:
        // "All" typically shows completed/processing? Or everything?
        // Usually "All" includes everything except maybe deleted.
        result = List.from(_state.projects);
        break;
    }

    // 2. Search Filter
    if (_state.searchQuery.isNotEmpty) {
      final q = _state.searchQuery.toLowerCase();
      result = result.where((p) =>
        p.title.toLowerCase().contains(q) ||
        p.styleName.toLowerCase().contains(q)
      ).toList();
    }

    // 3. Sort
    result.sort((a, b) {
      switch (_state.sortOption) {
        case ProjectSortOption.newest:
          return b.createdAt.compareTo(a.createdAt);
        case ProjectSortOption.oldest:
          return a.createdAt.compareTo(b.createdAt);
        case ProjectSortOption.longestDuration:
          return b.durationSeconds.compareTo(a.durationSeconds);
        case ProjectSortOption.shortestDuration:
          return a.durationSeconds.compareTo(b.durationSeconds);
      }
    });

    _state = _state.copyWith(filteredProjects: result);
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import '../../domain/enums/project_sort_option.dart';
import '../../domain/models/project_item.dart';

@immutable
class ProjectsState {
  final List<ProjectItem> projects;
  final List<ProjectItem> filteredProjects;
  final bool isLoading;
  final String searchQuery;
  final ProjectSortOption sortOption;
  final int selectedTab; // 0: All, 1: Favorites, 2: Drafts, 3: Failed

  const ProjectsState({
    this.projects = const [],
    this.filteredProjects = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.sortOption = ProjectSortOption.newest,
    this.selectedTab = 0,
  });

  ProjectsState copyWith({
    List<ProjectItem>? projects,
    List<ProjectItem>? filteredProjects,
    bool? isLoading,
    String? searchQuery,
    ProjectSortOption? sortOption,
    int? selectedTab,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
